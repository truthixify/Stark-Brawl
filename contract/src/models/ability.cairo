use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Ability {
    #[key]
    pub id: u256,
    pub name: felt252,
    pub power: u256,
    pub cooldown: u8,
    pub mana_cost: u8,
    pub level_required: u8,
}

pub mod errors {
    pub const INVALID_ABILITY_POWER: felt252 = 'Ability: Power must be > 0';
    pub const INVALID_ABILITY_COOLDOWN: felt252 = 'Ability: Cooldown too high';
    pub const LEVEL_TOO_LOW: felt252 = 'Ability: Level too low';
    pub const NOT_ENOUGH_MANA: felt252 = 'Ability: Not enough mana';
}

#[generate_trait]
pub impl AbilityImpl of AbilityTrait {
    fn is_usable(self: @Ability, user_level: u8, user_mana: u8) -> bool {
        user_level >= *self.level_required && user_mana >= *self.mana_cost
    }

    fn validate(self: @Ability, user_level: u8, user_mana: u8) {
        assert(*self.power > 0_u256, errors::INVALID_ABILITY_POWER);
        assert(*self.cooldown < 10_u8, errors::INVALID_ABILITY_COOLDOWN);
        assert(user_level >= *self.level_required, errors::LEVEL_TOO_LOW);
        assert(user_mana >= *self.mana_cost, errors::NOT_ENOUGH_MANA);
    }
}

pub impl ZeroableAbilityTrait of Zero<Ability> {
    #[inline(always)]
    fn zero() -> Ability {
        Ability {
            id: 0_u256, name: '0', power: 0_u256, cooldown: 0, mana_cost: 0, level_required: 0,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Ability) -> bool {
        *self.id == 0_u256
    }

    #[inline(always)]
    fn is_non_zero(self: @Ability) -> bool {
        !self.is_zero()
    }
}

#[cfg(test)]
mod tests {
    use super::{Ability, AbilityImpl, ZeroableAbilityTrait};

    fn sample_ability() -> Ability {
        Ability {
            id: 1_u256,
            name: 'Fireball',
            power: 100_u256,
            cooldown: 5,
            mana_cost: 20,
            level_required: 3,
        }
    }

    #[test]
    fn test_is_usable_true() {
        let ability = sample_ability();
        assert(AbilityImpl::is_usable(@ability, 5, 25), 'Ability should be usable');
    }

    #[test]
    fn test_is_usable_false_level() {
        let ability = sample_ability();
        assert(!AbilityImpl::is_usable(@ability, 2, 25), 'Level too low');
    }

    #[test]
    fn test_is_usable_false_mana() {
        let ability = sample_ability();
        assert(!AbilityImpl::is_usable(@ability, 5, 10), 'Not enough mana');
    }

    #[test]
    fn test_validate_success() {
        let ability = sample_ability();
        AbilityImpl::validate(@ability, 5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Power must be > 0',))]
    fn test_invalid_power() {
        let mut ability = sample_ability();
        ability.power = 0_u256;
        AbilityImpl::validate(@ability, 5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Cooldown too high',))]
    fn test_invalid_cooldown() {
        let mut ability = sample_ability();
        ability.cooldown = 12;
        AbilityImpl::validate(@ability, 5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Level too low',))]
    fn test_invalid_level() {
        let ability = sample_ability();
        AbilityImpl::validate(@ability, 2, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Not enough mana',))]
    fn test_invalid_mana() {
        let ability = sample_ability();
        AbilityImpl::validate(@ability, 5, 10);
    }

    #[test]
    fn test_zero_ability() {
        let ability = ZeroableAbilityTrait::zero();
        assert(ability.is_zero(), 'Zero ability should be zero');
    }
}
