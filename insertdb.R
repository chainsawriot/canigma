require(RSQLite)
require(rjson)

raw_cantonese <- fromJSON(file="characters.json")
allcharacters <- names(raw_cantonese)
sqlite    <- dbDriver("SQLite")
conn <- dbConnect(sqlite,"syllables.db")
dbGetQuery(conn, "drop table if exists syllables")
dbGetQuery(conn, "create table syllables (character text, sound text)")
dbListTables(conn)

insertdb <- function(chara, raw_cantonese, conn) {
    sound <- raw_cantonese[chara][[1]]
    sapply(sound, function (x) dbGetQuery(conn, paste0("insert into syllables (character, sound) values ('", chara, "', '", x,"')")))
}

sapply(allcharacters, insertdb, raw_cantonese = raw_cantonese, conn = conn) # so pretentious functional style, functional but relying on the side effect of inserting to db

dbGetQuery(conn, "create index characters_idx on syllables(character)")
dbGetQuery(conn, "create index sound_idx on syllables(sound)")
dbGetQuery(conn, "create view singlesound as select character, sound from syllables where character in (select char from (select character as char, count(*) as freq from syllables group by character) where freq = 1)")
dbDisconnect(conn)
