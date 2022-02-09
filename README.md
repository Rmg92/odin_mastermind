# Mastermind
This project is part of [The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/mastermind) Full Stack Ruby curriculum.

## Description
Mastermind or Master Mind is a code-breaking game for two players. This implementation of the game is played against the computer.
The human player can choose if he wants to be the code creator or the code breaker.

## Rules
This implementation of the game follows the rules described on the [Mastermind wikipedia page](https://en.wikipedia.org/wiki/Mastermind_(board_game))

## Built with
* Ruby

## Play Online
[replit.com](https://replit.com/@Rmg92/odinmastermind?v=1) click on the green "Run" button

## Play Locally
### Prerequisites
You need to have Ruby installed to play locally.

### Procedure
Clone the repo to a folder of your preference:
```sh
git@github.com:Rmg92/odin_mastermind.git
```
cd into the folder and:
```sh
ruby main.rb
```

## What I Learned
The most dificult part of this project was creating the logic to give feedback on the player guess and then, in case of the computer being the code breaker, making him decide on the next guess based on the feedback received.

Apart from that it was another nice practice on OOP, there is still a lot I think I can improve (what should/shouldn't be a class, ...), and some things I definitly need to recheked (private/public method's, modules, ...).

## To-Do
- [X] Make the game playable when the computer is the creator and the player the guesser
- [X] Make the game playable when the computer is the guesser and the player is the creator
- [X] Let the player choose if he wants to be the creator or the guesser
- [ ] Update the UI
- [ ] Improve the Computer AI
- [ ] Clean the code

## Acknowledgments
* [The Odin Project](https://www.theodinproject.com/)
* [Github](https://github.com/)
* [Replit](https://replit.com/)