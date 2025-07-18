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
    use starknet::{ContractAddress, get_block_timestamp, get_caller_address()};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    
    // Models
    use stark_brawl::models::player::{Player, PlayerTrait};
    use stark_brawl::models::ability::{Ability};
    use stark_brawl::models::match::{Match};
    use stark_brawl::models::item::{Item, ItemImpl, ItemType};
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
            let caller = get_caller_address();

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

        fn use_item(ref self: ContractState, item_id: u32) {
            let mut world = self.world(@"stark_brawl");
            let mut store = StoreTrait::new(world);
            let caller = get_caller_address();
            
            // Get player's inventory (simplified for now)
            let mut inventory = store.read_inventory(caller.into());
        
            assert(store.has_item(inventory, item_id), 'Player does not have item');
            
            let item = store.read_item(item_id);
            assert(item.usable, 'Item is not usable');
            
            // Get player to modify their stats
            let mut player = store.read_player();
        
            match item.item_type {
                ItemType::Trap => {
                    // Deploy trap that damages enemies
                    let trap_damage: u32 = item.value.into() * 3; // Traps do 3x item value damage
                    
                    // TODO: Implement actual enemy targeting system
                    
                    // Remove trap from inventory after deployment
                    inventory.remove_item(item_id);
                },
                ItemType::Upgrade => {
                    // Permanent player stat improvements
                    if item.name == "health_upgrade" {
                        // Increase max health permanently
                        player.max_hp += item.value;
                        // Also heal to new max if current health is full
                        if player.hp == player.max_hp - item.value {
                            player.hp = player.max_hp;
                        }
                    } else if item.name == "experience_boost" {
                        // Give XP boost
                        player.add_xp(item.value.into() * 10);
                    } else {
                        // Default upgrade: increase max health
                        player.max_hp += item.value;
                    }
                    
                    // Upgrades are consumed when used
                    inventory.remove_item(item_id);
                },
                ItemType::Consumable => {
                    // Heal the player
                    let heal_amount: u16 = item.value;
                    player.heal(heal_amount);
                    
                    // Remove consumable from inventory (single use)
                    inventory.remove_item(item_id);
                },
            }
            
            // Save all changes
            store.write_player(@player);
            store.write_inventory(@inventory);
        }
    }
}
