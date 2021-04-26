source("Reader.R")
source("Functions.R")
source("ScrapeWLYear.R")

db <- ParallelReader()

player <- 'Bjorn Borg'

seasons <- db[winner_name == player | loser_name == player]

#extract year from tourney_date
seasons$year <- stringr::str_sub(seasons$tourney_id, 0 ,4)

seasons <- unique(seasons[, c('year')])

seasons <- dplyr::pull(seasons, year)

stat <- NULL

for (i in 1:(length(seasons))){
  
  print(seasons[i])
  
  ###### GET from ATP website
  statATP <- ScrapeWLYear(player, seasons[i])
  winsLossesOverall <-  strsplit(as.character(statATP),'-')
  ATPDBwinLoss <- data.frame(winsLossesOverall[[1]][1], winsLossesOverall[[1]][2])
  ATPDBwinLossOverall <- cbind(player, ATPDBwinLoss)
  names(ATPDBwinLossOverall)[1] <- "name"
  names(ATPDBwinLossOverall)[2] <- "wins"
  names(ATPDBwinLossOverall)[3] <- "losses"
  print(ATPDBwinLossOverall)
  
  stat2 <-  PercentageYearByYear(seasons[i], db, player)
  
  stat2 <- rbind(stat2, ATPDBwinLossOverall, fill = TRUE)
  
  stat2 <- cbind(seasons[i], stat2)
  
  stat <- rbind(stat, stat2)
}

names(stat)[1] <- "year"

print(stat)

stat <- stat[,c("name", "year", "wins", "losses", "percentage")]

write_tableHTML(tableHTML(stat), file = paste("SeasonsReviewByPlayer.html"))
