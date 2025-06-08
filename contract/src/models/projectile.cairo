use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Projectile {
    #[key]
    pub id: u64,
    pub tower_id: u64,
    pub target_enemy_id: u64,
    pub damage: u32,
    pub speed: u32,
    pub x: u32,
    pub y: u32,
    pub target_x: u32,
    pub target_y: u32,
}

mod errors {
    pub const InvalidTarget: felt252 = 'InvalidTarget';
}

#[generate_trait]
pub trait ProjectileSystem {
    fn new(id: u64, tower_id: u64, target_enemy_id: u64, damage: u32, speed: u32, x: u32, y: u32, target_x: u32, target_y: u32) -> Projectile;
    fn has_reached_target(self: @Projectile) -> bool;
}

impl ProjectileImpl of ProjectileSystem {
    fn new(id: u64, tower_id: u64, target_enemy_id: u64, damage: u32, speed: u32, x: u32, y: u32, target_x: u32, target_y: u32) -> Projectile {
        if target_enemy_id == 0_u64 {
            panic(array![errors::InvalidTarget]);
        }

        Projectile {
            id,
            tower_id,
            target_enemy_id,
            damage,
            speed,
            x,
            y,
            target_x,
            target_y,
        }
    }

    fn has_reached_target(self: @Projectile) -> bool {
        *self.x == *self.target_x && *self.y == *self.target_y
    }
}

pub impl ZeroableProjectile of Zero<Projectile> {
    fn zero() -> Projectile {
        Projectile {
            id: 0_u64,
            tower_id: 0_u64,
            target_enemy_id: 0_u64,
            damage: 0_u32,
            speed: 0_u32,
            x: 0_u32,
            y: 0_u32,
            target_x: 0_u32,
            target_y: 0_u32,
        }
    }

    fn is_zero(self: @Projectile) -> bool {
        *self.id == 0_u64
    }

    fn is_non_zero(self: @Projectile) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_projectile() -> Projectile {
        ProjectileImpl::new(
            1_u64, 10_u64, 50_u64, 25_u32, 3_u32,
            0_u32, 0_u32,
            5_u32, 5_u32
        )
    }

    #[test]
    fn test_creation() {
        let p = sample_projectile();
        assert(p.id == 1_u64, 'Wrong id');
        assert(p.tower_id == 10_u64, 'Wrong tower_id');
        assert(p.target_enemy_id == 50_u64, 'Wrong enemy');
        assert(p.damage == 25_u32, 'Wrong damage');
        assert(p.x == 0_u32 && p.y == 0_u32, 'Wrong initial position');
    }

    #[test]
    fn test_reach_target_false() {
        let p = sample_projectile();
        assert(ProjectileImpl::has_reached_target(@p) == false, 'Should not have reached yet');
    }

    #[test]
    fn test_reach_target_true() {
        let p = Projectile { x: 5_u32, y: 5_u32, ..sample_projectile() };
        assert(ProjectileImpl::has_reached_target(@p) == true, 'Should have reached target');
    }

    #[test]
    #[should_panic]
    fn test_invalid_target_panics() {
        let _ = ProjectileImpl::new(
            1_u64, 10_u64, 0_u64, 20_u32, 3_u32,
            0_u32, 0_u32,
            5_u32, 5_u32
        );
    }
}
