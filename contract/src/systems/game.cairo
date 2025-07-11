// Interface
#[starknet::interface]
pub trait IBrawlGame<T> {
    fn join_match(ref self: T);
    fn use_ability(ref self: T, ability_id: u32, target_id: ContractAddress);
    fn take_damage(ref self: T, amount: u32);
    fn get_player_status(ref self: T) -> PlayerStatus;
    // New item-related functions
    // fn use_item(ref self: T, item_id: u32) -> bool;
    // fn get_player_inventory(ref self: T) -> Inventory;
    // fn get_item_details(ref self: T, item_id: u32) -> Item;
}

// Contract
#[dojo::contract]
pub mod brawl_game {
    use super::IBrawlGame;
    use starknet::{ContractAddress, get_block_timestamp};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    
    // Models
    use stark_brawl::models::player::{Player, PlayerTrait};
    use stark_brawl::models::ability::{Ability};
    use stark_brawl::models::match::{Match};
    use stark_brawl::models::item::{Item, ItemImpl};
    use stark_brawl::models::inventory::{Inventory, InventoryImpl};

    // Store
    use stark_brawl::store::{StoreTrait};

    // Constants
    use stark_brawl::constants;

    #[storage]
    struct Storage {
        match_counter: u32,
    }

    fn dojo_init(ref self: ContractState) {
        self.match_counter.write(0);
    }

    #[abi(embed_v0)]
    impl BrawlGameImpl of IBrawlGame<ContractState> {
        fn join_match(ref self: ContractState) {
            let mut world = self.world(@"stark_brawl");
            let store = StoreTrait::new(world);
            let caller = starknet::get_caller_address();

            store.register_player(caller);
            store.assign_to_match(caller, self.match_counter.read());

        }

        fn use_ability(ref self: ContractState, ability_id: u32, target_id: ContractAddress) {
            let mut world = self.world(@"stark_brawl");
            let store = StoreTrait::new(world);

            let mut player = store.read_player();
            let ability = store.read_ability(ability_id);

            player.use_ability(ability, target_id);
            store.write_player(@player);
        }

        fn take_damage(ref self: ContractState, amount: u32) {
            let mut world = self.world(@"stark_brawl");
            let store = StoreTrait::new(world);

            let mut player = store.read_player();
            player.health = player.health.saturating_sub(amount);

            store.write_player(@player);
        }

        fn get_player_status(ref self: ContractState) -> PlayerStatus {
            let mut world = self.world(@"stark_brawl");
            let store = StoreTrait::new(world);

            let player = store.read_player();
            player.status()
        }

        fn use_item(ref self: ContractState, item_id: u32) -> bool {
            let mut world = self.world(@"stark_brawl");
            let mut store = StoreTrait::new(world);

            // Read player's inventory
            let mut inventory = store.read_player_inventory();
            let item = store.read_item(item_id);
            
            // Validate that the item exists in inventory
            // if !self._has_item_in_inventory(@inventory, item_id) {
            //     return false;
            // }

            // // Read the item to understand its effects
            // let item = store.read_item(item_id);
            
            // // Apply item effects to player
            // let mut player = store.read_player();
            // self._apply_item_effects(ref player, @item);
            
            // // Remove item from inventory (assuming it's consumable)
            // inventory.remove_item(item_id);
            
            // // Save updates
            // store.write_player(@player);
            // store.write_player_inventory(@inventory);
            
            true
        }

        // fn get_player_inventory(ref self: ContractState) -> Inventory {
        //     let mut world = self.world(@"stark_brawl");
        //     let store = StoreTrait::new(world);
            
        //     store.read_player_inventory()
        // }

        // fn get_item_details(ref self: ContractState, item_id: u32) -> Item {
        //     let mut world = self.world(@"stark_brawl");
        //     let store = StoreTrait::new(world);
            
        //     store.read_item(item_id)
        // }
    }

    // Internal helper functions
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn _has_item_in_inventory(ref self: ContractState, inventory: @Inventory, item_id: u32) -> bool {
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

        fn _apply_item_effects(ref self: ContractState, ref player: Player, item: @Item) {
            // This is where you define what each item does
            // For example, based on item name or ID:
            
            if item.name == @"health_potion" {
                // Heal player
                player.health = player.health + (*item.value).into();
            } else if item.name == @"strength_boost" {
                // Boost player attack (assuming player has attack field)
                // player.attack = player.attack + (*item.value).into();
            } else if item.name == @"trap" {
                // Apply trap effects - this would interact with game mechanics
                // Could damage enemies in range, slow them down, etc.
            }
            // Add more item effects as needed
        }

        fn _is_item_usable_in_context(ref self: ContractState, item: @Item) -> bool {
            // Add validation logic here
            // For example:
            // - Can only use healing items when health is not full
            // - Can only use traps during specific game phases
            // - etc.
            
            true // For now, allow all items
        }
    }
}
