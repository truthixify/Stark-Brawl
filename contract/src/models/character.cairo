#[derive(Copy, Drop, Serde, Default, Debug,  PartialEq)]
pub struct Character {
    pub id: u256,
    pub name: felt252,
    pub health: u256,
    pub attack: u256,
    pub owner : felt252,
}

pub fn initialize_character(id: u256, name: felt252, health: u256, attack: u256 , owner : felt252) -> Character {
    Character { id, name, health, attack , owner }
}

pub impl CharacterImpl of CharacterTrait<Character> {
    fn receive_damage(ref self: Character, amount: u256) {
        let mut health = self.health;
        assert(self.health != 0, 'CHARACTER IS ALREADY DEAD');
        health = if amount > health {
            0
        } else {
            health - amount
        };

        self.health = health;
    }

    fn attack_target(ref self: Character, attacker: Character) {
        assert(attacker.health != 0, 'CANNOT_ATTACK_By_DEAD_CHARACTER');
        self.receive_damage(attacker.attack);
    }    

    fn is_alive(self: @Character) -> bool {
        *self.health != 0
    }
}

pub trait CharacterTrait<T> {
    fn receive_damage(ref self: T, amount: u256);
    fn is_alive(self: @T) -> bool;
    fn attack_target(ref self : T , attacker : Character);
}
