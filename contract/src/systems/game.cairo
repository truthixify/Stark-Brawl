use starknet::ContractAddress;


#[starknet::interface]
pub trait IBrawlGame<T> {
    fn join_game(ref self: T);
    fn use_ability(ref self: T, ability_id: u32, target_id: ContractAddress);
    fn take_damage(ref self: T, amount: u32);
    fn get_player_status(ref self: T) -> PlayerStatus;
    fn use_item(ref self: T, item_id: u32);
}

#[derive(Copy, Drop, Serde)]
pub enum PlayerStatus {
    Alive,
    Dead,
    InGame,
    Waiting,
}


#[dojo::contract]
pub mod brawl_game {
    use super::{IBrawlGame, PlayerStatus};
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{StoragePointerWriteAccess};
    
   
    use dojo::world::IWorldDispatcherTrait;
    use dojo::model::{ModelStorage};
    use dojo::event::EventStorage;
    
    
    use stark_brawl::models::player::{Player, PlayerTrait, spawn_player};
    use stark_brawl::models::ability::{Ability};
    use stark_brawl::models::item::{Item, ItemType};
    use stark_brawl::models::inventory::{Inventory};

    #[storage]
    struct Storage {
        game_counter: u32,
    }

    fn dojo_init(ref self: ContractState) {
        self.game_counter.write(0);
    }

    #[abi(embed_v0)]
    impl BrawlGameImpl of IBrawlGame<ContractState> {
        fn join_game(ref self: ContractState) {
            
            let mut world = self.world_default();
            let caller = get_caller_address();

            let player = spawn_player(caller);
            
            
            world.write_model(@player);
        }

        fn use_ability(ref self: ContractState, ability_id: u32, target_id: ContractAddress) {
            let mut world = self.world_default();
            let caller = get_caller_address();

            
            let mut player: Player = world.read_model(caller);
            let _ability: Ability = world.read_model(ability_id);

           
            world.write_model(@player);
        }

        fn take_damage(ref self: ContractState, amount: u32) {
            let mut world = self.world_default();
            let caller = get_caller_address();

            let mut player: Player = world.read_model(caller);
            
           
            PlayerTrait::take_damage(ref player, amount.try_into().unwrap());
            
            world.write_model(@player);
        }

        fn get_player_status(ref self: ContractState) -> PlayerStatus {
            let world = self.world_default();
            let caller = get_caller_address();

            let player: Player = world.read_model(caller);
            
            
            if PlayerTrait::is_alive(@player) {
                PlayerStatus::Alive
            } else {
                PlayerStatus::Dead
            }
        }

        fn use_item(ref self: ContractState, item_id: u32) {
            let mut world = self.world_default();
            let caller = get_caller_address();
            
            let mut inventory: Inventory = world.read_model(caller);
            let item: Item = world.read_model(item_id);
            let mut player: Player = world.read_model(caller);

            match item.item_type {
                ItemType::Trap => {
                    
                },
                ItemType::Upgrade => {
                    
                    let updated_player = Player {
                        max_hp: player.max_hp + item.value,
                        ..player
                    };
                    world.write_model(@updated_player);
                },
                ItemType::Consumable => {
                    
                    PlayerTrait::heal(ref player, item.value);
                    world.write_model(@player);
                },
            }
            
            world.write_model(@inventory);
        }
    }

    
    #[generate_trait]
    impl InternalImpl of InternalTrait {

        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"stark_brawl")
        }
    }
}
