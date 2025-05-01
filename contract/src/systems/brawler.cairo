pub trait BrawlerSystem {
    fn instantiate_character_from_brawler(self: @Brawler) -> CharacterInstance;
}

impl BrawlerImpl of BrawlerSystem {
    fn instantiate_character_from_brawler(self: @Brawler) -> CharacterInstance {
        CharacterInstance {
            brawler_id: *self.id,
            health: *self.base_health,
            attack: *self.base_attack,
            ability_id: *self.ability_id,
        }
    }
}