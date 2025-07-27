use starknet::ContractAddress;
use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct WaveProgress {
    #[key]
    pub wave_id: u64,
    #[key]
    pub player_id: ContractAddress,
    pub total_enemies: u32,
    pub enemies_spawned: u32,
    pub enemies_remaining: u32,
    pub is_completed: bool,
}

mod errors {
    pub const InvalidEnemyCount: felt252 = 'Invalid enemy count';
    pub const AlreadyCompleted: felt252 = 'Wave already completed';
    pub const NoEnemiesRemaining: felt252 = 'No enemies remaining';
    pub const InvalidSpawnCount: felt252 = 'Invalid spawn count';
}

#[generate_trait]
pub trait WaveProgressSystem {
    fn new(wave_id: u64, player_id: ContractAddress, total_enemies: u32) -> WaveProgress;
    fn spawn_enemy(self: @WaveProgress) -> WaveProgress;
    fn kill_enemy(self: @WaveProgress) -> WaveProgress;
    fn complete_wave(self: @WaveProgress) -> WaveProgress;
    fn is_wave_ready_to_complete(self: @WaveProgress) -> bool;
    fn get_total_enemies(self: @WaveProgress) -> u32;
}

pub impl WaveProgressImpl of WaveProgressSystem {
    fn new(wave_id: u64, player_id: ContractAddress, total_enemies: u32) -> WaveProgress {
        assert(total_enemies > 0, errors::InvalidEnemyCount);
        
        WaveProgress {
            wave_id,
            player_id,
            total_enemies,
            enemies_spawned: 0,
            enemies_remaining: 0,
            is_completed: false,
        }
    }

    fn spawn_enemy(self: @WaveProgress) -> WaveProgress {
        assert(*self.is_completed == false, errors::AlreadyCompleted);
        
        let new_spawned = *self.enemies_spawned + 1;
        let new_remaining = *self.enemies_remaining + 1;
        
        WaveProgress {
            wave_id: *self.wave_id,
            player_id: *self.player_id,
            total_enemies: *self.total_enemies,
            enemies_spawned: new_spawned,
            enemies_remaining: new_remaining,
            is_completed: false,
        }
    }

    fn kill_enemy(self: @WaveProgress) -> WaveProgress {
        assert(*self.enemies_remaining > 0, errors::NoEnemiesRemaining);
        assert(*self.is_completed == false, errors::AlreadyCompleted);
        
        let new_remaining = *self.enemies_remaining - 1;
        let wave_completed = new_remaining == 0 && *self.enemies_spawned > 0;
        
        WaveProgress {
            wave_id: *self.wave_id,
            player_id: *self.player_id,
            total_enemies: *self.total_enemies,
            enemies_spawned: *self.enemies_spawned,
            enemies_remaining: new_remaining,
            is_completed: wave_completed,
        }
    }

    fn complete_wave(self: @WaveProgress) -> WaveProgress {
        assert(*self.is_completed == false, errors::AlreadyCompleted);
        
        WaveProgress {
            wave_id: *self.wave_id,
            player_id: *self.player_id,
            total_enemies: *self.total_enemies,
            enemies_spawned: *self.enemies_spawned,
            enemies_remaining: 0,
            is_completed: true,
        }
    }

    fn is_wave_ready_to_complete(self: @WaveProgress) -> bool {
        *self.enemies_remaining == 0 && *self.enemies_spawned > 0
    }

    fn get_total_enemies(self: @WaveProgress) -> u32 {
        *self.total_enemies
    }
}

pub impl ZeroableWaveProgress of Zero<WaveProgress> {
    fn zero() -> WaveProgress {
        WaveProgress {
            wave_id: 0_u64,
            player_id: starknet::contract_address_const::<0x0>(),
            total_enemies: 0,
            enemies_spawned: 0,
            enemies_remaining: 0,
            is_completed: false,
        }
    }

    fn is_zero(self: @WaveProgress) -> bool {
        *self.wave_id == 0_u64 && *self.player_id == starknet::contract_address_const::<0x0>()
    }

    fn is_non_zero(self: @WaveProgress) -> bool {
        !Self::is_zero(self)
    }
}

