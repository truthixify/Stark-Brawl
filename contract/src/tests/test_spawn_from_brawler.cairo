use stark_brawl::models::brawler::{Brawler, BrawlerSystem};
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_brawler_instantiates_character_instance() {
        let brawler = Brawler {
            id: 1_u64,
            name: 'Crusher',
            base_health: 150_u32,
            base_attack: 40_u32,
            ability_id: 321_u256,
        };

        let character = brawler.instantiate_character_from_brawler();

        assert(character.brawler_id == 1_u64, 'Incorrect brawler ID');
        assert(character.health == 150_u32, 'Incorrect health');
        assert(character.attack == 40_u32, 'Incorrect attack');
        assert(character.ability_id == 321_u256, 'Incorrect ability ID');
    }
}