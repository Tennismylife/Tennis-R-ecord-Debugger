library(stringr)

#Functions collection to find wins and losses

WinsCategory <- function(category) {
  
  ## only select tournaments in the previously defined pool
  dbm <- db[tourney_level == category]
  
  ## drop walkover matches (not countable)
  require(stringr)
  dbm <- dbm[!dbm$score=="W/O" & !dbm$score=="DEF" & !str_detect(dbm$score, "WEA") & !str_detect(dbm$score, "ABN")]
  
  ## count occurrences of won matches
  res <- dbm[,.N, by=winner_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}


WinsTour <- function(id) {
  
  ## only select matches of a tournament
  db$tourney_id <- sub("^[^-]*", "", db$tourney_id)
  
  db <- db[tourney_id == id]
  
  ## drop walkover matches (not countable)
  require(stringr)
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]
  
  ## count occurrences of won matches
  res <- db[,.N, by=winner_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}

winsSurface <- function(court) {
  
  ## only select tournaments in the previously defined pool
  db <- db[surface == court]
  
  ## drop walkover matches (not countable)
  require(stringr)
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]
  
  ## count occurrences of won matches
  res <- db[,.N, by=winner_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}

WinsOverall <- function() {

  ## drop walkover matches (not countable)
  require(stringr)
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]
  
  ## count occurrences of won matches
  res <- db[,.N, by=winner_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
  
}

LossesOverall <- function() {
  
  ## drop walkover matches (not countable)
  require(stringr)
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]
  
  ## count occurrences of lost matches
  res <- db[,.N, by=loser_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}


LossesCategory <- function(category) {
  
  ## only select tournaments in the previously defined pool
  dbm <- db[tourney_level == category]
  
  ## drop walkover matches (not countable)
  require(stringr)
  dbm <- dbm[!dbm$score=="W/O" & !dbm$score=="DEF" & !str_detect(dbm$score, "WEA") & !str_detect(dbm$score, "ABN")]
  
  ## count occurrences of won matches
  res <- dbm[,.N, by=loser_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}


LossesSurface <- function(court) {
  
  ## only select tournaments in the previously defined pool
  db <- db[surface == court]
  
  ## drop walkover matches (not countable)
  require(stringr)
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]
  
  ## count occurrences of won matches
  res <- db[,.N, by=loser_name]
  
  ## order by decreasing
  setorder(res, -N, na.last=FALSE)
  
  res
}



PercentageYearByYear <- function(season, db, player) {
  
  db <- db[!db$score=="W/O" & !db$score=="DEF" & !str_detect(db$score, "WEA") & !str_detect(db$score, "ABN")]

  # #extract year from tourney_date
  db$year <- stringr::str_sub(db$tourney_id, 0 ,4)
  
  stat <- db[year == season]
  
  ## wins
  wins <- stat[,.N, by=winner_name]
  
  ## losses
  losses <- stat[,.N, by= loser_name]
  
  ## common name to merge with
  names(wins)[1] <- names(losses)[1] <- "name"
  names(wins)[2] <- "wins"
  names(losses)[2] <- "losses"
  
  ## merge the tables by "name"
  res <- merge(wins, losses, by = c("name"), all=TRUE)
  
  ## get rid of NAs, have 0 instead
  res[is.na(res)] <- 0
  
  ## sum the wins and losses into a new column played
  res <- res[, played:=wins+losses]
  
  res <- res[, percentage:=wins/played*100]
  
  res <- res[name == player]
  
  res$percentage <- substr(res$percentage, 0, 5)
  res$percentage <- suppressWarnings(as.numeric(str_replace_all(res$percentage,pattern=',',replacement='.')))
  
  ## order by decreasing total matches
  setorder(res, -percentage)
  
  res$percentage <- paste(res$percentage, "%")

  print(res)
  
}