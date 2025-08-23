use core::num::traits::zero::Zero;
use starknet::ContractAddress;

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

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
// add new abilities as needed(or remove)
pub enum AbilityType {
    Fireball,
    Lightning,
    Heal,
    Shield,
    Regenerate,
    IceSpear,
    Poison,
}

pub mod errors {
    pub const INVALID_ABILITY_POWER: felt252 = 'Ability: Power must be > 0';
    pub const INVALID_ABILITY_COOLDOWN: felt252 = 'Ability: Cooldown too high';
    pub const LEVEL_TOO_LOW: felt252 = 'Ability: Level too low';
    pub const NOT_ENOUGH_MANA: felt252 = 'Ability: Not enough mana';
    pub const ABILITY_NOT_FOUND: felt252 = 'Ability: Not found';
    pub const ABILITY_NOT_EQUIPPED: felt252 = 'Ability: Not equipped';
    pub const ABILITY_ON_COOLDOWN: felt252 = 'Ability: On cooldown';
    pub const INSUFFICIENT_MANA: felt252 = 'Ability: Insufficient mana';
    pub const INSUFFICIENT_LEVEL: felt252 = 'Ability: Level too low';
    pub const INVALID_TARGET: felt252 = 'Ability: Invalid target';
    pub const TARGET_NOT_ALIVE: felt252 = 'Ability: Target not alive';
    pub const PLAYER_NOT_ALIVE: felt252 = 'Ability: Player not alive';
    pub const INVALID_ABILITY_TYPE: felt252 = 'Ability: Invalid type';
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum AbilityEffectType {
    Damage,
    Heal,
    Shield,
    ManaRestore,
    DamageOverTime,
}

#[derive(Copy, Drop, Serde, Debug)]
pub struct AbilityUsageContext {
    pub ability_id: u256,
    pub caster: ContractAddress,
    pub target: ContractAddress,
    pub current_timestamp: u64,
}

#[derive(Copy, Drop, Serde, Debug)]
pub struct AbilityUsageResult {
    pub effect_type: AbilityEffectType,
    pub effect_amount: u32,
    pub mana_consumed: u8,
    pub cooldown_until: u64,
}

impl AbilityTypeIntoFelt252 of Into<AbilityType, felt252> {
    fn into(self: AbilityType) -> felt252 {
        match self {
            AbilityType::Fireball => 'Fireball',
            AbilityType::Lightning => 'Lightning',
            AbilityType::Heal => 'Heal',
            AbilityType::Shield => 'Shield',
            AbilityType::Regenerate => 'Regenerate',
            AbilityType::IceSpear => 'IceSpear',
            AbilityType::Poison => 'Poison',
        }
    }
}

impl Felt252TryIntoAbilityType of TryInto<felt252, AbilityType> {
    fn try_into(self: felt252) -> Option<AbilityType> {
        if self == 'Fireball' {
            Option::Some(AbilityType::Fireball)
        } else if self == 'Lightning' {
            Option::Some(AbilityType::Lightning)
        } else if self == 'Heal' {
            Option::Some(AbilityType::Heal)
        } else if self == 'Shield' {
            Option::Some(AbilityType::Shield)
        } else if self == 'Regenerate' {
            Option::Some(AbilityType::Regenerate)
        } else if self == 'IceSpear' {
            Option::Some(AbilityType::IceSpear)
        } else if self == 'Poison' {
            Option::Some(AbilityType::Poison)
        } else {
            Option::None
        }
    }
}

#[generate_trait]
pub impl AbilityTypeImpl of AbilityTypeTrait {
    fn get_effect_type(self: AbilityType) -> AbilityEffectType {
        match self {
            AbilityType::Fireball => AbilityEffectType::Damage,
            AbilityType::Lightning => AbilityEffectType::Damage,
            AbilityType::IceSpear => AbilityEffectType::Damage,
            AbilityType::Heal => AbilityEffectType::Heal,
            AbilityType::Shield => AbilityEffectType::Shield,
            AbilityType::Regenerate => AbilityEffectType::ManaRestore,
            AbilityType::Poison => AbilityEffectType::DamageOverTime,
        }
    }

