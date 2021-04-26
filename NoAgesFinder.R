
#Read database from csv
db <- ParallelReader()

player <- 'Andre Van der Merwe'

db[is.na(db)] <- 0

#stat <- db[(winner_name == player & winner_age == 0) | (loser_name == player & loser_age == 0)]

#stat <- db[winner_name == player | loser_name == player]

stat <- db[(winner_age < 15 & winner_age > 0) | (loser_age < 15 & loser_age > 0)]

#stat <- db[winner_age == 0 | loser_age == 0]

stat$year <- stringr::str_sub(stat$tourney_id, 0 ,4)

stat <- stat[,c("tourney_name", "year", "round", "surface", "winner_name", "winner_age", "loser_name", "loser_age", "score")]


write_tableHTML(tableHTML(stat), file = paste("Test.html"))
