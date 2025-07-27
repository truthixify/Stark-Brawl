mod tests {
    use stark_brawl::models::wave_progress::{
        WaveProgress, WaveProgressImpl, ZeroableWaveProgress
    };
    use starknet::{ContractAddress, contract_address_const};
    use core::num::traits::zero::Zero;

    fn sample_player() -> ContractAddress {
        contract_address_const::<0x123>()
    }

    fn sample_wave_progress() -> WaveProgress {
        WaveProgressImpl::new(1_u64, sample_player(), 5_u32)
    }

    #[test]
    fn test_wave_progress_instantiation() {
        let wave_progress = sample_wave_progress();
        assert(wave_progress.wave_id == 1_u64, 'Incorrect wave_id');
        assert(wave_progress.player_id == sample_player(), 'Incorrect player_id');
        assert(wave_progress.total_enemies == 5_u32, 'Incorrect total enemies');
        assert(wave_progress.enemies_spawned == 0_u32, 'Should start with 0 spawned');
        assert(wave_progress.enemies_remaining == 0_u32, 'Should start with 0 remaining');
        assert(wave_progress.is_completed == false, 'Should not be completed');
    }

    #[test]
    #[should_panic(expected: ('Invalid enemy count',))]
    fn test_wave_progress_invalid_enemy_count() {
        let _ = WaveProgressImpl::new(1_u64, sample_player(), 0_u32);
    }

    #[test]
    fn test_wave_progress_spawn_enemy() {
        let wave_progress = sample_wave_progress();
        let updated = WaveProgressImpl::spawn_enemy(@wave_progress);
        
        assert(updated.enemies_spawned == 1_u32, 'Should have 1 spawned');
        assert(updated.enemies_remaining == 1_u32, 'Should have 1 remaining');
        assert(updated.is_completed == false, 'Should not be completed');
    }

    #[test]
    fn test_wave_progress_kill_enemy() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let killed = WaveProgressImpl::kill_enemy(@spawned);
        
        assert(killed.enemies_spawned == 1_u32, 'Should still have 1 spawned');
        assert(killed.enemies_remaining == 0_u32, 'Should have 0 remaining');
        assert(killed.is_completed == true, 'Should be completed');
    }

    #[test]
    #[should_panic(expected: ('No enemies remaining',))]
    fn test_wave_progress_kill_enemy_when_none_remaining() {
        let wave_progress = sample_wave_progress();
        let _ = WaveProgressImpl::kill_enemy(@wave_progress);
    }

    #[test]
    fn test_wave_progress_multiple_enemies() {
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
    fn test_wave_progress_complete_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);
        
        assert(completed.is_completed == true, 'Should be completed');
        assert(completed.enemies_remaining == 0_u32, 'Should have 0 remaining');
    }

    #[test]
    #[should_panic(expected: ('Wave already completed',))]
    fn test_wave_progress_complete_already_completed_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);
        let _ = WaveProgressImpl::complete_wave(@completed);
    }

    #[test]
    #[should_panic(expected: ('Wave already completed',))]
    fn test_wave_progress_spawn_enemy_on_completed_wave() {
        let wave_progress = sample_wave_progress();
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        let completed = WaveProgressImpl::complete_wave(@spawned);
        let _ = WaveProgressImpl::spawn_enemy(@completed);
    }

    #[test]
    fn test_wave_progress_is_wave_ready_to_complete() {
        let wave_progress = sample_wave_progress();
        assert(WaveProgressImpl::is_wave_ready_to_complete(@wave_progress) == false, 'Should not be ready');
        
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        assert(WaveProgressImpl::is_wave_ready_to_complete(@spawned) == false, 'Not ready with enemies left');
        
        let killed = WaveProgressImpl::kill_enemy(@spawned);
        assert(WaveProgressImpl::is_wave_ready_to_complete(@killed) == true, 'Should be ready to complete');
    }

    #[test]
    fn test_wave_progress_get_total_enemies() {
        let wave_progress = sample_wave_progress();
        assert(WaveProgressImpl::get_total_enemies(@wave_progress) == 5_u32, 'Should have 5 total');
        
        let spawned = WaveProgressImpl::spawn_enemy(@wave_progress);
        assert(WaveProgressImpl::get_total_enemies(@spawned) == 5_u32, 'Should still have 5 total');
        
        let spawned2 = WaveProgressImpl::spawn_enemy(@spawned);
        assert(WaveProgressImpl::get_total_enemies(@spawned2) == 5_u32, 'Should still have 5 total');
        
        let killed = WaveProgressImpl::kill_enemy(@spawned2);
        assert(WaveProgressImpl::get_total_enemies(@killed) == 5_u32, 'Should still have 5 total');
    }

    #[test]
    fn test_wave_progress_zero_implementation() {
        let zero_progress = ZeroableWaveProgress::zero();
        assert(zero_progress.is_zero(), 'Should be zero');
        assert(zero_progress.wave_id == 0_u64, 'Wave ID should be zero');
        assert(zero_progress.enemies_spawned == 0_u32, 'Spawned should be zero');
        
        let non_zero_progress = sample_wave_progress();
        assert(non_zero_progress.is_non_zero(), 'Should be non-zero');
    }

    #[test]
    fn test_wave_progress_different_players_same_wave() {
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

    #[test]
    fn test_wave_progress_sequential_operations() {
        let wave_progress = sample_wave_progress();
        
        // Test enemy spawning updates
        let spawned1 = WaveProgressImpl::spawn_enemy(@wave_progress);
        assert(spawned1.enemies_spawned == 1_u32, 'Should have 1 spawned');
        assert(spawned1.enemies_remaining == 1_u32, 'Should have 1 remaining');
        assert(spawned1.is_completed == false, 'Should not be completed');
        
        let spawned2 = WaveProgressImpl::spawn_enemy(@spawned1);
        assert(spawned2.enemies_spawned == 2_u32, 'Should have 2 spawned');
        assert(spawned2.enemies_remaining == 2_u32, 'Should have 2 remaining');
        assert(spawned2.is_completed == false, 'Should not be completed');
        
        let spawned3 = WaveProgressImpl::spawn_enemy(@spawned2);
        assert(spawned3.enemies_spawned == 3_u32, 'Should have 3 spawned');
        assert(spawned3.enemies_remaining == 3_u32, 'Should have 3 remaining');
        assert(spawned3.is_completed == false, 'Should not be completed');
        
        // Test enemy killing updates
        let killed1 = WaveProgressImpl::kill_enemy(@spawned3);
        assert(killed1.enemies_remaining == 2_u32, 'Should have 2 remaining');
        assert(killed1.is_completed == false, 'Should not be completed yet');
        
        let killed2 = WaveProgressImpl::kill_enemy(@killed1);
        assert(killed2.enemies_remaining == 1_u32, 'Should have 1 remaining');
        assert(killed2.is_completed == false, 'Should not be completed yet');
        
        // Final kill should complete the wave
        let killed3 = WaveProgressImpl::kill_enemy(@killed2);
        assert(killed3.enemies_remaining == 0_u32, 'Should have 0 remaining');
        assert(killed3.is_completed == true, 'Should be completed');
    }
}