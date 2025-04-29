use super::super::models::character::CharacterTrait;
use stark_brawl::models::character::*;

fn init_default() -> Character {
    let id = 1;
    let name = 'Name';
    let health = 100;
    let attack = 10;
    let owner ='Owner';
    let character = initialize_character(id, name, health, attack , owner);
    assert_eq!(character.id, id);
    assert_eq!(character.name, name);
    assert_eq!(character.owner , owner);
    character
}

#[test]
fn test_initialize_character() {
   let _ = init_default();
}

#[test]
fn test_receive_damage() {
    let mut character = init_default();
    character.receive_damage(200); // damage more than the 100 life
    assert(!character.is_alive(), 'DAMAGE FAILED');
}

#[test]
fn test_is_alive() {
    let character = init_default();
    assert(character.is_alive(), 'INIT FAILED');
}

#[test]
fn test_attack_target(){
    let mut target = init_default();
    let attacker = init_default();

    target.attack_target(attacker);
    assert(target.health == 90 , 'targert_helth_should_90');
    target.attack_target(attacker);
    assert(target.health == 80 , 'targert_helth_should_80');
}