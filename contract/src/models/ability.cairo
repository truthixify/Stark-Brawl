#[derive(Copy, Drop, Serde, Debug, PartialEq)]
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

pub trait AbilityTrait<T, +Serde<T>, +Drop<T>> {
    fn is_usable(self: @T, user_level: u8, user_mana: u8) -> bool;
    fn validate(self: @T, user_level: u8, user_mana: u8);
}

impl AbilityImpl of AbilityTrait<Ability> {
    fn is_usable(self: @Ability, user_level: u8, user_mana: u8) -> bool {
        user_level >= *self.level_required && user_mana >= *self.mana_cost
    }
    
    fn validate(self: @Ability, user_level: u8, user_mana: u8) {
        assert(*self.power > 0_u256, 'INVALID_ABILITY_POWER');
        assert(*self.cooldown < 10_u8, 'INVALID_ABILITY_COOLDOWN');
        assert(user_level >= *self.level_required, 'LEVEL_TOO_LOW');
        assert(user_mana >= *self.mana_cost, 'NOT_ENOUGH_MANA');
    }
}