    fn is_damage_type(self: AbilityType) -> bool {
        match self {
            AbilityType::Fireball => true,
            AbilityType::Lightning => true,
            AbilityType::IceSpear => true,
            _ => false,
        }
    }

    fn is_healing_type(self: AbilityType) -> bool {
        self == AbilityType::Heal
    }

    fn is_support_type(self: AbilityType) -> bool {
        match self {
            AbilityType::Shield => true,
            AbilityType::Regenerate => true,
            _ => false,
        }
    }
}

#[generate_trait]
pub impl AbilityImpl of AbilityTrait {
    fn new(
        id: u256,
        ability_type: AbilityType,
        power: u256,
        cooldown: u8,
        mana_cost: u8,
        level_required: u8,
    ) -> Ability {
        Ability { id, name: ability_type.into(), power, cooldown, mana_cost, level_required }
    }

    fn get_ability_type(self: @Ability) -> AbilityType {
        (*self.name).try_into().unwrap()
    }

    fn is_valid_ability_type(self: @Ability) -> bool {
        match self.get_ability_type() {
            AbilityType::Fireball | AbilityType::Lightning | AbilityType::Heal |
            AbilityType::Shield | AbilityType::Regenerate | AbilityType::IceSpear => true,
            _ => false,
        }
    }

    fn is_usable(self: @Ability, user_level: u8, user_mana: u8) -> bool {
        user_level >= *self.level_required && user_mana >= *self.mana_cost
    }

    fn validate(self: @Ability, user_level: u8, user_mana: u8) {
        assert(*self.power > 0_u256, errors::INVALID_ABILITY_POWER);
        assert(*self.cooldown < 10_u8, errors::INVALID_ABILITY_COOLDOWN);
        assert(user_level >= *self.level_required, errors::LEVEL_TOO_LOW);
        assert(user_mana >= *self.mana_cost, errors::NOT_ENOUGH_MANA);
        assert(self.is_valid_ability_type(), errors::INVALID_ABILITY_TYPE);
    }

    fn calculate_cooldown_end(self: @Ability, current_timestamp: u64) -> u64 {
        current_timestamp + ((*self.cooldown).into() * 1000) // Convert seconds to milliseconds
    }

    fn can_use_ability(
        self: @Ability, user_level: u8, user_mana: u8, current_timestamp: u64, cooldown_until: u64,
    ) -> bool {
        *self.power > 0
            && user_level >= *self.level_required
            && user_mana >= *self.mana_cost
            && current_timestamp >= cooldown_until
            && self.is_valid_ability_type()
    }

    fn get_effect_type(self: @Ability) -> AbilityEffectType {
        let ability_type = self.get_ability_type();
        ability_type.get_effect_type()
    }

    fn calculate_effect_amount(self: @Ability, effect_type: AbilityEffectType) -> u32 {
        let base_power: u32 = (*self.power).try_into().unwrap_or(0);

        match effect_type {
            AbilityEffectType::Damage => base_power,
            AbilityEffectType::Heal => base_power,
            AbilityEffectType::Shield => base_power,
            AbilityEffectType::DamageOverTime => base_power / 4, // DoT is weaker per tick
            AbilityEffectType::ManaRestore => {
                // Mana restoration should be limited to u8 range
                if base_power > 255 {
                    255
                } else {
                    base_power
                }
            },
        }
    }

    fn validate_usage_requirements(
        self: @Ability,
        caster: ContractAddress,
        target: ContractAddress,
        player_level: u8,
        player_mana: u8,
        current_timestamp: u64,
        cooldown_until: u64,
        is_player_alive: bool,
        is_ability_equipped: bool,
        is_target_valid: bool,
    ) {
        // Validate player is alive
        assert(is_player_alive, errors::PLAYER_NOT_ALIVE);

        // Validate ability exists (not zero)
        assert(self.is_non_zero(), errors::ABILITY_NOT_FOUND);

        // Validate ability type is valid
        assert(self.is_valid_ability_type(), errors::INVALID_ABILITY_TYPE);

        // Validate player has ability equipped
        assert(is_ability_equipped, errors::ABILITY_NOT_EQUIPPED);

        // Check level requirements
        assert(player_level >= *self.level_required, errors::INSUFFICIENT_LEVEL);

        // Check mana requirements
        assert(player_mana >= *self.mana_cost, errors::INSUFFICIENT_MANA);

        // Check cooldown
        assert(current_timestamp >= cooldown_until, errors::ABILITY_ON_COOLDOWN);

        // Validate target
        assert(is_target_valid, errors::INVALID_TARGET);
    }

