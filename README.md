Project: Tournament Results
===========================
Python module that uses a PostgreSQL database to keep track of players and matches for game tournaments using the Swiss System of creating match-ups between players.

Created by Paul Parent as part of the Udacity Full Stack Web Developer Nanodegree program. Last updated: October 22, 2015

Required Libraries and Dependencies
-----------------------------------
This project requires Python v2.x and PostgreSQL v9.x to be installed on the user's computer.

The project was built and tested under an Ubuntu-based virtual machine running in VirtualBox through a Vagrant configuration provided by Udacity for the purposes of this project. The project should not be dependent on this specific environment, but it has not been tested outside the virtual machine environment provided by Udacity. Instructions below assume this environment is in place.

How to Run Project
------------------
1. Download the latest copy of the project from https://github.com/paulparent/udacity-project-2.git (there is a small "Download ZIP" button at the bottom of the column at the right side of the repository page).
1. The download contains the following files:
    - README.md (this document)
    - tournament.py
    - tournament.sql
    - tournament_test.py
1. Unzip and move these files to the `/vagrant/tournament` directory created by the Udacity Vagrant file.
1. To run the project locally: 
    - in a terminal window, navigate to the `/vagrant/tournament` directory
    - launch the development environment by typing `vagrant up` and then log in by typing `vagrant ssh`
    - from the command line within the virtual machine, navigate to the `/vagrant/tournament` directory
    - launch the unit tests by typing `python tournament_test.py` at the command line and pressing `enter`
    - the program will run several automatic tests on the program logic (`tournament.py`) and database design and queries (`tournament.sql`)
    - once finished with these tests, the program will exit
    - the user can close the virtual machine by typing `exit` and `enter` at the command line within the project
    - once outside the virtual machine and at the terminal prompt in the user's host environment, `vagrant halt` and `enter` will shut down the virtual machine

Extra Credit Description
------------------------
This project includes a few additional features beyond the base specifications:
 * Views have been used within the SQL to make queries more concise; specifically, see the player_wins, player_matches, and current_standings views
 * Primary and foreign keys have been defined for each table in the database
 * All sorting and aggregation of data is performed by the database
 * The database is designed to accommodate real-world cases beyond the tests provided, allowing functionality to be later extended with application logic without requiring changes to the data model. Notable examples:
    - `match_result` data separate from `match` data allows for efficient recording of 'win', 'loss', 'draw', and 'bye' result types
    - separate `match` and `match_result` also allows for matches to be scheduled and recorded before results are known (and without adding null values to database)
    - `tournament` table allows multiple tournaments and matches to be associated with a tournament, preserving context around matches and enabling additional future functionality in the context of executing tournaments
