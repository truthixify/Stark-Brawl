use dojo::model::ModelStorage;
use dojo::world::WorldStorage;
use stark_brawl::models::ability::Ability;
use stark_brawl::models::inventory::{Inventory, InventoryImpl};
use stark_brawl::models::item::Item;
use stark_brawl::models::player::Player;
use stark_brawl::models::tower_stats::TowerStats;
use starknet::ContractAddress;

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

    #[inline]
    fn get_tower_stats(self: Store, tower_type: felt252, level: u8) -> TowerStats {
        self.world.read_model((tower_type, level))
    }

    #[inline]
    fn set_tower_stats(ref self: Store, tower_stats: TowerStats) {
        self.world.write_model(@tower_stats);
    }

    // // Item operations
    // #[inline]
    // fn read_item(self: Store, item_id: u32) -> Item {
    //     self.world.read_model(item_id)
    // }

    // #[inline]
    // fn write_item(ref self: Store, item: @Item) {
    //     self.world.write_model(item);
    // }

    // // Inventory operations
    // #[inline]
    // fn read_inventory(self: Store, inventory_id: u32) -> Inventory {
    //     self.world.read_model(inventory_id)
    // }

    // #[inline]
    // fn write_inventory(ref self: Store, inventory: @Inventory) {
    //     self.world.write_model(inventory);
    // }

    // // Get player's inventory using their address as ID
    // #[inline]
    // fn read_player_inventory(self: Store) -> Inventory {
    //     let caller = starknet::get_caller_address();
    //     let inventory_id: u32 = caller.into(); // Convert address to u32 for ID
    //     let inventory = self.world.read_model(inventory_id);

    //     // If inventory doesn't exist, create new one
    //     if !inventory.is_set {
    //         InventoryImpl::new(inventory_id)
    //     } else {
    //         inventory
    //     }
    // }

    // #[inline]
    // fn write_player_inventory(ref self: Store, inventory: @Inventory) {
    //     self.world.write_model(inventory);
    // }

    // // Read ability (you already had this logic somewhere)
    // #[inline]
    // fn read_ability(self: Store, ability_id: u32) -> Ability {
    //     self.world.read_model(ability_id)
    // }
}
