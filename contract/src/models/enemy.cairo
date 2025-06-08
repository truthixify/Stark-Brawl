use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Enemy {
    #[key]
    pub id: u64,
    pub enemy_type: felt252, // "orc", "goblin", "boss"
    pub health: u32,
    pub speed: u32,
    pub x: u32,
    pub y: u32,
    pub is_alive: bool,
}

mod errors {
    pub const Overkill: felt252 = 'Overkill';
    pub const ReviveError: felt252 = 'ReviveError';
    pub const InvalidMove: felt252 = 'InvalidMove';
}

#[generate_trait]
pub trait EnemySystem {
    fn new(id: u64, enemy_type: felt252, health: u32, speed: u32, x: u32, y: u32) -> Enemy;
    fn take_damage(self: @Enemy, amount: u32) -> Enemy;
    fn move_to(self: @Enemy, x: u32, y: u32) -> Enemy;
}

impl EnemyImpl of EnemySystem {
    fn new(id: u64, enemy_type: felt252, health: u32, speed: u32, x: u32, y: u32) -> Enemy {
        Enemy {
            id,
            enemy_type,
            health,
            speed,
            x,
            y,
            is_alive: true,
        }
    }

    fn take_damage(self: @Enemy, amount: u32) -> Enemy {
        if *self.is_alive == false {
            panic(array![errors::Overkill]);
        }

        let current_health = *self.health;
        let new_health = if amount >= current_health { 0 } else { current_health - amount };
        let new_is_alive = new_health != 0;

        Enemy {
            id: *self.id,
            enemy_type: *self.enemy_type,
            health: new_health,
            speed: *self.speed,
            x: *self.x,
            y: *self.y,
            is_alive: new_is_alive,
        }
    }

    fn move_to(self: @Enemy, x: u32, y: u32) -> Enemy {
        if *self.is_alive == false {
            panic(array![errors::InvalidMove]);
        }

        Enemy {
            id: *self.id,
            enemy_type: *self.enemy_type,
            health: *self.health,
            speed: *self.speed,
            x,
            y,
            is_alive: *self.is_alive,
        }
    }
}

pub impl ZeroableEnemy of Zero<Enemy> {
    fn zero() -> Enemy {
        Enemy {
            id: 0_u64,
            enemy_type: '0',
            health: 0,
            speed: 0,
            x: 0,
            y: 0,
            is_alive: false,
        }
    }

    fn is_zero(self: @Enemy) -> bool {
        *self.id == 0_u64
    }

    fn is_non_zero(self: @Enemy) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_enemy() -> Enemy {
        EnemyImpl::new(1_u64, 'orc', 100_u32, 5_u32, 10_u32, 20_u32)
    }

    #[test]
    fn test_instantiation() {
        let e = sample_enemy();
        assert(e.health == 100_u32, 'Incorrect health');
        assert(e.is_alive == true, 'Should be alive');
        assert(e.enemy_type == 'orc', 'Incorrect type');
    }

    #[test]
    fn test_take_damage_kills() {
        let e = sample_enemy();
        let e2 = EnemyImpl::take_damage(@e, 100_u32);
        assert(e2.health == 0_u32, 'Health should be 0');
        assert(e2.is_alive == false, 'Enemy should be dead');
    }

    #[test]
    #[should_panic]
    fn test_take_damage_on_dead_enemy_panics() {
        let e = sample_enemy();
        let dead = EnemyImpl::take_damage(@e, 100_u32);
        let _ = EnemyImpl::take_damage(@dead, 10_u32);
    }

    #[test]
    fn test_move_alive_enemy() {
        let e = sample_enemy();
        let e2 = EnemyImpl::move_to(@e, 30_u32, 40_u32);
        assert(e2.x == 30_u32, 'Incorrect x');
        assert(e2.y == 40_u32, 'Incorrect y');
    }

    #[test]
    #[should_panic]
    fn test_move_dead_enemy_panics() {
        let e = sample_enemy();
        let dead = EnemyImpl::take_damage(@e, 200_u32);
        let _ = EnemyImpl::move_to(@dead, 50_u32, 60_u32);
    }
}
