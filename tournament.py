#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
import time

def connect():
    """Connect to the PostgreSQL database. Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    DB = connect()
    c = DB.cursor()
    c.execute("DELETE FROM match")

    DB.commit()
    DB.close()


def deletePlayers():
    """Remove all the player records from the database."""
    DB = connect()
    c = DB.cursor()
    c.execute("DELETE FROM player")

    DB.commit()
    DB.close()


def countPlayers():
    """Returns the number of players currently registered.

    (The database should count the players.)
    """
    DB = connect()
    c = DB.cursor()

    c.execute("SELECT COUNT(*) as NUM FROM player")
    count = c.fetchone()

    DB.close()
    return count[0]


def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player. (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    DB = connect()
    c = DB.cursor()

    c.execute("INSERT INTO player (name) VALUES (%s)", (name,))
    DB.commit()
    DB.close()

"""
(*) This code added to create player standing for newly created players;
    this feels like a hack, so I'm looking for an alternate solution.

    c.execute("SELECT id FROM player WHERE name = (%s) ORDER BY id DESC", (name,))
    newID = c.fetchone()
    c.execute("INSERT INTO player_standing (player_id, tournament_id, "
              "points_total, bye_count) VALUES (%s,1,0,0)", (newID[0],))
    DB.commit()
"""


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """

    DB = connect()
    c = DB.cursor()

    c.execute("SELECT * FROM current_standings")
    standings = c.fetchall()

    DB.close()

    # Walk through each tuple in standings list to check for null values
    # and replace null values ('None') with 0
    standings_clean = []
    for (pid, name, wins, matches) in standings:
        new_list = []
        if wins == None:
            new_list = [pid, name, 0, matches]
        else:
            new_list = [pid, name, wins, matches]
        tuple(new_list) # re-cast list as tuple to be added back to list
        standings_clean.append(new_list)

    return standings_clean 

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner: the id number of the player who won
      loser: the id number of the player who lost
    """
 
 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings. Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """

