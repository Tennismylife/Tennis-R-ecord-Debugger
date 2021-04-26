# Tennis-R-ecord-Debugger
A tools collection to debug our database

## Main

The main contains the 1st function to debug the TML Database 

Changing the variable 'player' is possible to comparate the stats on database and the ones in ATP website that remains our reference point, always

The script will produce an HTML simple page readble with all browset containg these stats:

* Wins-losses overall
* Wins-losses in Slams
* Wins-losses in ATP Masters 1000
* Wins-losses on clay
* Wins-losses on grass
* Wins-losses on hard
* Wins-losses on carpet

![MainDebugger](https://user-images.githubusercontent.com/49320517/116035920-1b4f7800-a666-11eb-97ed-3c8f93c046a0.png)

### Main from list

Very similar to Main, this script will search stats from a list and not for a single player. Using the scripts from Tennis-R-ecord-Tracker is possible to create your own list

![MainDebuggerFromList](https://user-images.githubusercontent.com/49320517/116036069-623d6d80-a666-11eb-8255-cccf05cb44e9.png)

## Seasons Review

ATP collects the wins-losses from a plyer dividing them into seasons. This creates a new debugger level: controlling all data from a player season-by-season to find the bugs

![SeasonReview](https://user-images.githubusercontent.com/49320517/116036356-d6781100-a666-11eb-901f-1b29982898bc.png)


## Add age

For a litte subset of player is impossible to find their age, but in some cases the ATP adds this datum (catched from the birthday), so you can add the correct age in the empty right cell

## No age finder

A simple script to find all the rows where tha player age is missing

## All matches from player

After knowing the bug is necessary to fix it. Collecting all the matches from a player is much easy to fix the bug


## Surface controller

This script will compare the surfaces in our database with the ATP ones. Sometimes ATP changes this surface so it's necessary fix this datum
