library(tableHTML)

#Read database from csv
db <- ParallelReader()

db[is.na(db)] <- 0

player <- 'Mats Wilander'

stat <- db[(winner_name == player | loser_name == player)]

#stat <- db[winner_ioc == 0 & round == 'F']

#stat <- unique(stat[, c('tourney_id')])

#extract year from tourney_date
stat$year <- stringr::str_sub(stat$tourney_id, 0 ,4)

#set range years
#stat <- stat[year == 1976]

# require(dplyr)
# stat<- stat %>%
#    group_by(year) %>%
#    tally()

stat <- stat[,c("tourney_name", "year", "round", "surface", "winner_name", "winner_age", "loser_name", "loser_age", "score")]

write_tableHTML(tableHTML(stat), file = paste("Matches.html"))

