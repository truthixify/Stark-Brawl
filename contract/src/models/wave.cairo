use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Wave {
    #[key]
    pub id: u64,
    pub level: u32,
    pub enemy_count: u32,
    pub enemies_spawned: u32,
    pub tick_interval: u32,
    pub last_spawn_tick: u64,
    pub is_active: bool,
    pub is_completed: bool,
}

pub mod errors {
    pub const AlreadyActive: felt252 = 'Wave already active';
    pub const NotActive: felt252 = 'Wave not active';
    pub const AlreadyCompleted: felt252 = 'Wave already completed';
    pub const InvalidSpawnTick: felt252 = 'Invalid spawn tick';
    pub const InvalidEnemyCount: felt252 = 'Invalid enemy count';
}

#[generate_trait]
pub trait WaveSystem {
    fn new(id: u64, level: u32, enemy_count: u32, tick_interval: u32) -> Wave;
    fn start(self: @Wave, current_tick: u64) -> Wave;
    fn complete(self: @Wave) -> Wave;
    fn should_spawn(self: @Wave, current_tick: u64) -> bool;
    fn register_spawn(self: @Wave, current_tick: u64) -> Wave;
    fn is_wave_completed(self: @Wave) -> bool;
}

pub impl WaveImpl of WaveSystem {
    fn new(id: u64, level: u32, enemy_count: u32, tick_interval: u32) -> Wave {
        assert(enemy_count > 0, errors::InvalidEnemyCount);
        
        Wave {
            id,
            level,
            enemy_count,
            enemies_spawned: 0,
            tick_interval,
            last_spawn_tick: 0,
            is_active: false,
            is_completed: false,
        }
    }

    fn start(self: @Wave, current_tick: u64) -> Wave {
        assert(*self.is_active == false, errors::AlreadyActive);
        assert(*self.is_completed == false, errors::AlreadyCompleted);

        Wave {
            id: *self.id,
            level: *self.level,
            enemy_count: *self.enemy_count,
            enemies_spawned: *self.enemies_spawned,
            tick_interval: *self.tick_interval,
            last_spawn_tick: current_tick,
            is_active: true,
            is_completed: false,
        }
    }

    fn complete(self: @Wave) -> Wave {
        assert(*self.is_active == true, errors::NotActive);
        assert(*self.is_completed == false, errors::AlreadyCompleted);

        Wave {
            id: *self.id,
            level: *self.level,
            enemy_count: *self.enemy_count,
            enemies_spawned: *self.enemies_spawned,
            tick_interval: *self.tick_interval,
            last_spawn_tick: *self.last_spawn_tick,
            is_active: false,
            is_completed: true,
        }
    }

    fn should_spawn(self: @Wave, current_tick: u64) -> bool {
        if *self.is_active == false || *self.is_completed == true {
            return false;
        }

        if *self.enemies_spawned >= *self.enemy_count {
            return false;
        }

        // Check if enough ticks have passed since the last spawn
      current_tick >= *self.last_spawn_tick + (*self.tick_interval).into()
    }

    fn register_spawn(self: @Wave, current_tick: u64) -> Wave {
        assert(*self.is_active == true, errors::NotActive);
        assert(*self.is_completed == false, errors::AlreadyCompleted);
        assert(*self.enemies_spawned < *self.enemy_count, 'All enemies spawned');
        assert(current_tick >= *self.last_spawn_tick, errors::InvalidSpawnTick);

        let new_spawned = *self.enemies_spawned + 1;
        let is_wave_complete = new_spawned >= *self.enemy_count;

        Wave {
            id: *self.id,
            level: *self.level,
            enemy_count: *self.enemy_count,
            enemies_spawned: new_spawned,
            tick_interval: *self.tick_interval,
            last_spawn_tick: current_tick,
            is_active: !is_wave_complete,
            is_completed: is_wave_complete,
        }
    }

