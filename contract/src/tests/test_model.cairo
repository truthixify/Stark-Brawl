
from src.models.match import initialize_match, start_match, end_match, get_winner

// Test for match initialization
func test_initialize_match() -> () {
    let teams = [1, 2];
    let match = initialize_match(1, teams);
    
    // Assert match is initialized as Not Started
    assert(match.status == 0, 'Match should be initialized as Not Started');
    
    // Assert match has 2 teams
    assert(match.teams.len() == 2, 'Match should have 2 teams');
    
    return ();
}

// Test for starting match
func test_start_match() -> () {
    let teams = [1, 2];
    let match = initialize_match(1, teams);
    
    // Start the match
    start_match(match);
    
    // Assert match status is In Progress
    assert(match.status == 1, 'Match status should be In Progress');
    
    return ();
}

// Test for ending match
func test_end_match() -> () {
    let teams = [1, 2];
    let match = initialize_match(1, teams);
    
    // Start the match
    start_match(match);
    
    // End the match
    end_match(match);
    
    // Assert match status is Finished
    assert(match.status == 2, 'Match status should be Finished');
    
    return ();
}

// Test for getting winner
func test_get_winner() -> () {
    let teams = [1, 2];
    let match = initialize_match(1, teams);
    
    // Start the match
    start_match(match);
    
    // Simulate team 2 being defeated
    let team1_alive = 1;
    let team2_alive = 0;
    
    // Set the team_alive array based on the simulation
    match.team_alive = [team1_alive, team2_alive];
    
    // Check the winner
    let winner = get_winner(match);
    
    if team1_alive == 1 and team2_alive == 0 {
        assert(winner == 1, 'Team 1 should be the winner');
    } else if team1_alive == 0 and team2_alive == 1 {
        assert(winner == 2, 'Team 2 should be the winner');
    } else {
        assert(winner == 0, 'No team should be the winner if both are dead');
    }
    
    return ();
}
