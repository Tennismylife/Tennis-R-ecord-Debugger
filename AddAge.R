library(rvest)
library(httr)

source("Reader.R")

findBirthday <- function(player){

idPlayer <- head(db[loser_name == player], 1)

id <- idPlayer$loser_id

print(id)

id <- tolower(id) 

playerURL <- gsub(" ", "-", player)

uastring <- ""
page_url <- paste0("https://www.atptour.com/en/players/",  playerURL, "/", id, "/overview")

response <- GET(page_url, user_agent(uastring))

status <- http_status(response)
print(status$message)

if(str_detect(status$message, "200")){
html <- read_html(response)

allnodes <- html %>% html_nodes("*") %>% html_attr("class") %>% unique()

## first we look for the tournament names
stats <- html_nodes(html, ".table-birthday")%>% html_text()
stats <- gsub("\r","", stats)
stats <- gsub("\t","", stats)
stats <- gsub("\n","", stats)
stats <- gsub("                                                \\(","", stats)
stats <- gsub(")                                            ","", stats)
stats <- gsub("\\.","", stats)
}else{
  stats <- '0'
  
}
}


db <- ParallelReader()

db[is.na(db)] <- 0

# #extract year from tourney_date
db$year <- stringr::str_sub(db$tourney_id, 0 , 4)

#set range years
stat <- db[year == '1968']

wins <- stat[loser_age == 0]

players <- unique(dplyr::pull(wins, loser_name))

atp <- "C:/Users/Andrea/Documents/GitHub/TML-Database/"

fmt_db <- '%Y%m%d'
fmt_bday <- '%Y%m%d'


for(k in 1:length(players)){

print(players[k])

stat <- db[(winner_name == players[k] & winner_age == 0) | (loser_name == players[k] & loser_age == 0)]

born <- '1'

if(!empty(stat))
born <- findBirthday(players[k])


print(born)

library(dplyr)

if(!empty(stat) & !rlang::is_empty(born)){

stat$year <- stringr::str_sub(stat$tourney_id, 0 ,4)

years <- unique(dplyr::pull(stat, year))



print(born)

for(i in 1:length(years)){

fileToRead <- paste0(atp, years[i], ".csv")

yearRows <- read.csv(file = fileToRead)

rows <- NULL

for(j in 1:nrow(yearRows)) {
  
  row <- yearRows[j,]

  if(is.na(row$winner_age) & row$winner_name == players[k]){
    age <- round(as.numeric(as.Date(as.character(row$tourney_date), format=fmt_db)-as.Date(born,format=fmt_bday))/365.25,6)
    row$winner_age <- age
  }

  if(is.na(row$loser_age) & row$loser_name == players[k]){
    age <- round(as.numeric(as.Date(as.character(row$tourney_date), format=fmt_db)-as.Date(born,format=fmt_bday))/365.25,6)
    row$loser_age <- age
  }

  rows <- rbind(rows, row)

}

write.csv(rows, fileToRead, na="", quote=F, row.names = FALSE)
}

}

}
