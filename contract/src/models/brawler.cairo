use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
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

#[generate_trait]
pub trait BrawlerSystem {
    fn instantiate_character_from_brawler(self: @Brawler) -> CharacterInstance;
    fn is_zero(self: @Brawler) -> bool;
    fn is_non_zero(self: @Brawler) -> bool;
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

    #[inline(always)]
    fn is_zero(self: @Brawler) -> bool {
        *self.id == 0_u64
    }

    #[inline(always)]
    fn is_non_zero(self: @Brawler) -> bool {
        !Self::is_zero(self)
    }
}

pub impl ZeroableBrawler of Zero<Brawler> {
    #[inline(always)]
    fn zero() -> Brawler {
        Brawler { id: 0_u64, name: '0', base_health: 0, base_attack: 0, ability_id: 0_u256 }
    }

    #[inline(always)]
    fn is_zero(self: @Brawler) -> bool {
        *self.id == 0_u64
    }

    #[inline(always)]
    fn is_non_zero(self: @Brawler) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_brawler() -> Brawler {
        Brawler {
            id: 1_u64,
            name: 'Test',
            base_health: 1000_u32,
            base_attack: 150_u32,
            ability_id: 9_u256,
        }
    }

    #[test]
    fn test_instantiation() {
        let brawler = sample_brawler();
        let character = BrawlerImpl::instantiate_character_from_brawler(@brawler);
        assert(character.brawler_id == 1_u64, 'Wrong brawler_id');
        assert(character.health == 1000_u32, 'Wrong health');
        assert(character.attack == 150_u32, 'Wrong attack');
        assert(character.ability_id == 9_u256, 'Wrong ability_id');
    }

    #[test]
    fn test_zero_brawler() {
        let brawler = ZeroableBrawler::zero();
        assert(BrawlerImpl::is_zero(@brawler), 'Should be zero');
        assert(!BrawlerImpl::is_non_zero(@brawler), 'Should not be non-zero');
    }

    #[test]
    fn test_non_zero_brawler() {
        let brawler = sample_brawler();
        assert(!BrawlerImpl::is_zero(@brawler), 'Should not be zero');
        assert(BrawlerImpl::is_non_zero(@brawler), 'Should be non-zero');
    }
}
