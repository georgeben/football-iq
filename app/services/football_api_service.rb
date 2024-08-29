class FootballApiService
  
  SEASON = '2024'
  API_PROVIDER_NAME = 'api-football.com'

  attr_reader :client

  def initialize
    @client = ApiFootballV3::Client.new do |config|
      config.api_key = Rails.application.credentials.dig(:football_api, :api_key)
      config.base_url = "https://v3.football.api-sports.io/"
    end
  end

  def self.fetch_teams_by_league_id(league)
    new.fetch_teams_by_league_id(league:)
  end

  def self.fetch_team_squad(team_name)
    new.fetch_team_squad(team_name)
  end

  def self.fetch_all_players
    new.fetch_all_players
  end

  def fetch_teams_by_league_id(league:, page: 1)
    response = client.teams(league: league[:id], season: SEASON)
    errors = response.dig("errors")

    if errors.present?
      raise StandardError, "Failed to fetch teams: #{errors}"
    end

    teams_response = response.dig("response")

    saved_teams = Team.upsert_all(
      teams_response.map { |item| { name: item.dig('team', 'name'), logo: item.dig('team', 'logo'), league: league[:name] } },
      unique_by: :name,
      returning: %w[name id ]
    )
    saved_teams_id_hash = saved_teams.rows.to_h

    team_api_identifiers = teams_response.map do |item|
      {
        provider_name: API_PROVIDER_NAME,
        provider_id: item.dig('team', 'id'),
        identifiable_type: Team.name,
        identifiable_id: saved_teams_id_hash[item.dig('team', 'name')]
      }
    end

    ApiIdentifier.upsert_all(
      team_api_identifiers,
      unique_by: [:provider_name, :provider_id, :identifiable_type]
    )

    current_page = response.dig('paging', 'current')
    total_pages = response.dig('paging', 'total')

    if current_page < total_pages
      fetch_teams_by_league_id(league_id:, page: page + 1)
    end
    puts "Successfully fetched all teams from league: #{league[:name]}"
  end

  def fetch_all_players
    teams = [
      'Manchester United', 'Newcastle', 'Liverpool', 'Arsenal', 'Tottenham', 'Chelsea', 'Real Madrid', 'Bayern München', 'Paris Saint Germain',
      'Manchester City', 'Barcelona', 'Atletico Madrid', 'Borussia Dortmund', 'Athletic Club', 'Valencia', 'Brighton', 'Aston Villa',
      'Bayer Leverkusen', 'Villarreal', 'Sevilla', 'Real Betis', 'Getafe', 'Girona', 'Real Sociedad', 'Lazio', 'AC Milan',
      'Napoli', 'Juventus', 'AS Roma', 'Atalanta', 'Fiorentina', 'Inter', 'FSV Mainz 05',
      'VfB Stuttgart', 'RB Leipzig', 'Lyon', 'Marseille', 'Nice', 'West Ham', 'Fulham', 'Wolves',
      'Monaco', 'Rennes', 'Ajax', 'PSV Eindhoven', 'Benfica', 'FC Porto', 'Sporting CP', 'Eintracht Frankfurt', 'Lille'
    ]
    teams.each do |team|
      fetch_team_squad team
    end
  end


  def fetch_team_squad(team_name)
    team = Team.find_by(name: team_name)

    raise StandardError, "Could not find team: #{team_name}" if team.nil?
   
    api_identifier = team.api_identifiers.find_by(provider_name: API_PROVIDER_NAME)
    team_id = api_identifier.provider_id
    
    team_squad_response = client.get('/players/squads', { team: team_id })

    if team_squad_response['errors'].present?
      raise StandardError, "Failed to fetch teams: #{team_squad_response['errors']}"
    end

    squad = team_squad_response.dig('response', 0, 'players')
    puts "Successfully fetched team squad for #{team_name}"
 
    squad.each do |player|
      existing_record = Footballer.where("data ->> 'photo' = :photo AND data ->> 'current_club' = :team", photo: player['photo'], team: team_name)
      if existing_record.exists?
        puts "Found existing record for #{player['name']}, skipping..."
        next
      end
      puts "Fetching profile for #{player['name']}"

      player_data = fetch_player(player_id: player['id'], team_id:)
      digest = Footballer.generate_digest(
        name: player_data[:name],
        date_of_birth: player_data[:date_of_birth],
        nationality: player_data[:nationality]
      )
      Footballer.transaction do
        result = Footballer.upsert(
          { digest:, data: { shirt_number: player['number'], **player_data } },
          returning: [:id],
          unique_by: :digest
        )

        ApiIdentifier.upsert(
          { 
            provider_name: API_PROVIDER_NAME,
            provider_id: player['id'],
            identifiable_type: Footballer.name,
            identifiable_id: result.rows.dig(0, 0)
          },
          unique_by: [:provider_name, :provider_id, :identifiable_type]
        )
      end
      puts "Successfully saved footballer profile to database"

      sleep 40 # Free plan is currently limited to 10 requests per minute
    end

  end

  def fetch_player(player_id:, team_id:)
    player_response = client.players(id: player_id, team: team_id, season: SEASON)

    if player_response['errors'].present?
      raise StandardError, "Failed to fetch player: #{player_response['errors']}"
    end

    player = player_response.dig('response', 0, 'player')
    stats = player_response.dig('response', 0, 'statistics').find { |item| item.dig('team', 'id').to_s == team_id.to_s }
    team = stats['team']
    league = stats['league']

    previous_clubs = get_previous_clubs(player_id)
    trophies = get_player_trophies(player_id)

    {
      id: player['id'],
      name: "#{player['firstname']} #{player['lastname']}",
      common_name:  player['name'],
      date_of_birth: player.dig('birth', 'date'),
      current_club: team['name'],
      photo: player['photo'],
      previous_clubs:,
      league: league['name'],
      nationality: player['nationality'],
      positions: [stats.dig('games', 'position')],
      trophies:,
      height: player['height']
    }
  end

  private

  def get_previous_clubs(player_id)
    transfers_response = client.transfers(player: player_id)
    if transfers_response['errors'].present?
      raise StandardError, "Failed to fetch transfer history for player #{player_id}. Error: #{transfers_response['errors']}"
    end
    transfers = transfers_response.dig('response', 0, 'transfers')
    return [] if transfers.nil?
    previous_clubs = transfers.map { |transfer| transfer.dig('teams', 'out', 'name') }
    previous_clubs.uniq
  end

  def get_player_trophies(player_id)
    trophies_response = client.trophies(player: player_id)
    if trophies_response['errors'].present?
      raise StandardError, "Failed to fetch trophies for player #{player_id}. Error: #{trophies_response['errors']}"
    end

    return [] if  trophies_response.dig('response').nil?

    trophies_response.dig('response')
      .select { |item| item['place'] == 'Winner' }
      .map { |item| item['league'] }
      .uniq
  end
end