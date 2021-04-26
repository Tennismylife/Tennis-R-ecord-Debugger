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

player <- 'Jimmy Connors'

scrap <-  scraping(player)

write_tableHTML(tableHTML(scrap), file = paste("ATPvsTML.html"))
