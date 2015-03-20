# Get the cantonese syllable data from siuying's repo
wget https://raw.githubusercontent.com/siuying/cantonese-syllables/master/data/characters.json

# insert that into a db for quick read, and ask R to STFU. Need rjson and RSQLite pkg
Rscript insertdb.R > /dev/null 2>&1


