use stark_brawl::models::statistics::*;

fn init_default() -> Statistics {
    let player_id = 1;
    let stats = initialize_statistics(player_id);

    assert(stats.player_id == player_id, 'Player ID should match');
    assert(stats.matches_played == 0, 'Matches played should be 0');
    assert(stats.wins == 0, 'Wins should be 0');
    assert(stats.defeats == 0, 'Defeats should be 0');
    
    return stats;
}

#[test]
fn test_initialize_statistics() {
    // Discard the return value with _ as we only verify that the initialization works correctly
    let _ = init_default();
}

#[test]
fn test_increment_matches_played() {
    let mut stats = init_default();
    stats.increment_matches_played();
    assert(stats.matches_played == 1, 'Matches played should be 1');
}

#[test]
fn test_increment_wins() {
    let mut stats = init_default();
    stats.increment_wins();
    assert(stats.wins == 1, 'Wins should be 1');
}

#[test]
fn test_increment_defeats() {
    let mut stats = init_default();
    stats.increment_defeats();
    assert(stats.defeats == 1, 'Defeats should be 1');
}

#[test]
fn test_get_win_rate() {
    let mut stats = init_default();
    
    // Case 1: 1 match, 1 win -> 100%
    stats.increment_matches_played();
    stats.increment_wins();
    assert(stats.get_win_rate() == 100, 'Win rate should be 100%');

    // Case 2: 2 matches, 1 win -> 50%
    stats.increment_matches_played();
    assert(stats.get_win_rate() == 50, 'Win rate should be 50%');

    // Case 3: 3 matches, 1 win -> 33%
    stats.increment_matches_played();
    stats.increment_defeats();
    assert(stats.get_win_rate() == 33, 'Win rate should be 33%');
}

#[test]
fn test_win_rate_with_zero_matches() {
    let stats = init_default();
    assert(stats.get_win_rate() == 0, 'Win rate should be 0%');
}