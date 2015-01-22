# Ruby Sweeper
My attempt to make a basic CLI  minesweeper game in Ruby

## Basic Plan

1. Create board-generating function as object (via board class)
  a. First generate size depending on input (if given 1 input, square board; 2=rectangle); give max
  b. calculate amount of mines to generate depending on board size; output that
  c. first display board openly for testing then hide everything
2. Create play methods to be called on the board
  a. sweep_cell
    i. determine if space is mine or not (true/false); if true, game over!
    ii. if space is not mine, determine if any neighbor spaces are and return that number
    iii. change display
  b. question_cell
    i. mark a cell as ? because user believes it to be a mine
    ii. change display appropriately.
  c. win_check
    i. after every action that isn't auto lose, check if the game's winning needs are met
    ii. if met, win; if not, nothing
  d. lose_game
    i. called if a mine is hit. end game appropriately.
3. extras
  a. user acceptance of number of mines or allow them to input their own number.
  b. oversweep-method: if a space is swept that has no neighboring mines, auto sweep out all neighbors that also return 0

## Description

Play a basic CLI version of everyone's favorite minesweeper! To start a game, just type:

XX start up code

Once the game is started, just enter in two numbers as a guess by typing:

XX guessing code

To win, you need to sweep every non-mine cell on the board. Sweeping any cell with a mine in it will result in a loss!

## Legal

Hahahahahaha good joke. Designed in pure experiment by Chris Singer, @tremulaes on twitter.