//Unit Tests
func test_initialize_ability() -> () {
    let (ability) = initialize_ability(1, 'Fireball', 50);
    assert(ability.power == 50, 'Ability power should be initialized to 50');
    assert(ability.name == 'Fireball', 'Ability name should be Fireball');
    return ();
}

func test_initialize_ability_negative_power() -> () {
    let (ability) = initialize_ability(2, 'Invalid', -10);
    assert(ability.power > 0, 'Ability power must be positive');
    return ();
}

func test_use_ability() -> () {
    let (ability) = initialize_ability(1, 'Fireball', 50);
    let target = initialize_character(2, 'Enemy', 100, 0);
    let (target) = use_ability(ability, target);
    assert(target.health == 50, 'Target health should be reduced by ability power');
    return ();
}

func test_use_ability_once_per_turn() -> () {
    let (ability) = initialize_ability(1, 'Fireball', 50);
    let target = initialize_character(2, 'Enemy', 100, 0);
    let (target) = use_ability(ability, target);
    let (target) = use_ability(ability, target); // Trying to use again in the same turn
    assert(target.health == 50, 'Ability should only be used once per turn');
    return ();
}