    fn process_usage(
        self: @Ability,
        context: AbilityUsageContext,
        player_level: u8,
        player_mana: u8,
        cooldown_until: u64,
        is_player_alive: bool,
        is_ability_equipped: bool,
        is_target_valid: bool,
    ) -> AbilityUsageResult {
        // Validate all requirements
        self
            .validate_usage_requirements(
                context.caster,
                context.target,
                player_level,
                player_mana,
                context.current_timestamp,
                cooldown_until,
                is_player_alive,
                is_ability_equipped,
                is_target_valid,
            );

        // Determine effect type and amount
        let effect_type = self.get_effect_type();
        let effect_amount = self.calculate_effect_amount(effect_type);

        // Calculate new cooldown
        let new_cooldown_until = self.calculate_cooldown_end(context.current_timestamp);

        AbilityUsageResult {
            effect_type,
            effect_amount,
            mana_consumed: *self.mana_cost,
            cooldown_until: new_cooldown_until,
        }
    }

    fn is_damage_ability(self: @Ability) -> bool {
        let ability_type = self.get_ability_type();
        ability_type.is_damage_type()
    }

    fn is_healing_ability(self: @Ability) -> bool {
        let ability_type = self.get_ability_type();
        ability_type.is_healing_type()
    }

    fn is_support_ability(self: @Ability) -> bool {
        let ability_type = self.get_ability_type();
        ability_type.is_support_type()
    }

