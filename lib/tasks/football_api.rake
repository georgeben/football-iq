leagues = [
  { name: "epl", id: 39 },
  { name: "la-liga", id: 140 },
  { name: "seria-a", id: 135 },
  { name: "bundesliga", id: 78 },
  { name: "league-1", id: 61 },
  { name: "eredivisie", id: 88 },
  { name: "liga-portugal", id: 94 }
]

namespace :football_api do
  desc "Fetch teams and players from api-football"
  task get_teams: [:environment] do
    leagues.each do |league|
      p "#{league[:name]}, #{league[:id]}"
      FootballApiService.fetch_teams_by_league_id(league)
    end
  end

  task :get_team_squad, [:team_name] => [:environment] do |t, args|
    team_name = args[:team_name]

    raise ArgumentError, "Missing argument: team_name" if team_name.nil?

    puts "Team name: #{team_name}"
    FootballApiService.fetch_team_squad team_name
  end

  task :get_footballers => [:environment] do
    FootballApiService.fetch_all_players
  end
end