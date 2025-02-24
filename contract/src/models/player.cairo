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

func add_experience(player: Player, amount: felt) -> (player: Player) {
    let new_experience = player.experience + amount;
    let updated_player = Player(player.id, player.username, player.level, new_experience);
    return (updated_player,);
}

func level_up(player: Player) -> (player: Player) {
    let new_level = player.level + 1;
    let updated_player = Player(player.id, player.username, new_level, player.experience);
    return (updated_player,);
}
