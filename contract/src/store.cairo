use dojo::model::ModelStorage;
use dojo::world::WorldStorage;
use stark_brawl::models::inventory::{Inventory, InventoryImpl};
use stark_brawl::models::item::Item;
use stark_brawl::models::tower_stats::TowerStats;
use stark_brawl::models::player::{Player, PlayerImpl};

#[derive(Drop)]
struct Store {
    world: WorldStorage,
}

#[generate_trait]
impl StoreImpl of StoreTrait {
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

    // Simple helpers to add coins and gems to player
    #[inline]
    fn add_coins(ref self: Store, mut player: Player, amount: u32) -> Player {
        let new_coins = player.coins + amount;
        player.coins = new_coins;
        self.write_player(@player);
        player
    }

    #[inline]
    fn add_gems(ref self: Store, mut player: Player, amount: u32) -> Player {
        let new_gems = player.gems + amount;
        player.gems = new_gems;
        self.write_player(@player);
        player
    }
}
