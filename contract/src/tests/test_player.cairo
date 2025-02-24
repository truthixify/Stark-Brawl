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
