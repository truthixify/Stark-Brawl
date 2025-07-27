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

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::{ContractAddress, contract_address_const};

    fn sample_player() -> ContractAddress {
        contract_address_const::<0x123>()
    }

    fn sample_wave_progress() -> WaveProgress {
        WaveProgressImpl::new(1_u64, sample_player(), 5_u32)
    }

    #[test]
    fn test_instantiation() {
        let wave_progress = sample_wave_progress();
        assert(wave_progress.wave_id == 1_u64, 'Incorrect wave_id');
        assert(wave_progress.player_id == sample_player(), 'Incorrect player_id');
        assert(wave_progress.enemies_spawned == 0_u32, 'Should start with 0 spawned');
        assert(wave_progress.enemies_remaining == 0_u32, 'Should start with 0 remaining');
        assert(wave_progress.is_completed == false, 'Should not be completed');
    }

    #[test]
    #[should_panic(expected: ('Invalid enemy count',))]
    fn test_invalid_enemy_count() {
        let _ = WaveProgressImpl::new(1_u64, sample_player(), 0_u32);
    }

    #[test]
    fn test_spawn_enemy() {
        let wave_progress = sample_wave_progress();
        let updated = WaveProgressImpl::spawn_enemy(@wave_progress);

        assert(updated.enemies_spawned == 1_u32, 'Should have 1 spawned');
        assert(updated.enemies_remaining == 1_u32, 'Should have 1 remaining');
        assert(updated.is_completed == false, 'Should not be completed');
    }

    #[test]
    fn test_kill_enemy() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let killed = WaveProgressImpl::kill_enemy(@spawned);

        assert(killed.enemies_spawned == 1_u32, 'Should still have 1 spawned');
        assert(killed.enemies_remaining == 0_u32, 'Should have 0 remaining');
        assert(killed.is_completed == true, 'Should be completed');
    }

    #[test]
    #[should_panic(expected: ('No enemies remaining',))]
    fn test_kill_enemy_when_none_remaining() {
        let wave_progress = sample_wave_progress();
        let _ = WaveProgressImpl::kill_enemy(@wave_progress);
    }

    #[test]
    fn test_multiple_enemies() {
        let wave_progress = sample_wave_progress();
        let spawned1 = WaveProgressImpl::spawn_enemy(@wave_progress);
        let spawned2 = WaveProgressImpl::spawn_enemy(@spawned1);
        let spawned3 = WaveProgressImpl::spawn_enemy(@spawned2);

        assert(spawned3.enemies_spawned == 3_u32, 'Should have 3 spawned');
        assert(spawned3.enemies_remaining == 3_u32, 'Should have 3 remaining');

        let killed1 = WaveProgressImpl::kill_enemy(@spawned3);
        assert(killed1.enemies_remaining == 2_u32, 'Should have 2 remaining');
        assert(killed1.is_completed == false, 'Should not be completed yet');

        let killed2 = WaveProgressImpl::kill_enemy(@killed1);
        let killed3 = WaveProgressImpl::kill_enemy(@killed2);

        assert(killed3.enemies_remaining == 0_u32, 'Should have 0 remaining');
        assert(killed3.is_completed == true, 'Should be completed');
    }

    #[test]
    fn test_complete_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);

        assert(completed.is_completed == true, 'Should be completed');
        assert(completed.enemies_remaining == 0_u32, 'Should have 0 remaining');
    }

    #[test]
    #[should_panic(expected: ('Wave already completed',))]
    fn test_complete_already_completed_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);
        let _ = WaveProgressImpl::complete_wave(@completed);
    }

    #[test]
    #[should_panic(expected: ('Wave already completed',))]
    fn test_spawn_enemy_on_completed_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);
        let _ = WaveProgressImpl::spawn_enemy(@completed);
    }

    #[test]
    fn test_is_wave_ready_to_complete() {
        let wave_progress = sample_wave_progress();
        assert(
            WaveProgressImpl::is_wave_ready_to_complete(@wave_progress) == false,
            'Should not be ready',
        );

        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        assert(
            WaveProgressImpl::is_wave_ready_to_complete(@spawned) == false,
            'Not ready with enemies',
        );

        let killed = WaveProgressImpl::kill_enemy(@spawned);
        assert(
            WaveProgressImpl::is_wave_ready_to_complete(@killed) == true,
            'Should be ready to complete',
        );
    }

    #[test]
    fn test_get_total_enemies() {
        let wave_progress = sample_wave_progress();
        assert(WaveProgressImpl::get_total_enemies(@wave_progress) == 5_u32, 'Should have 5 total');

        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        assert(WaveProgressImpl::get_total_enemies(@spawned) == 5_u32, 'Should still have 5 total');

        let spawned2 = WaveProgressImpl::spawn_enemy(@spawned);
        assert(
            WaveProgressImpl::get_total_enemies(@spawned2) == 5_u32, 'Should still have 5 total',
        );

        let killed = WaveProgressImpl::kill_enemy(@spawned2);
        assert(WaveProgressImpl::get_total_enemies(@killed) == 5_u32, 'Should still have 5 total');
    }

    #[test]
    fn test_zero_implementation() {
        let zero_progress = ZeroableWaveProgress::zero();
        assert(zero_progress.is_zero(), 'Should be zero');
        assert(zero_progress.wave_id == 0_u64, 'Wave ID should be zero');
        assert(zero_progress.enemies_spawned == 0_u32, 'Spawned should be zero');

        let non_zero_progress = sample_wave_progress();
        assert(non_zero_progress.is_non_zero(), 'Should be non-zero');
    }

    #[test]
    fn test_different_players_same_wave() {
        let player1: ContractAddress = contract_address_const::<0x123>();
        let player2: ContractAddress = contract_address_const::<0x456>();

        let progress1 = WaveProgressImpl::new(1_u64, player1, 3_u32);
        let progress2 = WaveProgressImpl::new(1_u64, player2, 3_u32);

        assert(progress1.player_id != progress2.player_id, 'Should have different players');
        assert(progress1.wave_id == progress2.wave_id, 'Should have same wave');

        // Test independent progress
        let spawned1 = WaveProgressImpl::spawn_enemy(@progress1);
        assert(spawned1.enemies_spawned == 1_u32, 'Player 1 should have 1 spawned');
        assert(progress2.enemies_spawned == 0_u32, 'Player 2 has 0 spawned');
    }
}
