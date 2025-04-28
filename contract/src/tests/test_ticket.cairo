use stark_brawl::models::tickets::*;

fn init_default_ticket() -> Tickets {
    let player = 1;
    let tickets = initialize_tickets(player);

    assert(tickets.player == player, 'Player_ID_should_match');
    assert(tickets.amount == 0, 'Ticket_amount_should_0');
    
    tickets
}

#[test]
fn test_initialize_tickets() {
    let _ = init_default_ticket();
}

#[test]
fn test_add_tickets() {
    let mut tickets = init_default_ticket();
    tickets.add_tickets(5);
    assert(tickets.amount == 5, 'Ticket amount should be 5');
}

#[test]
fn test_consume_ticket_success() {
    let mut tickets = init_default_ticket();
    tickets.add_tickets(3);

    let result = tickets.consume_ticket();
    assert(result == true, 'Ticket_should_consumed');
    assert(tickets.amount == 2, 'Ticket_amount_decrease_by_1');
}

#[test]
fn test_consume_ticket_failure() {
    let mut tickets = init_default_ticket();

    let result = tickets.consume_ticket();
    assert(result == false, 'Ticket_not_onsumed');
    assert(tickets.amount == 0, 'Ticket_amount_0');
}

#[test]
fn test_get_tickets() {
    let mut tickets = init_default_ticket();
    tickets.add_tickets(7);

    let current_tickets = tickets.get_tickets();
    assert(current_tickets == 7, 'Ticket_amount_7');
}