//Unit Tests

func test_initialize_player() -> () {
    let (player) = initialize_player(1, 'player1');
    assert(player.level == 1, 'Initial level should be 1');
    assert(player.experience == 0, 'Initial experience should be 0');
    return ();
}

func test_add_experience() -> () {
    let (player) = initialize_player(1, 'player1');
    let (player) = add_experience(player, 100);
    assert(player.experience == 100, 'Experience should be 100 after adding 100');
    return ();
}

func test_level_up() -> () {
    let (player) = initialize_player(1, 'player1');
    let (player) = level_up(player);
    assert(player.level == 2, 'Level should be 2 after leveling up');
    return ();
}

func test_add_experience_below_threshold() -> () {
    let (player) = initialize_player(1, 'player1');
    let (updated_player) = add_experience(player, 50);
    assert(updated_player.level == 1, 'Level should remain 1 when experience is below threshold');
    assert(updated_player.experience == 50, 'Experience should be 50 after adding 50');
    return ();
}

func test_add_experience_equal_to_threshold() -> () {
    let (player) = initialize_player(1, 'player1');
    let (updated_player) = add_experience(player, 100);
    assert(updated_player.level == 2, 'Level should be 2 after reaching the threshold');
    assert(updated_player.experience == 0, 'Experience should reset to 0 after leveling up');
    return ();
}

func test_add_experience_exceeding_threshold() -> () {
    let (player) = initialize_player(1, 'player1');
    let (updated_player) = add_experience(player, 150);
    assert(updated_player.level == 2, 'Level should be 2 after exceeding the threshold');
    assert(updated_player.experience == 50, 'Remaining experience should be 50 after leveling up');
    return ();
}

func test_add_experience_multiple_levels() -> () {
    let (player) = initialize_player(1, 'player1');
    let (updated_player) = add_experience(player, 250);
    assert(updated_player.level == 3, 'Level should be 3 after gaining enough experience for multiple levels');
    assert(updated_player.experience == 50, 'Remaining experience should be 50 after multiple level-ups');
    return ();
}