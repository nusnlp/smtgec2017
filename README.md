# NUS Grammatical Error Correction 2017 (SMT-based)
----------------------------------------------------------------------------

This repository contains scripts and models to replicate the results of the state-of-the-art (in 2017) grammatical error correction (GEC) system. The system primarily uses the statistical machine translation (SMT) framework, with neural and character level translation components.

If you use the models from this work, please cite this [paper](http://aclweb.org/anthology/W17-5037):

```
@InProceedings{chollampatt2017gec,
  author    = {Chollampatt, Shamil, and Ng, Hwee Tou},
  title     = {Connecting the Dots: Towards Human-level Grammatical Error Correction},
  booktitle = {Proceedings of the 12th Workshop on Innovative Use of NLP for Building Educational Applications},
  month     = {September},
  year      = {2017},
  address   = {Copenhagen, Denmark},
  publisher = {Association for Computational Linguistics}
}
```

### Prerequistes

1. cmph - For compact phrase tables
2. nplm - For neural network joint model feature in Moses.
3. Moses Release 3.0
    - Execute `./download.sh` in `software/` directory to download the specific revision of Moses used in this work.
    - Moses needs to be compiled with `---with-cmph=/path/to/cmph-2.0 --with-nplm=/path/to/nplm --max-kenlm-order=9` this flag

### Downloading the Models
Go to each directory in `models/` and run `download.sh` to download the respective model files. The model files are as follows

1. Language Models (`lm/`)

	 **Model**  |**Filename**           |**Size**|**Description**
	:-----------|:----------------------|-------:|:-------------
	Train LM    |`concat-train.trie`    |128 MB  | 5-gram LM trained using the target side of the
	Wiki LM     |`wiki.trie`            |6 GB    | 5-gram LM trained using English Wikipedia dump (1.78B tokens)
	94B CCLM    |`94Bcclm.trie`         |153 GB  | 5-gram LM trained using subset of CommonCrawl corpus (94B tokens)
	94B CCLM    |`94Bcclm.filtered.trie`|34 GB   | 94B CCLM filtered according to the phrase-table and the CoNLL-2014 and the development set (faster loading)
	Character LM|`charLM.bin`           |1 MB    | Character-level LM for character-level SMT
    
    
2. Phrase Tables (`pt/`)

	 **Model**     |**Filename**       |**Size**|**Description**
	:--------------|:------------------|-------:|:-------------
	WordSMT-GEC PT |`phrase-table.minphr`|851 MB  | Phrase table used by word-level SMT
	CharSMT-GEC PT |`phrase-table.char.gz`        |12 MB   | Phrase table used by character-level SMT

3. Neural Network Joint Model (NNJM) (`nnjm/`)
    
	 **Model**     |**Filename**       |**Size**|**Description**
	:--------------|:------------------|-------:|:-------------
	Adapted NNJM |`nnjm_adapted.weights`|268 MB  | Model file with trained weights in NPLM format (compatible with MOSES)
	Vocab |`output.vocab`, `source.vocab`, `target.vocab`|370 KB   | Vocabulary files
    
    
4. Operation Sequence Model (OSM) (`osm/`)

	 **Model**     |**Filename**       |**Size**|**Description**
	:--------------|:------------------|-------:|:-------------
	Binarized OSM |`operationLM.bim`|323 MB  | Binarized operation sequence model
   
5. Word Class Language Model (WCLM) (`wclm/`)

	 **Model**     |**Filename**       |**Size**|**Description**
	:--------------|:------------------|-------:|:-------------
	Wiki Word Class LM |`wiki.classes.kenlm`|13 GB  | 9-gram word
  	Word2Class Mapping |`wiki.classes.gen.gz`|7.6 MB| Binarized operation sequence model
  
6. Sparse Weights (`sparse/`)
	 
     **Model**     |**Filename**           |**Size**|**Description**
	:--------------|:----------------------|-------:|:-------------
	Sparse Weights |`word.moses.ini.sparse`|5.6 MB | Sparse feature weights with 1 word context.
  

## Running the system

To run the system on any test set, execute the following script on the tokenized input file.

`./run.sh path/to/input/file /path/to/output/directory`



## License

The code and models in this repository are licensed under the GNU General Public License Version 3.
 
 For commercial use of this code and models, separate commercial licensing is also available. Please contact:
 1. Shamil Chollampatt (shamil@u.nus.edu)
 2. Hwee Tou Ng (nght@comp.nus.edu.sg)


