mod tests {

    use dojo_cairo_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world,
    };
    use dojo::world::{WorldStorage};

    use stark_brawl::models::trap::{TrapTrait, ZeroableTrapTrait};
    use stark_brawl::models::wave::{Wave, WaveImpl};
    use stark_brawl::models::enemy::{Enemy, EnemyImpl};
    use stark_brawl::store::{Store, StoreTrait};

    // System imports
    use stark_brawl::systems::game::{brawl_game};

    // Model Imports
    use stark_brawl::models::wave::{m_Wave};
    use stark_brawl::models::enemy::{m_Enemy};
    use stark_brawl::models::tower::{m_Tower};
    use stark_brawl::models::tower_stats::{m_TowerStats};
    use stark_brawl::models::item::{m_Item};
    use stark_brawl::models::inventory::{m_Inventory};
    use stark_brawl::models::player::{m_Player};

    pub fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "brawl_game",
            resources: [
                TestResource::Model(m_Wave::TEST_CLASS_HASH),
                TestResource::Model(m_Enemy::TEST_CLASS_HASH),
                TestResource::Model(m_Tower::TEST_CLASS_HASH),
                TestResource::Model(m_TowerStats::TEST_CLASS_HASH),
                TestResource::Model(m_Item::TEST_CLASS_HASH),
                TestResource::Model(m_Inventory::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Contract(brawl_game::TEST_CLASS_HASH),
            ].span(),
        };

        ndef
    }

    pub fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"brawl_game", @"brawl_game")
                .with_writer_of([dojo::utils::bytearray_hash(@"brawl_game")].span()),
        ]
            .span()
    }

    pub fn create_test_world() -> WorldStorage {
         // Initialize test environment
         let ndef = namespace_def();

         // Register the resources.
         let mut world = spawn_test_world([ndef].span());
 
         // Ensures permissions and initializations are synced.
         world.sync_perms_and_inits(contract_defs());

         world
    }

    fn create_sample_wave() -> Wave {
        WaveImpl::new(1_u64, 1_u32, 3_u32, 100_u32)
    }

    fn create_sample_enemy() -> Enemy {
        EnemyImpl::new(1_u64, 'goblin', 100_u32, 5_u32, 10_u32, 20_u32, 10_u32, 50_u32)
    }

    #[test]
    fn test_store_write_read_wave() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        let wave = store.read_wave(1_u64);

        assert(wave.id == 1_u64, 'Invalid id');
        assert(wave.level == 1_u32, 'Invalid level');
        assert(wave.enemy_count == 3_u32, 'Invalid enemy_count');
        assert(wave.tick_interval == 100_u32, 'Invalid tick_interval');
        assert(wave.enemies_spawned == 0, 'Invalid enemies_spawned');
        assert(wave.last_spawn_tick == 0, 'Invalid last_spawn_tick');
        assert(wave.is_active == false, 'Invalid is_active');
        assert(wave.is_completed == false, 'Invalid is_completed');
    }

    #[test]
    fn test_store_start_wave() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        let wave = store.read_wave(1_u64);
        let new_tick = 200_u64;

        store.start_wave(wave.id, new_tick);
        let active_wave = store.read_wave(wave.id);

        assert(active_wave.is_active == true, 'Should be active');
        assert(active_wave.last_spawn_tick == 200_u64, 'Incorrect last spawn tick');
    }

    #[test]
    fn test_store_register_spawn() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.register_enemy_spawn(wave.id, 300_u64);

        let updated_wave = store.read_wave(wave.id);

        assert(updated_wave.enemies_spawned == 1_u32, 'Should have 1 spawned');
        assert(updated_wave.last_spawn_tick == 300_u64, 'Should update last spawn tick');
    }

     #[test]
    fn test_store_complete_wave() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.complete_wave(wave.id);

        let completed_wave = store.read_wave(wave.id);

        assert(completed_wave.is_active == false, 'Should not be active');
        assert(completed_wave.is_completed == true, 'Should be completed');
    }

    #[test]
    #[should_panic(expected: ('Wave already active',))]
    fn test_store_already_started() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.start_wave(wave.id, 300_u64);
    }

    #[test]
    #[should_panic(expected: ('Wave already completed',))]
    fn test_store_not_start_after_complete_wave() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.complete_wave(wave.id);

        let _completed_wave = store.read_wave(wave.id);

        store.start_wave(wave.id, 300_u64);
    }

    #[test]
    #[should_panic(expected: ('Invalid spawn tick',))]
    fn test_store_not_register_spawn_after_complete_wave() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.complete_wave(wave.id);

        let _completed_wave = store.read_wave(wave.id);

        store.register_enemy_spawn(wave.id, 300_u64);
    }

    #[test]
    #[should_panic(expected: ('Invalid spawn tick',))]
    fn test_store_register_spawn_beyond_count() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let wave = create_sample_wave();
        store.write_wave(@wave);

        store.start_wave(wave.id, 200_u64);
        store.register_enemy_spawn(wave.id, 300_u64);
        store.register_enemy_spawn(wave.id, 400_u64);
        store.register_enemy_spawn(wave.id, 500_u64);
        store.register_enemy_spawn(wave.id, 700_u64);

        let _updated_wave = store.read_wave(wave.id);
    }

    #[test]
    fn test_store_spawn_enemy() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let enemy = create_sample_enemy();
        store.spawn_enemy(enemy);

        let enemy = store.read_enemy(1_u64);

        assert(enemy.id == 1_u64, 'Invalid id');
        assert(enemy.enemy_type == 'goblin', 'Invalid enemy_type');
        assert(enemy.health == 100_u32, 'Invalid health');
        assert(enemy.speed == 5_u32, 'Invalid speed');
        assert(enemy.x == 10_u32, 'Invalid x');
        assert(enemy.y == 20_u32, 'Invalid y');
        assert(enemy.is_alive == true, 'Invalid enemy');
        assert(enemy.coin_reward == 10_u32, 'Invalid coin_reward');
        assert(enemy.xp_reward == 50_u32, 'Invalid xp_reward');
    }

     #[test]
    fn test_store_update_enemy_health() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let enemy = create_sample_enemy();
        store.spawn_enemy(enemy);

        store.update_enemy_health(1_u64, 20_u32);

        let enemy = store.read_enemy(1_u64);
        
        assert(enemy.id == 1_u64, 'Invalid id');
        assert(enemy.enemy_type == 'goblin', 'Invalid enemy_type');
        assert(enemy.health == 80_u32, 'Invalid health');
        assert(enemy.speed == 5_u32, 'Invalid speed');
        assert(enemy.x == 10_u32, 'Invalid x');
        assert(enemy.y == 20_u32, 'Invalid y');
        assert(enemy.is_alive == true, 'Invalid enemy');
        assert(enemy.coin_reward == 10_u32, 'Invalid coin_reward');
        assert(enemy.xp_reward == 50_u32, 'Invalid xp_reward');
    }

     #[test]
    fn test_store_move_enemy() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let enemy = create_sample_enemy();
        store.spawn_enemy(enemy);

        store.move_enemy(1_u64, 30_u32, 50_u32);

        let enemy = store.read_enemy(1_u64);
        
        assert(enemy.id == 1_u64, 'Invalid id');
        assert(enemy.enemy_type == 'goblin', 'Invalid enemy_type');
        assert(enemy.health == 100_u32, 'Invalid health');
        assert(enemy.speed == 5_u32, 'Invalid speed');
        assert(enemy.x == 30_u32, 'Invalid x');
        assert(enemy.y == 50_u32, 'Invalid y');
        assert(enemy.is_alive == true, 'Invalid enemy');
        assert(enemy.coin_reward == 10_u32, 'Invalid coin_reward');
        assert(enemy.xp_reward == 50_u32, 'Invalid xp_reward');
    }

    #[test]
    #[should_panic(expected: ('Enemy is dead',))]
    fn test_store_move_dead_enemy() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let enemy = create_sample_enemy();
        store.spawn_enemy(enemy);

        store.update_enemy_health(1_u64, 100_u32);
        store.move_enemy(1_u64, 30_u32, 50_u32);
    }

    #[test]
    #[should_panic(expected: ('Enemy is dead',))]
    fn test_store_update_dead_enemy() {
        let world = create_test_world();
        let mut store: Store = StoreTrait::new(world);

        let enemy = create_sample_enemy();
        store.spawn_enemy(enemy);

        store.update_enemy_health(1_u64, 100_u32);
        store.update_enemy_health(1_u64, 10_u32);
    }
}