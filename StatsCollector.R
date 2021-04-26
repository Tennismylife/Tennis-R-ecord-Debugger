library(tableHTML)

source("Functions.R")


############################################# Overall ###########################################

getwinLossOverall <- function(player){

winsOver <- WinsOverall()

lossesOver <- LossesOverall()

names(winsOver)[1] <- names(lossesOver)[1] <- "Player"

## merge the tables by "name"
winLossOverall <- merge(winsOver, lossesOver, by = c("Player"))

winLossOverall <- winLossOverall[Player == player]

if(empty(winLossOverall))
  winLossOverall <- fillEmpty(winLossOverall)

names(winLossOverall) <- c('player', 'Wins', 'Losses')

winLossOverall

}


############################################# Slam ##############################################
getwinLossSlam <- function(player){

WinsSlam <- WinsCategory('G')

LossesSlam <- LossesCategory('G')

names(WinsSlam)[1] <- names(LossesSlam)[1] <- "Player"

## merge the tables by "name"
winLossSlam <- merge(WinsSlam, LossesSlam, by = c("Player"))

winLossSlam <- winLossSlam[Player == player]

if(empty(winLossSlam))
  winLossSlam <- fillEmpty(winLossSlam)

names(winLossSlam) <- c('player', 'Wins', 'Losses')

winLossSlam

}

############################################# Masters 1000 ##############################################
  
getwinLossSlamM1000 <- function(player){
  
WinsM1000 <- WinsCategory('M')

LossesM1000 <- LossesCategory('M')

names(WinsM1000)[1] <- names(LossesM1000)[1] <- "Player"

## merge the tables by "name"
winLossM1000 <- merge(WinsM1000, LossesM1000, by = c("Player"))

winLossM1000 <- winLossM1000[Player == player]

if(empty(winLossM1000))
  winLossM1000 <- fillEmpty(winLossM1000)

names(winLossM1000) <- c('player', 'Wins', 'Losses')

winLossM1000


}


############################################# Clay ##############################################

  
getwinLossClay <- function(player){

surface <- 'Clay'

WinsClay <- winsSurface(surface)

LossesClay <- LossesSurface(surface)

names(WinsClay)[1] <- names(LossesClay)[1] <- "Player"

## merge the tables by "name"
winLossClay <- merge(WinsClay, LossesClay, by = c("Player"))

winLossClay <- winLossClay[Player == player]

if(empty(winLossClay))
  winLossClay <- fillEmpty(winLossClay)

names(winLossClay) <- c('player', 'Wins', 'Losses')

winLossClay

}
############################################# Grass ##############################################

getwinLossGrass <- function(player){
  
surface <- 'Grass'

WinsGrass <- winsSurface(surface)

LossesGrass <- LossesSurface(surface)

names(WinsGrass)[1] <- names(LossesGrass)[1] <- "Player"

## merge the tables by "name"
winLossGrass <- merge(WinsGrass, LossesGrass, by = c("Player"))

winLossGrass <- winLossGrass[Player == player]

if(empty(winLossGrass))
  winLossGrass <- fillEmpty(winLossGrass)

names(winLossGrass) <- c('player', 'Wins', 'Losses')

winLossGrass

}

############################################# Hard ##############################################

getwinLossHard <- function(player){
  
surface <- 'Hard'

WinsHard <- winsSurface(surface)

LossesHard <- LossesSurface(surface)

names(WinsHard)[1] <- names(LossesHard)[1] <- "Player"

## merge the tables by "name"
winLossHard <- merge(WinsHard, LossesHard, by = c("Player"))

winLossHard <- winLossHard[Player == player]

if(empty(winLossHard))
  winLossHard <- fillEmpty(winLossHard)

names(winLossHard) <- c('player', 'Wins', 'Losses')

winLossHard

}

############################################# Carpet ##############################################


getwinLossCarpet <- function(player){
  
surface <- 'Carpet'

WinsCarpet <- winsSurface(surface)

LossesCarpet <- LossesSurface(surface)

names(WinsCarpet)[1] <- names(LossesCarpet)[1] <- "Player"

## merge the tables by "name"
winLossCarpet <- merge(WinsCarpet, LossesCarpet, by = c("Player"))

winLossCarpet <- winLossCarpet[Player == player]

if(empty(winLossCarpet))
  winLossCarpet <- fillEmpty(winLossCarpet)
  
names(winLossCarpet) <- c('player', 'Wins', 'Losses')

winLossCarpet

}

##Fill is there is 0 wins or 0 losses
fillEmpty<- function(winLoss){
  
  winLoss <- setNames(data.table(matrix(nrow = 1, ncol = 3)), c("player", "Wins", "Losses"))
  
  winLoss <- data.table(player = player, Wins = 0, Losses = 0)
  
  
}