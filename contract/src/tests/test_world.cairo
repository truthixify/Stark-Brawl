use starknet::ContractAddress;
use starknet::contract_address_const;
use dojo_starter::models::tickets::{Tickets, ITickets, tickets};
use dojo::world::{IWorldDispatcher, WorldStorage};
use dojo::test_utils::{deploy_contract, deploy_world};

func test_add_tickets() -> () {
    let world = deploy_world();
    let contract = deploy_contract(world, tickets::Contract {});
    let player: ContractAddress = contract_address_const::<1>();
    contract.add_tickets(player, 5);
    let amount = contract.get_tickets(player);
    assert(amount == 5, 'Ticket count should be 5');
    return ();
}

func test_consume_ticket_success() -> () {
    let world = deploy_world();
    let contract = deploy_contract(world, tickets::Contract {});
    let player: ContractAddress = contract_address_const::<1>();
    contract.add_tickets(player, 3);
    let result = contract.consume_ticket(player);
    assert(result, 'Consumption should succeed');
    let amount = contract.get_tickets(player);
    assert(amount == 2, 'Ticket count should be 2');
    return ();
}

func test_consume_ticket_insufficient() -> () {
    let world = deploy_world();
    let contract = deploy_contract(world, tickets::Contract {});
    let player: ContractAddress = contract_address_const::<1>();
    let result = contract.consume_ticket(player);
    assert(!result, 'Consumption should fail');
    let amount = contract.get_tickets(player);
    assert(amount == 0, 'Ticket count should be 0');
    return ();
}

func test_consume_multiple_tickets() -> () {
    let world = deploy_world();
    let contract = deploy_contract(world, tickets::Contract {});
    let player: ContractAddress = contract_address_const::<1>();
    contract.add_tickets(player, 2);
    let result1 = contract.consume_ticket(player);
    let result2 = contract.consume_ticket(player);
    let result3 = contract.consume_ticket(player);
    assert(result1, 'First consumption should succeed');
    assert(result2, 'Second consumption should succeed');
    assert(!result3, 'Third consumption should fail');
    let amount = contract.get_tickets(player);
    assert(amount == 0, 'Ticket count should be 0');
    return ();
}