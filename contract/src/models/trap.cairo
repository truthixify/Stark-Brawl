use starknet::{ContractAddress, contract_address_const};
use core::num::traits::zero::Zero;

// Vec2 structure for positioning
#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32,
}

pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()
}

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
pub enum TrapType {
    Explosive,
    Poison,
    Electric,
    Freezing,
}

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
pub struct Trap {
    #[key]
    pub trap_id: u32,
    pub owner: ContractAddress,
    pub position: Vec2,
    pub trigger_radius: u32,
    pub damage: u16,
    pub trap_type: TrapType,
    pub is_active: bool,
}

#[generate_trait]
pub impl TrapImpl of TrapTrait {
    fn check_trigger(self: @Trap, enemy_pos: Vec2) -> bool {
        if !*self.is_active {
            return false;
        }

        let trap_pos = *self.position;
        let dx = if enemy_pos.x >= trap_pos.x {
            enemy_pos.x - trap_pos.x
        } else {
            trap_pos.x - enemy_pos.x
        };

        let dy = if enemy_pos.y >= trap_pos.y {
            enemy_pos.y - trap_pos.y
        } else {
            trap_pos.y - enemy_pos.y
        };

        // Calculate distance using Manhattan distance for simplicity
        let distance = dx + dy;
        distance <= *self.trigger_radius
    }

    fn trigger(ref self: Trap) -> u16 {
        if !self.is_active {
            return 0;
        }

        self.is_active = false; // Trap is consumed after triggering
        self.damage
    }

    fn deactivate(ref self: Trap) {
        self.is_active = false;
    }

    fn activate(ref self: Trap) {
        self.is_active = true;
    }
}

#[generate_trait]
pub impl TrapAssert of AssertTrait {
    #[inline(always)]
    fn assert_exists(self: Trap) {
        assert(self.is_non_zero(), 'Trap: Does not exist');
    }

    #[inline(always)]
    fn assert_not_exists(self: Trap) {
        assert(self.is_zero(), 'Trap: Already exists');
    }

    #[inline(always)]
    fn assert_active(self: Trap) {
        assert(self.is_active, 'Trap: Not active');
    }

    #[inline(always)]
    fn assert_owned_by(self: Trap, owner: ContractAddress) {
        assert(self.owner == owner, 'Trap: Not owned by caller');
    }
}

pub impl ZeroableTrapTrait of Zero<Trap> {
    #[inline(always)]
    fn zero() -> Trap {
        Trap {
            trap_id: 0,
            owner: ZERO_ADDRESS(),
            position: Vec2 { x: 0, y: 0 },
            trigger_radius: 0,
            damage: 0,
            trap_type: TrapType::Explosive,
            is_active: false,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Trap) -> bool {
        *self.owner == ZERO_ADDRESS() && *self.trap_id == 0
    }

    #[inline(always)]
    fn is_non_zero(self: @Trap) -> bool {
        !self.is_zero()
    }
}

pub fn create_trap(
    trap_id: u32,
    owner: ContractAddress,
    x: u32,
    y: u32,
    trigger_radius: u32,
    damage: u16,
    trap_type: TrapType,
) -> Trap {
    Trap {
        trap_id, owner, position: Vec2 { x, y }, trigger_radius, damage, trap_type, is_active: true,
    }
}

impl TrapTypeIntoFelt252 of Into<TrapType, felt252> {
    fn into(self: TrapType) -> felt252 {
        match self {
            TrapType::Explosive => 1,
            TrapType::Poison => 2,
            TrapType::Electric => 3,
            TrapType::Freezing => 4,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{TrapTrait, TrapType, Vec2, create_trap, ZeroableTrapTrait};
    use starknet::{ContractAddress, contract_address_const};

    #[test]
    fn test_trap_creation() {
        let owner: ContractAddress = contract_address_const::<0x123>();

        let trap = create_trap(1, owner, 10_u32, 15_u32, 3_u32, 50_u16, TrapType::Explosive);

        assert(trap.trap_id == 1, 'Invalid trap id');
        assert(trap.owner == owner, 'Invalid owner');
        assert(trap.position.x == 10_u32, 'Invalid x position');
        assert(trap.position.y == 15_u32, 'Invalid y position');
        assert(trap.trigger_radius == 3, 'Invalid trigger radius');
        assert(trap.damage == 50, 'Invalid damage');
        assert(trap.trap_type == TrapType::Explosive, 'Invalid trap type');
        assert(trap.is_active, 'Trap should be active');
    }

    #[test]
    fn test_check_trigger_within_radius() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let trap = create_trap(1, owner, 10_u32, 10_u32, 3_u32, 50_u16, TrapType::Explosive);

        // Enemy at position (12, 11) - distance = 3, within radius
        let enemy_pos = Vec2 { x: 12_u32, y: 11_u32 };
        assert(trap.check_trigger(enemy_pos), 'Should trigger within radius');
    }

    #[test]
    fn test_check_trigger_outside_radius() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let trap = create_trap(1, owner, 10_u32, 10_u32, 3_u32, 50_u16, TrapType::Explosive);

        // Enemy at position (15, 15) - distance = 10, outside radius
        let enemy_pos = Vec2 { x: 15_u32, y: 15_u32 };
        assert(!trap.check_trigger(enemy_pos), 'Should not trigger outside');
    }

