# Ruby Sweeper
My attempt to make a basic CLI  minesweeper game in Ruby

## Basic Plan

1. Create board-generating function as object (via board class)
  a. generate static size
  b. first display board openly for testing then hide everything DONE!
2. Create play methods to be called on the board
  a. sweep_cell
    i. determine if space is mine or not (true/false); if true, game over! DONE!
    ii. if space is not mine, determine if any neighbor spaces are and return that number DONE!
    iii. change display DONE!
  b. question_cell
    i. mark a cell as ? because user believes it to be a mine DONE!
    ii. change display appropriately. DONE!
  c. win_check
    i. after every action that isn't auto lose, check if the game's winning needs are met DONE!
    ii. if met, win; if not, nothing DONE!
  d. lose_game
    i. called if a mine is hit. end game appropriately. DONE!
3. extras
  a. user acceptance of number of mines or allow them to input their own number.
  b. oversweep method: if a space is swept that has no neighboring mines, auto sweep out all neighbors that also return 0
  c. better user interaction if bad data or out-of-bounds attempts are inputted as method parameters
  d. generate size depending on input (if given 1 input, square board; 2=rectangle); give max
  e. calculate amount of mines to generate depending on board size

## Description

Play a basic CLI version of everyone's favorite minesweeper! To start a game, just type:

name_of_new_game = Board.new

Once the game is started, just enter in two numbers as a guess by typing:

sweep_cell(x,y)

To win, you need to sweep every non-mine cell on the board. Sweeping any cell with a mine in it will result in a loss!

## Legal

Hahahahahaha good joke. Designed in pure experiment by Chris Singer, @tremulaes on twitter.