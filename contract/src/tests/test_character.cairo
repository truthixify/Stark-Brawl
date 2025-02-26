use stark_brawl::models::character::*;

fn init_default() -> Character {
    let id = 1;
    let name = 'Name';
    let health = 100;
    let attack = 10;
    let character = initialize_character(id, name, health, attack);
    assert_eq!(character.id, id);
    assert_eq!(character.name, name);
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