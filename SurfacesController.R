source("Remover.R")

### Function to scrape all tourneys for a given year in the db
ScrapeYear <- function(year, verbose=TRUE, save_html=FALSE) {
  require(rvest)
  require(httr)
  
  ## if year really contains a year (4 numbers), we scrape from the ATP site; otherwise we interprete that as file path to an already scraped html file
  
  if (nchar(as.character(year)) == 4) { 
    
    ## we need to scrape
    uastring <- "" ##"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
    page_url <- paste0("https://www.atptour.com/en/scores/results-archive?year=", year)
    
    response <- GET(page_url, user_agent(uastring))
    
    ## are we gonna save it on disk?
    if (save_html)
      cat(content(response, "text"), file=paste0("html/Year_", year,".html"))
  } else { 
    ## we read html from disk
    response <- paste(readLines(year), collapse="\n")
  }
  
  html <- read_html(response)
  
  allnodes <- html %>% html_nodes("*") %>% html_attr("class") %>% unique()
  
  ## first we look for the tournament names
  title <- html_nodes(html, ".tourney-title")%>% html_text()
  title <- gsub("[[:space:]]{2,}","", title)
  
  ## extract the big table with the entries
  table <- html_nodes(html, "table.results-archive-table")%>% html_table(header=TRUE)
  table <- table[[1]]
  
  ## date is contained in table[,3]
  date <- gsub(".*([[:digit:]]{4})\\.([[:digit:]]{2})\\.([[:digit:]]{2})","\\1\\2\\3", table[,3])
  
  ## draw size from table[,4]
  tmpd <- gsub("[[:space:]]{2,}"," ", table[,4])
  dsize <- gsub("SGL[[:space:]](.*)[[:space:]]DBL.*$","\\1", tmpd)
  
  ## extract surfaces and indoor/outdoor
  tmpn <- gsub("[[:space:]]{2,}"," ", table$Surface)
  ## some tourneys are still malformed and do not have Indoor|Outdoor[:space:]Surface!!
  indoor <- surface <- rep(NA_character_, length(tmpn))
  indoor[grep("Indoor", tmpn)] <- "Indoor"
  indoor[grep("Outdoor", tmpn)] <- "Outdoor"
  
  surface[grep("Hard", tmpn)] <- "Hard"
  surface[grep("Grass", tmpn)] <- "Grass"
  surface[grep("Clay", tmpn)] <- "Clay"
  surface[grep("Carpet", tmpn)] <- "Carpet"
  
  ## extract the urls to each tournament - in the current year this list can be less long!
  have_results <- table$Results=="Results"
  ind_res <- which(have_results)
  
  urls  <- html_nodes(html, "a") %>% html_attr("href") %>% grep(pattern="results$|live-scores$", value=TRUE) ## |live-scores$
  tourney_urls <- rep(NA_character_, nrow(table))
  tourney_urls[ind_res] <- urls
  
  if ((FALSE %in% have_results) & verbose)
    cat(paste(":ScrapeYear: No results (and no url) for ", paste(title[!have_results], collapse = " ; "), year,"\n"))
  
  ## discriminate between current/monte-carlo/410/live-scores and archive/australasian-championships/580/1915/results
  has_current <- grep("current", tourney_urls)
  has_archive <- grep("archive", tourney_urls)
  
  ## "current"
  tmpid <- gsub(".*current/(.*)/live-scores","\\1", tourney_urls[has_current])
  tourney_ids_current <- paste0(year, "_", gsub("^.*?/(.*)$","\\1", tmpid))
  
  ## retrieve the tourney_id from the urls themselves if there is no "current"
  tmpid <- gsub(".*archive/(.*)/results","\\1", tourney_urls[has_archive])
  tourney_ids_archive <- gsub("^.*/(.*?)/(.*)$","\\2_\\1", tmpid) ## remove the name
  
  ## bring the ids together
  tourney_ids <- rep(NA_character_, nrow(table))
  tourney_ids[ has_current ] <- tourney_ids_current
  tourney_ids[ has_archive ] <- tourney_ids_archive
  
  
  ## commitment should live in table[,6], clean up the "," as
  ## thousands separator
  commitment <- gsub(",","", table[,6], fixed=TRUE)
  
  
  tab <- data.table(date=date, year=year, tourney_name=title,
                    tourney_id=tourney_ids, surface=surface,
                    indoor=indoor, commitment=commitment,
                    draw_size=dsize,
                    url=ifelse(is.na(tourney_urls), NA_character_, paste0("https://www.atptour.com", tourney_urls)))
  
  if (FALSE %in% have_results)
    tab <- tab[ind_res]
  
  print(tab)
  return(tab)
}

season <- (1968:2021)

recap <- NULL

stat <- ParallelReader()

stat <- removeTeamEvents(stat)

#extract year from tourney_date
stat$year <- stringr::str_sub(stat$tourney_id, 0 ,4)

for(i in 1:length(season)){
  
print(season[i])
  
seasonATP <- ScrapeYear(season[i])

seasonATP$tourney_id <- gsub("_", "-", seasonATP$tourney_id)

seasonATP <- seasonATP[,c("tourney_id", "tourney_name", "surface")]

#set range years
res <- stat[year == season[i]]

res <- res[,c("tourney_id", "tourney_name", "surface")]

res <- unique(res)

#stat <- cbind(stat, seasonATP)

stat2 <- left_join(res, seasonATP, by ="tourney_id")

stat2 <- stat2[,c("tourney_id", "tourney_name.x", "surface.x", "surface.y")]

recap <- rbind(recap, stat2)

}

## order by decreasing
setorder(recap, surface.x, na.last=FALSE)

write_tableHTML(tableHTML(recap), file = paste("Season.html"))