    fn is_wave_completed(self: @Wave) -> bool {
        *self.is_completed || (*self.enemies_spawned >= *self.enemy_count)
    }
}

pub impl ZeroableWave of Zero<Wave> {
    fn zero() -> Wave {
        Wave {
            id: 0_u64,
            level: 0,
            enemy_count: 0,
            enemies_spawned: 0,
            tick_interval: 0,
            last_spawn_tick: 0,
            is_active: false,
            is_completed: false,
        }
    }

    fn is_zero(self: @Wave) -> bool {
        *self.id == 0_u64
    }

    fn is_non_zero(self: @Wave) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_wave() -> Wave {
        WaveImpl::new(1_u64, 5_u32, 10_u32, 100_u32)
    }

    #[test]
    fn test_instantiation() {
        let wave = sample_wave();
        assert(wave.id == 1_u64, 'Incorrect id');
        assert(wave.level == 5_u32, 'Incorrect level');
        assert(wave.enemy_count == 10_u32, 'Incorrect enemy count');
        assert(wave.enemies_spawned == 0_u32, 'Should start with 0 spawned');
        assert(wave.tick_interval == 100_u32, 'Incorrect tick interval');
        assert(wave.is_active == false, 'Should not be active');
        assert(wave.is_completed == false, 'Should not be completed');
    }

    #[test]
    fn test_start_wave() {
        let wave = sample_wave();
        let active_wave = WaveImpl::start(@wave, 500_u64);
        
        assert(active_wave.is_active == true, 'Should be active');
        assert(active_wave.last_spawn_tick == 500_u64, 'Incorrect last spawn tick');
    }

    #[test]
    #[should_panic(expected: ('Wave already active',))]
    fn test_start_already_active_wave() {
        let wave = sample_wave();
        let active_wave = WaveImpl::start(@wave, 500_u64);
        let _ = WaveImpl::start(@active_wave, 600_u64);
    }

    #[test]
    fn test_should_spawn() {
        let wave = sample_wave();
        let active_wave = WaveImpl::start(@wave, 500_u64);
        
        // Not enough time has passed
        assert(WaveImpl::should_spawn(@active_wave, 550_u64) == false, 'Should not spawn yet');
        
        // Enough time has passed
        assert(WaveImpl::should_spawn(@active_wave, 600_u64) == true, 'Should spawn now');
    }

    #[test]
    fn test_register_spawn() {
        let wave = sample_wave();
        let active_wave = WaveImpl::start(@wave, 500_u64);
        let updated_wave = WaveImpl::register_spawn(@active_wave, 600_u64);
        
        assert(updated_wave.enemies_spawned == 1_u32, 'Should have 1 spawned');
        assert(updated_wave.last_spawn_tick == 600_u64, 'Should update last spawn tick');
    }

    #[test]
    fn test_complete_wave() {
        let wave = sample_wave();
        let active_wave = WaveImpl::start(@wave, 500_u64);
        let completed_wave = WaveImpl::complete(@active_wave);
        
        assert(completed_wave.is_active == false, 'Should not be active');
        assert(completed_wave.is_completed == true, 'Should be completed');
    }

    #[test]
    #[should_panic(expected: ('Wave not active',))]
    fn test_complete_inactive_wave() {
        let wave = sample_wave();
        let _ = WaveImpl::complete(@wave);
    }

    #[test]
    fn test_auto_complete_on_all_spawned() {
        let wave = WaveImpl::new(1_u64, 1_u32, 1_u32, 100_u32);
        let active_wave = WaveImpl::start(@wave, 500_u64);
        let final_wave = WaveImpl::register_spawn(@active_wave, 600_u64);
        
        assert(final_wave.is_active == false, 'Should not be active');
        assert(final_wave.is_completed == true, 'Should be completed');
    }

    #[test]
    #[should_panic(expected: ('Invalid enemy count',))]
    fn test_invalid_enemy_count() {
        let _ = WaveImpl::new(1_u64, 1_u32, 0_u32, 100_u32);
    }
}
