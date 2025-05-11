// Interface
#[starknet::interface]
pub trait IBrawlGame<T> {
    fn join_match(ref self: T);
    fn use_ability(ref self: T, ability_id: u32, target_id: ContractAddress);
    fn take_damage(ref self: T, amount: u32);
    fn get_player_status(ref self: T) -> PlayerStatus;
}

// Contrato
#[dojo::contract]
pub mod brawl_game {
    use super::IBrawlGame;
    use starknet::{ContractAddress, get_block_timestamp};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    
    // Models
    use stark_brawl::models::player::{Player, PlayerTrait};
    use stark_brawl::models::ability::{Ability};
    use stark_brawl::models::match::{Match};

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

            // lógica para incrementar contador
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
    }
}
