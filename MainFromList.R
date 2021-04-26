library(rvest)
library(httr)
library(stringr)

source("Reader.R")
source("StatsCollector.R")
source("Functions.R")
source("ScraperWinLossesATP.R")
source("Aggregator.R")

#Read from database
db <- ParallelReader()

#Get a list (You can change this)
stat <- WinsOverall()

#unique player name
playerList  <- dplyr::pull(unique(stat[, c('winner_name')]), winner_name)

scrap <- NULL

for (i in 1:length(playerList)){
  
  print(playerList[[i]])
  
  player <- playerList[[i]]
  
  scrap2 <-  scraping(playerList[[i]])
  
  scrap <- rbind(scrap, scrap2)
}

write_tableHTML(tableHTML(scrap), file = paste("ATPvsTML.html"))
