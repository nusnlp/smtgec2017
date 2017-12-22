### if you need to run the SMT system on CoNLL-2014 test data or CoNLL-2013 test data, you can use this filtered
### LM instead of downloading the large LM. The results in the paper (Chollampatt and Ng, BEA 2017) is using the
### unfiltered LMs.
#curl -L -o 94Bcclm.filtered.trie https://tinyurl.com/y7j687l3/lm/94Bcclm.filtered.trie

curl -L -o 94Bcclm.trie https://tinyurl.com/y7j687l3/lm/94Bcclm.trie
curl -L -o charLM.bin https://tinyurl.com/y7j687l3/lm/charLM.bin
curl -L -o concat-train.trie https://tinyurl.com/y7j687l3/lm/concat-train.trie
curl -L -o wiki.trie https://tinyurl.com/y7j687l3/lm/wiki.trie