    #[test]
    fn test_check_trigger_exact_radius() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let trap = create_trap(1, owner, 10_u32, 10_u32, 3_u32, 50_u16, TrapType::Explosive);

        // Enemy at position (13, 10) - distance = 3, exactly at radius
        let enemy_pos = Vec2 { x: 13_u32, y: 10_u32 };
        assert(trap.check_trigger(enemy_pos), 'Should trigger at exact radius');
    }

    #[test]
    fn test_trigger_damage() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let mut trap = create_trap(1, owner, 10_u32, 10_u32, 3_u32, 50_u16, TrapType::Explosive);

        let damage_dealt = trap.trigger();
        assert(damage_dealt == 50, 'Should deal correct damage');
        assert(!trap.is_active, 'Trap should be inactive');
    }

    #[test]
    fn test_trigger_inactive_trap() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let mut trap = create_trap(1, owner, 10_u32, 10_u32, 3_u32, 50_u16, TrapType::Explosive);
        trap.deactivate();

        let damage_dealt = trap.trigger();
        assert(damage_dealt == 0, 'No damage from inactive trap');
    }

    #[test]
    fn test_trap_activation_deactivation() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let mut trap = create_trap(1, owner, 5_u32, 5_u32, 2_u32, 30_u16, TrapType::Poison);

        // Test deactivation
        trap.deactivate();
        assert(!trap.is_active, 'Trap should be inactive');

        let enemy_pos = Vec2 { x: 5_u32, y: 5_u32 };
        assert(!trap.check_trigger(enemy_pos), 'Inactive trap no trigger');

        // Test reactivation
        trap.activate();
        assert(trap.is_active, 'Trap should be active again');
        assert(trap.check_trigger(enemy_pos), 'Reactivated trap should trigger');
    }

    #[test]
    fn test_different_trap_types() {
        let owner: ContractAddress = contract_address_const::<0x123>();

        let explosive_trap = create_trap(
            1, owner, 0_u32, 0_u32, 3_u32, 80_u16, TrapType::Explosive,
        );
        let poison_trap = create_trap(2, owner, 10_u32, 10_u32, 2_u32, 20_u16, TrapType::Poison);
        let electric_trap = create_trap(
            3, owner, 20_u32, 20_u32, 4_u32, 45_u16, TrapType::Electric,
        );
        let freezing_trap = create_trap(
            4, owner, 30_u32, 30_u32, 1_u32, 15_u16, TrapType::Freezing,
        );

        assert(explosive_trap.damage == 80, 'Explosive damage incorrect');
        assert(poison_trap.damage == 20, 'Poison damage incorrect');
        assert(electric_trap.damage == 45, 'Electric damage incorrect');
        assert(freezing_trap.damage == 15, 'Freezing damage incorrect');
    }

    #[test]
    fn test_trap_consumption() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let mut trap = create_trap(1, owner, 0_u32, 0_u32, 5_u32, 40_u16, TrapType::Electric);

        let enemy1_pos = Vec2 { x: 2_u32, y: 3_u32 }; // Distance = 5, at edge

        // First enemy triggers trap
        assert(trap.check_trigger(enemy1_pos), 'First enemy should trigger');
        let damage1 = trap.trigger();
        assert(damage1 == 40, 'Should deal 40 damage');
        assert(!trap.is_active, 'Trap should be consumed');

        // Second enemy should not trigger consumed trap
        let enemy2_pos = Vec2 { x: 1_u32, y: 1_u32 }; // Distance = 2, well within radius
        assert(!trap.check_trigger(enemy2_pos), 'No trigger on consumed trap');
        let damage2 = trap.trigger();
        assert(damage2 == 0, 'No damage from consumed trap');
    }

    #[test]
    fn test_distance_calculations() {
        let owner: ContractAddress = contract_address_const::<0x123>();
        let trap = create_trap(1, owner, 10_u32, 10_u32, 5_u32, 25_u16, TrapType::Freezing);

        // Test various distance calculations
        let pos1 = Vec2 { x: 15_u32, y: 10_u32 }; // Distance = 5 (exact edge)
        let pos2 = Vec2 { x: 12_u32, y: 13_u32 }; // Distance = 5 (exact edge)
        let pos3 = Vec2 { x: 16_u32, y: 11_u32 }; // Distance = 7 (outside)
        let pos4 = Vec2 { x: 8_u32, y: 7_u32 }; // Distance = 5 (exact edge)

        assert(trap.check_trigger(pos1), 'Should trigger at distance 5');
        assert(trap.check_trigger(pos2), 'Should trigger at distance 5');
        assert(!trap.check_trigger(pos3), 'No trigger at distance 7');
        assert(trap.check_trigger(pos4), 'Should trigger at distance 5');
    }
}
