use starknet::{ContractAddress, contract_address_const};
use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Tickets {
    #[key]
    pub player: ContractAddress,
    pub amount: u32,
}

pub mod errors {
    pub const NO_TICKETS: felt252 = 'Tickets: No tickets left';
}

#[generate_trait]
pub impl TicketsImpl of TicketsTrait {
    #[inline(always)]
    fn add_tickets(ref self: Tickets, amount: u32) {
        self.amount += amount;
    }

    #[inline(always)]
    fn consume_ticket(ref self: Tickets) -> bool {
        if self.amount == 0_u32 {
            return false;
        }
        self.amount -= 1_u32;
        true
    }

    #[inline(always)]
    fn get_tickets(self: @Tickets) -> u32 {
        *self.amount
    }
}

pub impl ZeroableTickets of Zero<Tickets> {
    #[inline(always)]
    fn zero() -> Tickets {
        Tickets {
            player: contract_address_const::<0>(),
            amount: 0_u32,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Tickets) -> bool {
        *self.amount == 0_u32
    }

    #[inline(always)]
    fn is_non_zero(self: @Tickets) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::contract_address_const;

    #[test]
    fn test_add_and_get() {
        let player = contract_address_const::<0xAAA>();
        let mut t = Tickets { player, amount: 0 };
        TicketsImpl::add_tickets(ref t, 3_u32);
        assert(TicketsImpl::get_tickets(@t) == 3_u32, 'Should have 3 tickets');
    }

    #[test]
    fn test_consume_success() {
        let player = contract_address_const::<0xBBB>();
        let mut t = Tickets { player, amount: 2 };
        let result = TicketsImpl::consume_ticket(ref t);
        assert(result, 'Should consume ticket');
        assert(TicketsImpl::get_tickets(@t) == 1_u32, 'Should have 1 left');
    }

    #[test]
    fn test_consume_failure() {
        let player = contract_address_const::<0xCCC>();
        let mut t = Tickets { player, amount: 0 };
        let result = TicketsImpl::consume_ticket(ref t);
        assert(!result, 'Should not consume');
        assert(TicketsImpl::get_tickets(@t) == 0_u32, 'Still 0');
    }

    #[test]
    fn test_zero_check() {
        let zero = ZeroableTickets::zero();
        assert(ZeroableTickets::is_zero(@zero), 'Should be zero');
        assert(!ZeroableTickets::is_non_zero(@zero), 'Should not be non-zero');

        let t = Tickets { player: contract_address_const::<0xDDD>(), amount: 5 };
        assert(!ZeroableTickets::is_zero(@t), 'Should not be zero');
        assert(ZeroableTickets::is_non_zero(@t), 'Should be non-zero');
    }
}
