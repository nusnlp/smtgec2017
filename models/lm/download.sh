### if you need to run the SMT system on CoNLL-2014 test data or CoNLL-2013 test data, you can use this filtered
### LM instead of downloading the large LM. The results in the paper (Chollampatt and Ng, BEA 2017) is using the
### unfiltered LMs.
#curl -L -o 94Bcclm.filtered.trie https://nus.edu/2sK6I0l

curl -L -o 94Bcclm.trie https://nus.edu/2u28fCO
curl -L -o charLM.bin https://nus.edu/2f2AXeb
curl -L -o concat-train.trie https://nus.edu/2wHg4N3
curl -L -o wiki.trie https://nus.edu/2wFYYB3