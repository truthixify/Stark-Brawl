use core::num::traits::zero::Zero;

// ========== MODEL ==========

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Character {
    #[key]
    pub id: u256,
    pub name: felt252,
    pub health: u256,
    pub attack: u256,
    pub owner: felt252,
}

// ========== TRAIT ==========

#[generate_trait]
pub impl CharacterImpl of CharacterTrait {
    #[inline(always)]
    fn receive_damage(ref self: Character, amount: u256) {
        let current = self.health;
        assert(current != 0_u256, 'Character dead');

        let new_health = if amount > current {
            0_u256
        } else {
            current - amount
        };

        self.health = new_health;
    }

    #[inline(always)]
    fn attack_target(ref self: Character, attacker: Character) {
        assert(attacker.health != 0_u256, 'Dead attacker');
        Self::receive_damage(ref self, attacker.attack);
    }

    #[inline(always)]
    fn is_alive(self: @Character) -> bool {
        *self.health != 0_u256
    }

    #[inline(always)]
    fn is_zero(self: @Character) -> bool {
        *self.id == 0_u256
    }

    #[inline(always)]
    fn is_non_zero(self: @Character) -> bool {
        !Self::is_zero(self)
    }
}

// ========== ZEROABLE ==========

pub impl ZeroableCharacter of Zero<Character> {
    #[inline(always)]
    fn zero() -> Character {
        Character { id: 0_u256, name: '0', health: 0_u256, attack: 0_u256, owner: '0' }
    }

    #[inline(always)]
    fn is_zero(self: @Character) -> bool {
        *self.id == 0_u256
    }

    #[inline(always)]
    fn is_non_zero(self: @Character) -> bool {
        !Self::is_zero(self)
    }
}

// ========== TESTS ==========

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_char() -> Character {
        Character { id: 1_u256, name: 'Knight', health: 100_u256, attack: 25_u256, owner: 'Alice' }
    }

    fn attacker_char() -> Character {
        Character { id: 2_u256, name: 'Orc', health: 80_u256, attack: 25_u256, owner: 'AI' }
    }

    #[test]
    fn test_receive_damage() {
        let mut c = sample_char();
        CharacterImpl::receive_damage(ref c, 30_u256);
        assert(c.health == 70_u256, 'Reduced');
    }

    #[test]
    fn test_kill_character() {
        let mut c = sample_char();
        CharacterImpl::receive_damage(ref c, 200_u256);
        assert(c.health == 0_u256, 'Killed');
    }

    #[test]
    fn test_attack_target() {
        let mut target = sample_char();
        let attacker = attacker_char();
        CharacterImpl::attack_target(ref target, attacker);
        assert(target.health == 75_u256, 'Attacked');
    }

    #[test]
    fn test_is_alive() {
        let c = sample_char();
        assert(CharacterImpl::is_alive(@c), 'Alive');
    }

    #[test]
    fn test_zero_check() {
        let zero = ZeroableCharacter::zero();
        assert(ZeroableCharacter::is_zero(@zero), 'Zero');
        assert(!ZeroableCharacter::is_non_zero(@zero), 'Not non-zero');

        let c = sample_char();
        assert(!CharacterImpl::is_zero(@c), 'Not zero');
        assert(CharacterImpl::is_non_zero(@c), 'Non-zero');
    }
}
