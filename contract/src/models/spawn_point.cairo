#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct SpawnPoint {
    #[key]
    pub spawn_id: u32,
    pub x: u32,
    pub y: u32,
    pub wave_id: u32,
    pub is_active: bool,
    pub delay: u32,
}

pub mod errors {
    pub const INVALID_POSITION: felt252 = 'SpawnPoint: Invalid position';
    pub const INACTIVE_SPAWN: felt252 = 'SpawnPoint: Spawn point';
}

#[generate_trait]
pub impl SpawnPointImpl of SpawnPointTrait {
    #[inline(always)]
    fn set_position(ref self: SpawnPoint, new_x: u32, new_y: u32) {
        self.x = new_x;
        self.y = new_y;
    }

    #[inline(always)]
    fn set_active(ref self: SpawnPoint, active: bool) {
        self.is_active = active;
    }

    #[inline(always)]
    fn set_delay(ref self: SpawnPoint, new_delay: u32) {
        self.delay = new_delay;
    }

    #[inline(always)]
    fn can_spawn(self: @SpawnPoint) -> bool {
        *self.is_active && *self.delay == 0_u32
    }

    #[inline(always)]
    fn get_position(self: @SpawnPoint) -> (u32, u32) {
        (*self.x, *self.y)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_spawn_point_creation() {
        let spawn = SpawnPoint {
            spawn_id: 1_u32, x: 100_u32, y: 200_u32, wave_id: 1_u32, is_active: true, delay: 0_u32,
        };

        assert(spawn.spawn_id == 1_u32, 'Wrong spawn id');
        assert(spawn.x == 100_u32, 'Wrong x position');
        assert(spawn.y == 200_u32, 'Wrong y position');
        assert(spawn.wave_id == 1_u32, 'Wrong wave id');
    }

    #[test]
    fn test_position_setting() {
        let mut spawn = SpawnPoint {
            spawn_id: 1_u32, x: 100_u32, y: 200_u32, wave_id: 1_u32, is_active: true, delay: 0_u32,
        };

        SpawnPointImpl::set_position(ref spawn, 150_u32, 250_u32);
        let (x, y) = SpawnPointImpl::get_position(@spawn);
        assert(x == 150_u32, 'Wrong x after update');
        assert(y == 250_u32, 'Wrong y after update');
    }

    #[test]
    fn test_spawn_conditions() {
        let mut spawn = SpawnPoint {
            spawn_id: 1_u32, x: 100_u32, y: 200_u32, wave_id: 1_u32, is_active: true, delay: 0_u32,
        };

        // Test active spawn point with no delay
        assert(SpawnPointImpl::can_spawn(@spawn), 'Should be able to spawn');

        // Test inactive spawn point
        SpawnPointImpl::set_active(ref spawn, false);
        assert(!SpawnPointImpl::can_spawn(@spawn), 'Should not spawn when inactive');

        // Test active spawn point with delay
        SpawnPointImpl::set_active(ref spawn, true);
        SpawnPointImpl::set_delay(ref spawn, 5_u32);
        assert(!SpawnPointImpl::can_spawn(@spawn), 'Should not spawn with delay');
    }
}
