#Function to aggregate my data and ATP one
aggregateATP <- function(ATPDBwinLossOverall, MyDBwinLossOverall, type, player){
  
  ATPDBwinLossOverall <- cbind(player, type, "ATP", ATPDBwinLossOverall)
  
  names(ATPDBwinLossOverall) <- c('player', 'type','source', 'Wins', 'Losses')
  
  MyDBwinLossOverall <- cbind("My", type, MyDBwinLossOverall)
  
  names(MyDBwinLossOverall) <- c('source', 'type','player', 'Wins', 'Losses')
  
  MyDBwinLossOverall <- MyDBwinLossOverall[,c("player", "type", "source", "Wins", "Losses")]
  
  winLossOverall <- rbind(ATPDBwinLossOverall, MyDBwinLossOverall)
  
  
  winLossOverall
}
