require(RSQLite)
sqlite    <- dbDriver("SQLite")
conn <- dbConnect(sqlite, "syllables.db")

findSound <- function(char, conn) {
    x <- dbGetQuery(conn, paste0("select sound from syllables where character = '", char, "'"))
    if (nrow(x) == 1) {
        return(x[1,1])
    } else {
        print(paste0(char, ":  multiple Sound Found, please select:"))
        for (i in 1:nrow(x)) {
            print(paste0(i, ":", x[i,1]))
        }
        return(x[readline(prompt="Enter selection:"),1])
        #askWhichOne
        #TODO: insertAnswer to DB
    }
}

findSingularChar <- function(sound, conn) {
    x <- dbGetQuery(conn, paste0("select character from singlesound where sound = '", sound, "'"))
    return(x[sample(nrow(x), 1),1])
}

findSingularChar("paa1", conn)

findSub <- function(char, conn) {
    x <- findSingularChar(findSound(char, conn), conn)
    if (length(x) == 0) {
        return(char)
    }
    return(x)
}
paste0(sapply(strsplit("廣東話謎碼機", split = "")[[1]], findSub, conn = conn), collapse = "")
