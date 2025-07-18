use starknet::{ContractAddress, contract_address_const};
use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
#[dojo::model]
pub struct Team {
    #[key]
    pub id: ContractAddress,
    pub max_size: u8,
}

pub mod errors {
    pub const TEAM_FULL: felt252 = 'Team: Max size reached';
}

#[generate_trait]
pub impl TeamImpl of TeamTrait {
    #[inline(always)]
    fn is_full(self: @Team, member_count: u8) -> bool {
        member_count >= *self.max_size
    }
}

pub impl ZeroableTeamTrait of Zero<Team> {
    #[inline(always)]
    fn zero() -> Team {
        Team { id: contract_address_const::<0>(), max_size: 0 }
    }

    #[inline(always)]
    fn is_zero(self: @Team) -> bool {
        *self.max_size == 0
    }

    #[inline(always)]
    fn is_non_zero(self: @Team) -> bool {
        !Self::is_zero(self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::contract_address_const;

    fn sample_team() -> Team {
        Team { id: contract_address_const::<0xAAA>(), max_size: 3 }
    }

    #[test]
    fn test_is_full_true() {
        let team = sample_team();
        assert(TeamImpl::is_full(@team, 3), 'Should be full');
    }

    #[test]
    fn test_is_full_false() {
        let team = sample_team();
        assert(!TeamImpl::is_full(@team, 2), 'Should not be full');
    }

    #[test]
    fn test_zero_team() {
        let team = ZeroableTeamTrait::zero();
        assert(ZeroableTeamTrait::is_zero(@team), 'Zero team check');
        assert(!ZeroableTeamTrait::is_non_zero(@team), 'Non-zero team check');
    }
}