    fn get_display_info(self: @Ability) -> (felt252, u256, u8, u8, u8) {
        (*self.name, *self.power, *self.cooldown, *self.mana_cost, *self.level_required)
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
    use super::{Ability, AbilityTrait, AbilityType, AbilityTypeTrait, ZeroableAbilityTrait};
    use super::{AbilityEffectType, AbilityUsageContext, AbilityUsageResult};
    use starknet::{ContractAddress, contract_address_const};

    fn sample_ability() -> Ability {
        AbilityTrait::new(1_u256, AbilityType::Fireball, 100_u256, 5, 20, 3)
    }

    #[test]
    fn test_is_usable_true() {
        let ability = sample_ability();
        assert(ability.is_usable(5, 25), 'Ability should be usable');
    }

    #[test]
    fn test_is_usable_false_level() {
        let ability = sample_ability();
        assert(!ability.is_usable(2, 25), 'Level too low');
    }

    #[test]
    fn test_is_usable_false_mana() {
        let ability = sample_ability();
        assert(!ability.is_usable(5, 10), 'Not enough mana');
    }

    #[test]
    fn test_validate_success() {
        let ability = sample_ability();
        ability.validate(5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Power must be > 0',))]
    fn test_invalid_power() {
        let mut ability = sample_ability();
        ability.power = 0_u256;
        ability.validate(5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Cooldown too high',))]
    fn test_invalid_cooldown() {
        let mut ability = sample_ability();
        ability.cooldown = 12;
        ability.validate(5, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Level too low',))]
    fn test_invalid_level() {
        let ability = sample_ability();
        ability.validate(2, 25);
    }

    #[test]
    #[should_panic(expected: ('Ability: Not enough mana',))]
    fn test_invalid_mana() {
        let ability = sample_ability();
        ability.validate(5, 10);
    }

    #[test]
    fn test_zero_ability() {
        let ability = ZeroableAbilityTrait::zero();
        assert(ability.is_zero(), 'Zero ability should be zero');
    }

    #[test]
    fn test_ability_type_conversions() {
        let fireball_felt: felt252 = AbilityType::Fireball.into();
        assert(fireball_felt == 'Fireball', 'Conversion to felt252 failed');

        let converted_back: AbilityType = fireball_felt.try_into().unwrap();

        assert(converted_back == AbilityType::Fireball, 'Round trip failed');
    }

    #[test]
    fn test_ability_creation_with_enum() {
        let ability = sample_ability();
        assert(ability.is_valid_ability_type(), 'Should be valid');

        assert(ability.get_ability_type() == AbilityType::Fireball, 'Should be Fireball');
    }

    #[test]
    fn test_effect_type_detection_with_enum() {
        let fireball = AbilityTrait::new(1_u256, AbilityType::Fireball, 100_u256, 5, 20, 3);
        let heal = AbilityTrait::new(2_u256, AbilityType::Heal, 50_u256, 3, 15, 2);
        let shield = AbilityTrait::new(3_u256, AbilityType::Shield, 75_u256, 4, 25, 3);
        let regen = AbilityTrait::new(4_u256, AbilityType::Regenerate, 30_u256, 2, 10, 1);

        assert(
            fireball.get_effect_type() == AbilityEffectType::Damage, 'Fireball should be damage',
        );
        assert(heal.get_effect_type() == AbilityEffectType::Heal, 'Heal should be heal');
        assert(shield.get_effect_type() == AbilityEffectType::Shield, 'Shield should be shield');
        assert(
            regen.get_effect_type() == AbilityEffectType::ManaRestore,
            'Regen should be mana restore',
        );
    }

    #[test]
    fn test_ability_type_helpers() {
        assert!(AbilityType::Fireball.is_damage_type(), "Fireball should be damage type");
        assert!(!AbilityType::Fireball.is_healing_type(), "Fireball should not be healing type");
        assert!(!AbilityType::Fireball.is_support_type(), "Fireball should not be support type");

        assert!(!AbilityType::Heal.is_damage_type(), "Heal should not be damage type");
        assert!(AbilityType::Heal.is_healing_type(), "Heal should be healing type");
        assert!(!AbilityType::Heal.is_support_type(), "Heal should not be support type");

        assert!(!AbilityType::Shield.is_damage_type(), "Shield should not be damage type");
        assert!(!AbilityType::Shield.is_healing_type(), "Shield should not be healing type");
        assert!(AbilityType::Shield.is_support_type(), "Shield should be support type");
    }

    #[test]
    fn test_new_ability_types() {
        let ice_spear = AbilityTrait::new(5_u256, AbilityType::IceSpear, 80_u256, 4, 18, 2);
        let poison = AbilityTrait::new(6_u256, AbilityType::Poison, 40_u256, 6, 22, 3);

        assert(
            ice_spear.get_effect_type() == AbilityEffectType::Damage, 'IceSpear should be damage',
        );
        assert(
            poison.get_effect_type() == AbilityEffectType::DamageOverTime, 'Poison should be DoT',
        );
    }

    #[test]
    fn test_effect_amount_calculation_with_special_types() {
        let poison = AbilityTrait::new(1_u256, AbilityType::Poison, 100_u256, 6, 22, 3);

        let poison_amount = poison.calculate_effect_amount(AbilityEffectType::DamageOverTime);

        assert(poison_amount == 25, 'Poison should be power/4'); // 100/4 = 25
    }

    #[test]
    fn test_basic_validation() {
        let ability = sample_ability();
        assert(ability.is_usable(5, 25), 'Should be usable');
        assert(!ability.is_usable(2, 25), 'Level too low');
        assert(!ability.is_usable(5, 10), 'Mana too low');
    }

    #[test]
    fn test_complete_ability_processing() {
        let ability = sample_ability();
        let context = AbilityUsageContext {
            ability_id: 1_u256,
            caster: contract_address_const::<0x123>(),
            target: contract_address_const::<0x456>(),
            current_timestamp: 2000_u64,
        };

        let result = ability
            .process_usage(
                context,
                5, // player level
                25, // player mana
                1000, // cooldown until (in the past)
                true, // is player alive
                true, // is ability equipped
                true // is target valid
            );

        assert(result.effect_type == AbilityEffectType::Damage, 'Should be damage effect');
        assert(result.effect_amount == 100, 'Should deal 100 damage');
        assert(result.mana_consumed == 20, 'Should consume 20 mana');
        assert(result.cooldown_until == 7000, 'Should set cooldown to 7000'); // 2000 + (5 * 1000)
    }
}
