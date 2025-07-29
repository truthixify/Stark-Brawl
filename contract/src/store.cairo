use dojo::model::ModelStorage;
use dojo::world::WorldStorage;
use stark_brawl::models::inventory::{Inventory, InventoryImpl};
use stark_brawl::models::item::Item;
use stark_brawl::models::tower_stats::TowerStats;
use stark_brawl::models::player::{Player, PlayerImpl};
use stark_brawl::models::wave::{errors, Wave, WaveImpl, ZeroableWave};
use stark_brawl::models::enemy::{Enemy, EnemyImpl, ZeroableEnemy};

#[derive(Drop)]
pub struct Store {
    world: WorldStorage,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    // -------------------------------
    // Tower operations
    // -------------------------------
    #[inline]
    fn get_tower_stats(self: Store, tower_type: felt252, level: u8) -> TowerStats {
        self.world.read_model((tower_type, level))
    }

    #[inline]
    fn set_tower_stats(ref self: Store, tower_stats: TowerStats) {
        self.world.write_model(@tower_stats);
    }

    // -------------------------------
    // Item operations
    // -------------------------------
    #[inline]
    fn read_item(self: Store, item_id: u32) -> Item {
        self.world.read_model(item_id)
    }

    #[inline]
    fn write_item(ref self: Store, item: @Item) {
        self.world.write_model(item);
    }

    // -------------------------------
    // Inventory operations
    // -------------------------------
    #[inline]
    fn read_inventory(self: Store, inventory_id: u32) -> Inventory {
        self.world.read_model(inventory_id)
    }

    #[inline]
    fn write_inventory(ref self: Store, inventory: @Inventory) {
        self.world.write_model(inventory);
    }

    #[inline]
    fn has_item(ref self: Store, inventory: @Inventory, item_id: u32) -> bool {
        let mut i = 0;
        loop {
            if i >= inventory.items.len() {
                break false;
            }
            let current_item = inventory.items.at(i);
            if current_item.id == @item_id {
                break true;
            }
            i += 1;
        }
    }

    // -------------------------------
    // Player operations (NEW)
    // -------------------------------
    #[inline]
    fn read_player(self: Store, player_id: felt252) -> Player {
        self.world.read_model(player_id)
    }

    #[inline]
    fn write_player(ref self: Store, player: @Player) {
        self.world.write_model(player);
    }

    // -------------------------------
    // Wave operations (NEW)
    // -------------------------------
    #[inline]
    fn read_wave(self: @Store, wave_id: u64) -> Wave {
        let wave: Wave = self.world.read_model(wave_id);
        assert(wave.is_non_zero(), 'Wave not found');
        wave
    }

    #[inline]
    fn write_wave(ref self: Store, wave: @Wave) {
        self.world.write_model(wave);
        // self.emit(Event::WaveStored { wave_id: *wave.id });
    }

    #[inline]
    fn start_wave(ref self: Store, wave_id: u64, current_tick: u64) {
        let mut wave = self.read_wave(wave_id);
        assert(wave.is_active == false, errors::AlreadyActive);
        assert(wave.is_completed == false, errors::AlreadyCompleted);
        let started_wave = WaveImpl::start(@wave, current_tick);
        self.write_wave(@started_wave)
    }

    #[inline]
    fn register_enemy_spawn(ref self: Store, wave_id: u64, current_tick: u64) {
        let wave = self.read_wave(wave_id);
        assert(WaveImpl::should_spawn(@wave, current_tick) == true, errors::InvalidSpawnTick);
        let spawned_wave = WaveImpl::register_spawn(@wave, current_tick);
        self.write_wave(@spawned_wave)

    }

    #[inline]
    fn complete_wave(ref self: Store, wave_id: u64) {
        let mut wave = self.read_wave(wave_id);
        assert(wave.is_active == true, errors::NotActive);
        let completed_wave = WaveImpl::complete(@wave);
        self.write_wave(@completed_wave)
    }

    // -------------------------------
    // Enemy operations (NEW)
    // -------------------------------
    #[inline]
    fn read_enemy(self: @Store, enemy_id: u64) -> Enemy {
        let enemy: Enemy = self.world.read_model(enemy_id);
        assert(enemy.is_non_zero(), 'Enemy id not found');
        enemy
    }

    #[inline]
    fn write_enemy(ref self: Store, enemy: @Enemy) {
        self.world.write_model(enemy);
    }

    #[inline]
    fn spawn_enemy(ref self: Store, enemy: Enemy) {
        assert(enemy.is_zero() == false, 'Enemy is not initialized');
        self.write_enemy(@enemy)
    }

    #[inline]
    fn update_enemy_health(ref self: Store, enemy_id: u64, damage: u32) {
        let enemy: Enemy = self.read_enemy(enemy_id);
        assert(enemy.is_alive == true, 'Enemy is dead');
        let damaged_enemy = EnemyImpl::take_damage(@enemy, damage);
        self.write_enemy(@damaged_enemy);
    }

    #[inline]
    fn move_enemy(ref self: Store, enemy_id: u64, x: u32, y: u32) {
        let enemy: Enemy = self.read_enemy(enemy_id);
        assert(enemy.is_alive == true, 'Enemy is dead');
        let moved_enemy = EnemyImpl::move_to(@enemy, x, y);
        self.write_enemy(@moved_enemy);
    }

    // Simple helpers to add coins and gems to player
    #[inline]
fn add_coins(ref self: Store, mut player: Player, amount: u64) -> Player {
    let new_coins = player.coins + amount;
    player.coins = new_coins;
    self.write_player(@player);
    player
}

#[inline]
fn add_gems(ref self: Store, mut player: Player, amount: u64) -> Player {
    let new_gems = player.gems + amount;
    player.gems = new_gems;
    self.write_player(@player);
    player
}

}
