use core::num::traits::zero::Zero;
use starknet::ContractAddress;
use starknet::contract_address_const;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Tower {
    #[key]
    pub id: u64,
    pub owner: ContractAddress,
    pub tower_type: felt252, // "cannon", "ice", etc.
    pub level: u8,
    pub x: u32,
    pub y: u32,
    pub last_attack_tick: u64,
}

mod errors {
    pub const Unauthorized: felt252 = 'Unauthorized';
    pub const MaxLevelReached: felt252 = 'MaxLevelReached';
}

#[generate_trait]
pub trait TowerSystem {
    fn new(id: u64, owner: ContractAddress, tower_type: felt252, x: u32, y: u32) -> Tower;
    fn upgrade(self: @Tower) -> Tower;
    fn can_attack(self: @Tower, current_tick: u64, cooldown: u64) -> bool;
}

pub impl TowerImpl of TowerSystem {
    fn new(id: u64, owner: ContractAddress, tower_type: felt252, x: u32, y: u32) -> Tower {
        Tower { id, owner, tower_type, level: 1_u8, x, y, last_attack_tick: 0_u64 }
    }

    fn upgrade(self: @Tower) -> Tower {
        if *self.level >= 5_u8 {
            panic(array![errors::MaxLevelReached]);
        }

        Tower {
            id: *self.id,
            owner: *self.owner,
            tower_type: *self.tower_type,
            level: *self.level + 1_u8,
            x: *self.x,
            y: *self.y,
            last_attack_tick: *self.last_attack_tick,
        }
    }

    fn can_attack(self: @Tower, current_tick: u64, cooldown: u64) -> bool {
        current_tick - *self.last_attack_tick >= cooldown
    }
}

pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()
}

pub impl ZeroableTower of Zero<Tower> {
    fn zero() -> Tower {
        Tower {
            id: 0_u64,
            owner: ZERO_ADDRESS(),
            tower_type: '0',
            level: 0_u8,
            x: 0_u32,
            y: 0_u32,
            last_attack_tick: 0_u64,
        }
    }

    fn is_zero(self: @Tower) -> bool {
        *self.id == 0_u64
    }

    fn is_non_zero(self: @Tower) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::contract_address_const;

    fn dummy_owner() -> ContractAddress {
        contract_address_const::<0x123>()
    }

    fn sample_tower() -> Tower {
        TowerImpl::new(1_u64, dummy_owner(), 'cannon', 5_u32, 5_u32)
    }

    #[test]
    fn test_creation() {
        let t = sample_tower();
        assert(t.level == 1_u8, 'Initial level must be 1');
        assert(t.last_attack_tick == 0_u64, 'Initial tick must be 0');
    }

    #[test]
    fn test_upgrade() {
        let t = sample_tower();
        let upgraded = TowerImpl::upgrade(@t);
        assert(upgraded.level == 2_u8, 'Level should be 2 after upgrade');
    }

    #[test]
    #[should_panic]
    fn test_upgrade_past_limit() {
        let t = sample_tower();
        let t2 = TowerImpl::upgrade(@t);
        let t3 = TowerImpl::upgrade(@t2);
        let t4 = TowerImpl::upgrade(@t3);
        let t5 = TowerImpl::upgrade(@t4);
        let _ = TowerImpl::upgrade(@t5); // level 6 → should panic
    }

    #[test]
    fn test_can_attack_true() {
        let t = sample_tower();
        let ready = TowerImpl::can_attack(@t, 20_u64, 10_u64);
        assert(ready == true, 'Should be ready to attack');
    }

    #[test]
    fn test_can_attack_false() {
        let t = Tower { last_attack_tick: 18_u64, ..sample_tower() };
        let ready = TowerImpl::can_attack(@t, 20_u64, 5_u64);
        assert(ready == false, 'Should not be ready');
    }
}
