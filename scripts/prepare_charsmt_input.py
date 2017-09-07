#!/usr/bin/python

####
## This script takes the unknown file output by Moses (--output-unknown argument)
## and converts it into input to a character SMT system for spellign correction
## Author: shamil.cm@gmail.com


import sys
import math

# input: unknowns file output by first-pass Moses decoding (using --output-unknown argument)
# output: (stdout) one potentially misspelled word per line, character-separated

if (len(sys.argv)<1):
	print >> sys.stderr, "Usage: prepare_charsmt_input.py unknown-file-moses"
	sys.exit()

unknowns_file=sys.argv[1]

# load the unknown words to dict to avoid duplicates
unk_words = dict()
with open(unknowns_file) as f:
    for line in f:
        line = line.strip();
		# get the input words (and factors if present, e.g. misspalling|3 grmmar|23 )
        words_factors = line.split()
        for word_factor in words_factors:
			# extract the potentially misspelled word
            word = word_factor.split('|')[0]
			# only correct if it does not contain special characters
            if any(c in word for c in "0123456789.,/-\'\""):
                print >> sys.stderr, "Skip Correcting:" + word
            else:
                unk_words[word] = True

# print character separated unique list of unknown words, to be written to a file
for word in unk_words:
    print " ".join(word)

