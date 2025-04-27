use starknet::ContractAddress;
use dojo::model::{Model, ModelStorage};
use dojo::event::EventStorage;

#[derive(Copy, Drop, Serde, Default, Introspect)]
pub struct Tickets {
    #[key]
    pub player: ContractAddress,
    pub amount: u32,
}

#[starknet::interface]
pub trait ITickets<T> {
    fn add_tickets(ref self: T, player: ContractAddress, amount: u32);
    fn consume_ticket(ref self: T, player: ContractAddress) -> bool;
    fn get_tickets(self: @T, player: ContractAddress) -> u32;
}

#[dojo::contract]
pub mod tickets {
    use super::{Tickets, ITickets};
    use starknet::{ContractAddress, get_caller_address};
    use dojo::world::{WorldStorage};

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TicketConsumed {
        #[key]
        pub player: ContractAddress,
        pub new_amount: u32,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct InsufficientTickets {
        #[key]
        pub player: ContractAddress,
        pub attempted_amount: u32,
    }

    #[abi(embed_v0)]
    impl TicketsImpl of ITickets<ContractState> {
        fn add_tickets(ref self: ContractState, player: ContractAddress, amount: u32) {
            let mut world = self.world_default();
            let mut tickets: Tickets = world.read_model(player);
            tickets.amount += amount;
            world.write_model(@tickets);
        }

        fn consume_ticket(ref self: ContractState, player: ContractAddress) -> bool {
            let mut world = self.world_default();
            let mut tickets: Tickets = world.read_model(player);
            if tickets.amount == 0 {
                world.emit_event(@InsufficientTickets { player, attempted_amount: 1 });
                return false;
            }
            tickets.amount -= 1;
            world.write_model(@tickets);
            world.emit_event(@TicketConsumed { player, new_amount: tickets.amount });
            true
        }

        fn get_tickets(self: @ContractState, player: ContractAddress) -> u32 {
            let world = self.world_default();
            let tickets: Tickets = world.read_model(player);
            tickets.amount
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> WorldStorage {
            self.world(@"dojo_starter")
        }
    }
}

#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use super::{Tickets, ITickets, tickets};
    use dojo::world::{WorldStorage, IWorldDispatcher};
    use dojo::test_utils::{deploy_contract, deploy_world};

    fn setup() -> (IWorldDispatcher, tickets::ContractDispatcher) {
        let world = deploy_world();
        let contract = deploy_contract(world, tickets::Contract {});
        (world, contract)
    }

    #[test]
    fn test_add_tickets() {
        let (_world, contract) = setup();
        let player: ContractAddress = contract_address_const::<1>();
        contract.add_tickets(player, 5);
        let amount = contract.get_tickets(player);
        assert(amount == 5, 'Ticket count should be 5');
    }

    #[test]
    fn test_consume_ticket_success() {
        let (_world, contract) = setup();
        let player: ContractAddress = contract_address_const::<1>();
        contract.add_tickets(player, 3);
        let result = contract.consume_ticket(player);
        assert(result, 'Consumption should succeed');
        let amount = contract.get_tickets(player);
        assert(amount == 2, 'Ticket count should be 2');
    }

    #[test]
    fn test_consume_ticket_insufficient() {
        let (_world, contract) = setup();
        let player: ContractAddress = contract_address_const::<1>();
        let result = contract.consume_ticket(player);
        assert(!result, 'Consumption should fail');
        let amount = contract.get_tickets(player);
        assert(amount == 0, 'Ticket count should be 0');
    }
}