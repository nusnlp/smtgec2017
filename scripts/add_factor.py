#!/usr/bin/python


### This script takes an input file and add the factors to it based on a word-class langauge model
### Author: shamil.cm@gmail.com

import argparse
from sys import getsizeof
import gzip

# Getting the arguments
parser = argparse.ArgumentParser()
parser.add_argument("-i", dest="input_path", required=True, help="input src file")
parser.add_argument("-f", dest="factors_path", required=True, help="input factors path")
args = parser.parse_args()

# Storing a dictionary of factors from the classes file
factor_dict = dict()
with gzip.open(args.factors_path) as f:
	for line in f:
		line = line.strip()
		pieces = line.split()
		factor_dict[pieces[0]] = pieces[1]

## Function to get the factor given the word
# Input: word
# Output: factor (0 for unknown words)
def get_factor(token, factor_dict):
	if token in factor_dict:
		return factor_dict[token]
	else:
		return '0'

with open(args.input_path) as f_inp:
	for line in f_inp:
		line = line.strip()
		tokens = line.split()
		factored_tokens = [ (str(token + '|' + get_factor(token, factor_dict))) for token in tokens ]
		print " ".join(factored_tokens) 

	
