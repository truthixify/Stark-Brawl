#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Tickets {
    #[key]
    pub player: felt252,
    pub amount: u32,
}

pub fn initialize_tickets(player: felt252) -> Tickets {
    Tickets {
        player,
        amount: 0,
    }
}

pub trait TicketsTrait<T> {
    fn add_tickets(ref self: T, amount: u32);
    fn consume_ticket(ref self: T) -> bool;
    fn get_tickets(self: @T) -> u32;
}

pub impl TicketsImpl of TicketsTrait<Tickets> {
    fn add_tickets(ref self: Tickets, amount: u32) {
        self.amount += amount;
    }

    fn consume_ticket(ref self: Tickets) -> bool {
        if self.amount == 0 {
            return false;
        }
        self.amount -= 1;
        true
    }

    fn get_tickets(self: @Tickets) -> u32 {
        *self.amount
    }
}
