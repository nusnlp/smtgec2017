#!/bin/bash

echo -n "Downloading Moses from Github (Revision: a4e951e581b6b3ed2a9c1057f0997739897bd267)..."
wget https://github.com/moses-smt/mosesdecoder/archive/a4e951e581b6b3ed2a9c1057f0997739897bd267.zip
sleep 5
echo "Done!"
echo -n "Uncompressing..."
unzip a4e951e581b6b3ed2a9c1057f0997739897bd267.zip
mv mosesdecoder-a4e951e581b6b3ed2a9c1057f0997739897bd267/ mosesdecoder
rm a4e951e581b6b3ed2a9c1057f0997739897bd267.zip
echo "Done!"
echo ""
echo "Compile moses with cmph and nplm paths and KenLM order=9:"
echo "cd mosesdecoder/"
echo "./bjam -j12 --with-cmph=/path/to/cmph-2.0 --with-nplm=/path/to/nplm --max-kenlm-order=9"
