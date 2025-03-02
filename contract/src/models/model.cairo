
// Enum for match status
enum MatchStatus {
    NotStarted = 0,
    InProgress = 1,
    Finished = 2
}

// Define the match structure
struct Match {
    status: felt,      // The current status of the match (NotStarted, InProgress, Finished)
    teams: felt*,      // List of teams in the match
    team_alive: felt*, // List of 1 or 0 indicating whether the teams are still alive
}

// Function to initialize the match
func initialize_match(id: felt, teams: felt*) -> Match {
    let status = MatchStatus::NotStarted;
    let team_alive = [1, 1]; // Assuming all teams are initially alive
    return Match(status=status, teams=teams, team_alive=team_alive);
}

// Function to start the match
func start_match(match: Match) {
    match.status = MatchStatus::InProgress;
}

// Function to end the match
func end_match(match: Match) {
    let team1_alive = match.team_alive[0];
    let team2_alive = match.team_alive[1];

    // The match can only be ended if at least one team is completely defeated
    if team1_alive == 0 or team2_alive == 0 {
        match.status = MatchStatus::Finished;
    }
}

// Function to get the winner
func get_winner(match: Match) -> felt {
    let team1_alive = match.team_alive[0];
    let team2_alive = match.team_alive[1];

    // If both teams are alive, no winner
    if team1_alive == 1 and team2_alive == 1 {
        return 0; // No winner
    }
    
    // Return the team number that is still alive
    if team1_alive == 1 {
        return match.teams[0]; // Team 1 wins
    }
    if team2_alive == 1 {
        return match.teams[1]; // Team 2 wins
    }
    
    return 0; // If both teams are dead, no winner
}
