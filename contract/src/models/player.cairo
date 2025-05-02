use core::integer::u32;
use core::option::Option;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Player {
    id: felt252,
    username: felt252,
    level: u32,
    experience: u32,
}

/// Initializes a new player with level 1 and 0 experience
fn initialize_player(id: felt252, username: felt252) -> Player {
    Player {
        id,
        username,
        level: 1_u32,
        experience: 0_u32,
    }
}

/// Returns the XP threshold for the given level
fn get_experience_threshold(level: u32) -> u32 {
    level * 100_u32
}

/// Adds XP to the player and levels up as needed
fn add_experience(mut player: Player, amount: u32) -> Player {
    player.experience += amount;

    // Level up while experience exceeds the current threshold
    let mut threshold = get_experience_threshold(player.level);
    while player.experience >= threshold {
        player.experience -= threshold;
        player.level += 1;
        threshold = get_experience_threshold(player.level);
    }

    player
}
