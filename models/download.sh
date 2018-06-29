set -e
set -x

BASEURL=https://tinyurl.com/yd6wvhgw/smtgec2017/models

# Phrase Tables
################
mkdir -p pt
curl -L -o pt/phrase-table.char.gz $BASEURL/pt/phrase-table.char.gz
curl -L -o pt/phrase-table.minphr $BASEURL/pt/phrase-table.minphr


# Language MOdels
###################
mkdir -p lm
curl -L -o lm/charLM.bin $BASEURL/lm/charLM.bin
curl -L -o lm/concat-train.trie $BASEURL/lm/concat-train.trie
curl -L -o lm/wiki.trie $BASEURL/lm/wiki.trie
### if you need to run the SMT system on CoNLL-2014 test data or CoNLL-2013 test data, you can download the filtered LM
### instead of the large LM (uncomment the next line).
### NOTE: The results in (Chollampatt and Ng, BEA 2017) are using the unfiltered LM (94Bcclm.trie).
#curl -L -o 94Bcclm.filtered.trie $BASEURL/lm/94Bcclm.filtered.trie
curl -L -o lm/94Bcclm.trie $BASEURL/lm/94Bcclm.trie

# NNJM
#######
mkdir -p nnjm
curl -L -o nnjm/nnjm_adapted.weights $BASEURL/nnjm/nnjm_adapted.weights
curl -L -o nnjm/output.vocab $BASEURL/nnjm/output.vocab
curl -L -o nnjm/source.vocab $BASEURL/nnjm/source.vocab
curl -L -o nnjm/target.vocab $BASEURL/nnjm/target.vocab

# OSM
#######
mkdir -p osm
curl -L -o osm/operationLM.bin $BASEURL/osm/operationLM.bin

# Sparse Weights
#################
mkdir -p sparse
curl -L -o sparse/word.moses.ini.sparse $BASEURL/sparse/word.moses.ini.sparse

# Word Class Language MOdel
############################
mkdir -p wclm
curl -L -o wclm/wiki.classes.gen.gz $BASEURL/wclm/wiki.classes.gen.gz
curl -L -o wclm/wiki.classes.kenlm $BASEURL/wclm/wiki.classes.kenlm
