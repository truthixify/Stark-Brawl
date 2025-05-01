#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Brawler {
    #[key]
    pub id: u64,
    pub name: felt252,
    pub base_health: u32,
    pub base_attack: u32,
    pub ability_id: u256,
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub struct CharacterInstance {
    pub brawler_id: u64,
    pub health: u32,
    pub attack: u32,
    pub ability_id: u256,
}