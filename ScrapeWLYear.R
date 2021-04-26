
ScrapeWLYear <- function(player, year){

res <- NULL
  
idPlayer <- head(db[winner_name == player], 1)
  
id <- idPlayer$winner_id
  
print(id)
  
id <- tolower(id) 
  
playerURL <- gsub(" ", "-", player)

#view-source:https://www.atptour.com/en/players/wojtek-fibak/f020/player-activity?year=1988

uastring <- ""
page_url <- paste0("https://www.atptour.com/en/players/",  playerURL, "/", id, "/player-activity?year=", year)
  
response <- GET(page_url, user_agent(uastring))
  
html <- read_html(response)
  
allnodes <- html %>% html_nodes("*") %>% html_attr("class") %>% unique()
  
## first we look for the tournament names
stats <- html_nodes(html, ".stat-value")%>% html_text()
stats <- gsub("\r","", stats)
stats <- gsub("\t","", stats)
stats <- gsub("\n","", stats)

print(stats[2])

}