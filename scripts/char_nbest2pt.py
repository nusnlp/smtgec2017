#!/usr/bin/python


####
# This script extracts the correction candidates (n-best) list 
# of a character SMT system and then makes a word-level phrase-table
# Author: shamil.cm@gmail.com

import sys
import math

if len(sys.argv) < 2:
	print >> sys.stderr, "Incorrect Arguments. Usage: python char_nbest2pt.py nbest_file unknowns_file <optional-input-file>"
	sys.exit()

# Gets the arguments	
nbest_list = sys.argv[1]
unknowns = sys.argv[2]
if len(sys.argv) > 3:
	testfile = sys.argv[3]

#############
### Functions
##############

## input: feature line from the n-best file, and list of features to be retained
## extracts features from the n-best file line to be put in phrase-table
def get_features(feature_str, feature_list):
	features = ""
	feature_pieces = feature_str.split()
	for feature_name in feature_list:
		flag = False
		for piece in feature_pieces:
			if piece == feature_name + "=":
				flag = True
				continue
			if flag==True:
				try:
					features = features + " " + str(math.exp(float(piece)))
				except:
					flag==False
					continue
	return features		

## input: unknown word and list of nbest lines for the unknown word
## prints translation options in phrase-table format for the unknown word
def print_ptentry(unk_word, list_lines):
	
	for line in list_lines:
		pieces = line.split('|||')
		tword = pieces[1].replace(" ","")
		features = get_features(pieces[2],['TranslationModel0'])
		print unk_word + ' ||| ' + tword + ' ||| ' + features + ' ||| 0-0 ||| 0 0 0'

## input: test file path, dictionary of unknown words
### adds words from the input file which are not unknown
def add_other_words(testfile, unk_words):
	added_words = dict()
	with open(testfile) as f:
		for line in f:
			words = line.split()
			for word in words:
				if word not in added_words and word not in unk_words:
					print word + ' ||| ' + word + ' ||| ' + "1.0 1.0 1.0 1.0" + ' ||| 0-0 ||| 0 0 0'
					added_words[word] = True


#### Main Method Starts Here ####

list_lines = dict()
with open(nbest_list) as fpt:
	for line in fpt:
		line = line.strip()
		if line.split()[0] in list_lines:
			list_lines[line.split()[0]].append(line)
		else:
			list_lines[line.split()[0]] = [line]

unk_words = dict()
with open(unknowns) as funk:
	idx = 0
	# loop through character separated unknown word
	for line in funk:
		unk_word_chars = line.strip()
		# joint the characters to get the unknown word
		unk_word = unk_word_chars.replace(" ","")
		unk_words[unk_word] = True
		# For each unknown word print the phrase-table
		print_ptentry(unk_word,list_lines[str(idx)])
		idx= idx+1

if testfile is not None:
	add_other_words(testfile, unk_words)
