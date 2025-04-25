struct Player {
    id: felt,
    username: felt,
    level: felt,
    experience: felt,
}

func initialize_player(id: felt, username: felt) -> (player: Player) {
    let player = Player(id, username, 1, 0);
    return (player,);
}

// Helper function to calculate the experience threshold for leveling up
func get_experience_threshold(level: felt) -> (threshold: felt) {
    return (threshold=level * 100,);
}

func add_experience(player: Player, amount: felt) -> (player: Player) {
    let mut new_experience = player.experience + amount;
    let mut new_level = player.level;

    // Loop to handle multiple level-ups if experience exceeds multiple thresholds
    let (mut threshold) = get_experience_threshold(new_level);
    while new_experience >= threshold {
        new_experience -= threshold;
        new_level += 1;
        let (updated_threshold) = get_experience_threshold(new_level);
        threshold = updated_threshold;
    }

    let updated_player = Player(player.id, player.username, new_level, new_experience);
    return (updated_player,);
}