#[cfg(test)]
mod TestTickets {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use super::Tickets;
    use super::Tickets::{set_tickets, consume_ticket, get_tickets};

    #[test]
    #[available_gas(2000000)]
    fn test_successful_ticket_consumption() {
        let player: ContractAddress = contract_address_const::<1>();
        // Set initial tickets
        set_tickets(player, 5);
        // Consume one ticket
        consume_ticket();
        // Verify remaining tickets
        let remaining = get_tickets(player);
        assert(remaining == 4, 'Ticket count should be 4');
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic(expected = ('No tickets available',))]
    fn test_consume_with_zero_tickets() {
        let player: ContractAddress = contract_address_const::<1>();
        // Set zero tickets
        set_tickets(player, 0);
        // Attempt to consume (should fail)
        consume_ticket();
    }

    #[test]
    #[available_gas(2000000)]
    fn test_multiple_consumptions() {
        let player: ContractAddress = contract_address_const::<1>();
        // Set initial tickets
        set_tickets(player, 3);
        // Consume two tickets
        consume_ticket();
        consume_ticket();
        // Verify remaining tickets
        let remaining = get_tickets(player);
        assert(remaining == 1, 'Ticket count should be 1');
    }
}