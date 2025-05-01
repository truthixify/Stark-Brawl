use stark_brawl::models::ability::*;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ability_creation_and_validation() {
        let ability = Ability {
            id: 1_u256,
            name: 'Fireball',
            power: 50_u256,
            cooldown: 3_u8,
            mana_cost: 10_u8,
            level_required: 2_u8,
        };

        assert(ability.power == 50_u256, 'Ability power should be 50');
        ability.validate(5_u8, 20_u8);
    }

    #[test]
    fn test_ability_is_usable_true() {
        let ability = Ability {
            id: 2_u256,
            name: 'Icebolt',
            power: 30_u256,
            cooldown: 1_u8,
            mana_cost: 5_u8,
            level_required: 1_u8,
        };

        assert(ability.is_usable(3_u8, 10_u8), 'Ability should be usable');
    }

    #[test]
    #[should_panic(expected: 'INVALID_ABILITY_POWER')]
    fn test_invalid_power_panics() {
        let ability = Ability {
            id: 3_u256,
            name: 'Broken',
            power: 0_u256,
            cooldown: 2_u8,
            mana_cost: 5_u8,
            level_required: 1_u8,
        };

        ability.validate(5_u8, 10_u8);
    }
}