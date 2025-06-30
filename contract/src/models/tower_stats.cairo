#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct TowerStats {
    #[key]
    pub tower_type: felt252,
    #[key]
    pub level: u8,
    pub range: u8,
    pub fire_rate: u8,
    pub damage: u32,
}

#[generate_trait]
pub impl TowerStatsImpl of TowerStatsTrait {
    fn new(tower_type: felt252, level: u8, range: u8, fire_rate: u8, damage: u32) -> TowerStats {
        TowerStats { tower_type, level, range, fire_rate, damage }
    }
}
