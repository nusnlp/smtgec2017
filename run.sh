## This script is to run the complete GEC system on CoNLL-2014 input
## To run it on arbitary input use run_gec.sh <input-file>
set -e
set -x

source paths.sh

if [ $# -eq 2 ]; then
	INPUT_FILE=$1
	OUTPUT_DIR=$2
else
	echo "Please specify the paths to the input_file and output directory"
	echo "Usage: `basename $0` input_file output_dir"   >&2
fi

## Tuned config file for the SMT-based GEC system (Word SMT-GEC)
WORD_CONFIG=$PWD/configs/word.moses.ini
## Tuned config file for character-level SMT component of Spelling SMT.
CHAR_CONFIG=$PWD/configs/char.moses.ini
## Word-factor map file, i.e. word classes from Wikipedia text. 
WORD_FACTORS=$MODEL_DIR/wclm/wiki.classes.gen.gz
## Temporary directory for intermediate files
TMP_DIR=$OUTPUT_DIR/tmp
## LM to use for Spelling correction
LM_FILE=$MODEL_DIR/lm/wiki.trie

## Arguments for moses
MOSES_THREADS=16

## Preparation
mkdir -p $OUTPUT_DIR
mkdir -p $TMP_DIR
INPUT_PREFIX=`echo $(basename $INPUT_FILE) | rev | cut -d'.' -f2- | rev`
echo $INPUT_PREFIX

##########################
### First pass correction
##########################
echo "[`date`] First pass correction: " >&2
## prepare config file by removing place holder text to actual directories
sed "s|MODEL_DIR|$MODEL_DIR|g" $WORD_CONFIG > $TMP_DIR/word.moses.ini
## add factors to the input file based on the word-factor map file
python $SCRIPTS_DIR/add_factor.py -i $INPUT_FILE -f $WORD_FACTORS > $TMP_DIR/input.factored.tok.txt
## run the decoder
 $MOSES_DIR/bin/moses -threads $MOSES_THREADS  -distortion-limit 0 -minphr-memory -f $TMP_DIR/word.moses.ini -output-unknowns $TMP_DIR/word.unknowns < $TMP_DIR/input.factored.tok.txt  > $OUTPUT_DIR/WordSMT-GEC.$INPUT_PREFIX.out 	2> >(tee $TMP_DIR/decode-word.1.log >&2)

########################
### Char SMT decoding
########################
echo "[`date`] Character SMT decoding: " >&2
# prepare space separated characters input
python $SCRIPTS_DIR/prepare_charsmt_input.py  $TMP_DIR/word.unknowns > $TMP_DIR/input.char.unknowns.txt
# copy the config file
sed "s|MODEL_DIR|$MODEL_DIR|g" $CHAR_CONFIG > $TMP_DIR/char.moses.ini
# decoding step
$MOSES_DIR/bin/moses -threads $MOSES_THREADS -distortion-limit 0 -search-algorithm 1 -n-best-list $TMP_DIR/char.unknowns.out.nbest 100 distinct -f $TMP_DIR/char.moses.ini < $TMP_DIR/input.char.unknowns.txt > $TMP_DIR/char.unknowns.out 2> >(tee $TMP_DIR/decoder-char.2.log >&2)
python $SCRIPTS_DIR/char_nbest2pt.py $TMP_DIR/char.unknowns.out.nbest $TMP_DIR/input.char.unknowns.txt $OUTPUT_DIR/WordSMT-GEC.$INPUT_PREFIX.out > $TMP_DIR/phrase-table.spelling
gzip $TMP_DIR/phrase-table.spelling
# prepare config files for re-correction
$MOSES_DIR/scripts/training/train-model.perl -first-step 9 -f src -e trg -lmodel-oov-feature "yes"  -phrase-translation-table $TMP_DIR/phrase-table.spelling.gz -config $TMP_DIR/spelling.moses.ini -lm 0:5:$LM_FILE:8
# put more weight on the OOV feature
sed -i -e "s/^LM0= .*/LM0= 0.5 -100/g" $TMP_DIR/spelling.moses.ini

###########################
### Second pass correction
###########################
echo "[`date`] Second pass correction: " >&2
$MOSES_DIR/bin/moses -threads $MOSES_THREADS  -f $TMP_DIR/spelling.moses.ini -distortion-limit 0 < $OUTPUT_DIR/WordSMT-GEC.$INPUT_PREFIX.out > $OUTPUT_DIR/WordCharSMT-GEC.$INPUT_PREFIX.out 2> >(tee $TMP_DIR/decoder-word.3.log >&2)


