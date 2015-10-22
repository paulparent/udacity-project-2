#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament

import psycopg2
import time
from datetime import datetime

def connect():
    """Connect to the PostgreSQL database. 

    Returns: a database connection object
    """
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
    """Queries the database for the count of currently registered players.

    Returns: count, an integer indicating the number of players currently
        registered.
    """
    DB = connect()
    c = DB.cursor()

    c.execute("SELECT COUNT(*) as NUM FROM player")
    count = c.fetchone()

    DB.close()
    return count[0]


def registerPlayer(name):
    """Adds a player to the tournament database. The database assigns a unique
        serial id number for the player.

    Args:
      name: the player's full name (need not be unique).
    """
    DB = connect()
    c = DB.cursor()

    c.execute("INSERT INTO player (name) VALUES (%s)", (name,))
    DB.commit()
    DB.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

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

    return standings


def reportMatch(winner, loser):
    """
    Records the outcome of a single match between two players. Because no
    test does not supply a match_id, this function first creates new match
    linked to the default record in the tournament table ('no tournament').

    Full set of records for a match consists of records for:
        match (id, player_id_1, player_id_2, tournament_id, match_start) and
        records for match_result (match_id, player_id, result)
        for each player.

    Args:
      winner: the id number of the player who won
      loser: the id number of the player who lost
    """

    DB = connect()
    c = DB.cursor()

    # before recording results, create record for the match
    c.execute("INSERT INTO match (player_id_1, player_id_2, tournament_id, "
        "match_start) VALUES (%s, %s, 1, %s)", (winner, loser, datetime.now(),))

    c.execute("SELECT MAX(id) FROM match")
    m_id = c.fetchone()[0] # get most recent match_id

    c.execute("INSERT INTO match_result (match_id, player_id, result) "
        "VALUES (%s, %s, %s)", (m_id, winner, 'Win',))
    c.execute("INSERT INTO match_result (match_id, player_id, result) "
        "VALUES (%s, %s, %s)", (m_id, loser, 'Loss',))

    DB.commit()
    DB.close()


def swissPairings():
    """
    Draws the current player standings (ranked by wins) from the database and
    creates pairs players for the next round of the match.
  
    Assuming an even number of registered players, each player is paired with
    exactly one other player. Each player appears exactly once in the
    pairings. Each player is paired with the player closest in the standings
    (with an equal or nearly-equal win record).
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        p1_id: the first player's unique id
        p1_name: the first player's name
        p2_id: the second player's unique id
        p2_name: the second player's name
    """

    DB = connect()
    c = DB.cursor()

    c.execute("SELECT * FROM current_standings")
    standings = c.fetchall()

    DB.close()

    pairings = []
    for n in range(len(standings)/2):
        p1 = standings.pop(0)
        p2 = standings.pop(0)

        p1_id = p1[0]
        p1_name = p1[1]

        p2_id = p2[0]
        p2_name = p2[1]

        new_pair = p1_id, p1_name, p2_id, p2_name
        pairings.append(new_pair)

    return pairings
