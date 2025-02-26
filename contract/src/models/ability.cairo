struct Ability {
    id: felt,
    name: felt,
    power: felt,
}

func initialize_ability(id: felt, name: felt, power: felt) -> (ability: Ability) {
    assert(power > 0, 'Ability power must be positive');
    let ability = Ability(id, name, power);
    return (ability,);
}

func use_ability(ability: Ability, target: Character) -> (target: Character) {
    assert(target.last_ability_used != ability.id, 'Ability can only be used once per turn');
    let new_health = target.health - ability.power;
    let updated_target = Character(target.id, target.name, new_health, ability.id);
    return (updated_target,);
}