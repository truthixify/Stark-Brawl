// src/tests/player_test.cairo

use core::traits::Into;
use dojo::test;
use dojo::model::*;
use your_crate::player::{Player, initialize_player, add_experience, level_up};

#[test]
fn test_initialize_player() {
    let player = initialize_player(1, 'player1');
    assert_eq!(player.level, 1);
    assert_eq!(player.experience, 0);
}

#[test]
fn test_add_experience() {
    let player = initialize_player(1, 'player1');
    let updated_player = add_experience(player, 100);
    assert_eq!(updated_player.experience, 100);
}

#[test]
fn test_level_up() {
    let player = initialize_player(1, 'player1');
    let updated_player = level_up(player);
    assert_eq!(updated_player.level, 2);
}

#[test]
fn test_add_experience_below_threshold() {
    let player = initialize_player(1, 'player1');
    let updated_player = add_experience(player, 50);
    assert_eq!(updated_player.level, 1);
    assert_eq!(updated_player.experience, 50);
}

#[test]
fn test_add_experience_equal_to_threshold() {
    let player = initialize_player(1, 'player1');
    let updated_player = add_experience(player, 100); // assuming 100 is threshold
    assert_eq!(updated_player.level, 2);
    assert_eq!(updated_player.experience, 0);
}

#[test]
fn test_add_experience_exceeding_threshold() {
    let player = initialize_player(1, 'player1');
    let updated_player = add_experience(player, 150); // threshold 100
    assert_eq!(updated_player.level, 2);
    assert_eq!(updated_player.experience, 50);
}

#[test]
fn test_add_experience_multiple_levels() {
    let player = initialize_player(1, 'player1');
    let updated_player = add_experience(player, 250); // should level up twice
    assert_eq!(updated_player.level, 3);
    assert_eq!(updated_player.experience, 50);
}
