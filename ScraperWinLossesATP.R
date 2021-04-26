scraping <- function(player){
  
  res <- NULL
  
  #get id from our database
  idPlayer <- head(db[winner_name == player], 1)
  
  playerURL <- gsub(" ", "-", player)
  
  uastring <- ""
  page_url <- paste0("https://www.atptour.com/en/players/",  playerURL, "/", tolower(idPlayer$winner_id), "/fedex-atp-win-loss")
  
  response <- GET(page_url, user_agent(uastring))
  
  html <- read_html(response)
  
  allnodes <- html %>% html_nodes("*") %>% html_attr("class") %>% unique()
  
  ## first we look for the tournament names
  stats <- html_nodes(html, ".inner-win-loss-cells")%>% html_text()
  stats <- gsub("\r","", stats)
  stats <- gsub("\t","", stats)
  stats <- gsub("\n","", stats)
  
  ####################### Overall ########################
  winsLossesOverall <-  strsplit(as.character(stats[2]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesOverall[[1]][1], winsLossesOverall[[1]][2])
  
  MyDBwinLossOverall <- getwinLossOverall(player)
  
  type <- 'Overall'
  
  res <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  ####################### Slam ########################
  
  winsLossesSlam <- strsplit(as.character(stats[4]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesSlam[[1]][1], winsLossesSlam[[1]][2])
  
  MyDBwinLossOverall <- getwinLossSlam(player)
  
  type <- 'Slam'
  
  stat2 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  
  #################### M1000 ###########################
  
  winsLossesM1000 <- strsplit(as.character(stats[6]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesM1000[[1]][1], winsLossesM1000[[1]][2])
  
  MyDBwinLossOverall <- getwinLossSlamM1000(player)
  
  type <- 'M1000'
  
  stat3 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  
  #################### Clay ###########################
  winsLossesClay <- strsplit(as.character(stats[18]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesClay[[1]][1], winsLossesClay[[1]][2])
  
  MyDBwinLossOverall <- getwinLossClay(player)
  
  type <- 'Clay'
  
  stat4 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  
  #################### Grass ###########################
  winsLossesGrass <- strsplit(as.character(stats[20]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesGrass[[1]][1], winsLossesGrass[[1]][2])
  
  MyDBwinLossOverall <- getwinLossGrass(player)
  
  type <- 'Grass'
  
  stat5 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  
  #################### Hard ###########################
  winsLossesHard <- strsplit(as.character(stats[22]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesHard[[1]][1], winsLossesHard[[1]][2])
  
  MyDBwinLossOverall <- getwinLossHard(player)
  
  type <- 'Hard'
  
  stat6 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  #################### Carpet ###########################
  winsLossesCarpet <- strsplit(as.character(stats[24]),'-')
  
  ATPDBwinLossOverall <- data.frame(winsLossesCarpet[[1]][1], winsLossesCarpet[[1]][2])
  
  MyDBwinLossOverall <- getwinLossCarpet(player)
  
  type <- 'Carpet'
  
  stat7 <- aggregateATP(ATPDBwinLossOverall, MyDBwinLossOverall, type, player)
  
  res <- rbind(res, stat2, stat3, stat4, stat5, stat6, stat7)
  
  res
  
}