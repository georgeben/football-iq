# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
players = [
  {
    "data": {
      "name": "Cristiano Ronaldo",
      "age": 38,
      "current_club": "Al-Nassr",
      "previous_clubs": [
        "Sporting CP",
        "Manchester United",
        "Juventus"
      ],
      "league": "Saudi Professional League",
      "nationality": "Portugal",
      "shirt_number": 7,
      "positions": [
        "Forward"
      ],
      "trophies": [
        "UEFA European Championship",
        "UEFA Champions League", 
        "Premier League",
        "Serie A"
      ],
      "height": 187,
      "career_goals": 819,
      "is_retired": false
    }
  },
  {
    "data": {
      "name": "Neymar Jr.",
      "age": 31,
      "current_club": "Paris Saint-Germain",
      "previous_clubs": [
        "Santos",
        "Barcelona"
      ],
      "league": "Ligue 1",
      "nationality": "Brazil",
      "shirt_number": 10,
      "positions": [
        "Forward",
        "Attacking Midfielder"
      ],
      "trophies": [
        "Copa Libertadores",
        "Ligue 1",
        "Coupe de France"
      ],
      "height": 175,
      "career_goals": 403,
      "is_retired": false
    }
  },
  {
    "data": {
      "name": "Virgil van Dijk",
      "age": 32,
      "current_club": "Liverpool",
      "previous_clubs": [
        "Groningen",
        "Celtic",
        "Southampton"
      ],
      "league": "Premier League",
      "nationality": "Netherlands",
      "shirt_number": 4,
      "positions": [
        "Defender"
      ],
      "trophies": [
        "UEFA Champions League",
        "Premier League",
        "UEFA European Championship"
      ],
      "height": 193,
      "career_goals": 22,
      "is_retired": false
    }
  },
  {
    "data": {
      "name": "Luka Modrić",
      "age": 37,
      "current_club": "Real Madrid",
      "previous_clubs": [
        "Dinamo Zagreb",
        "Tottenham Hotspur"
      ],
      "league": "La Liga",
      "nationality": "Croatia",
      "shirt_number": 10,
      "positions": [
        "Midfielder"
      ],
      "trophies": [
        "UEFA Champions League",
        "La Liga",
        "FIFA World Cup (runner-up)"
      ],
      "height": 172,
      "career_goals": 104,
      "is_retired": false
    }
  }
]

Footballer.insert_all(players)
