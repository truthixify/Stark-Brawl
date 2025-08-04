use core::cmp::min;
use core::num::traits::zero::Zero;
use starknet::{ContractAddress, contract_address_const};

pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct LeaderboardEntry {
    #[key]
    pub player_id: ContractAddress,
    pub kills: u32,
    pub deaths: u32,
}

#[generate_trait]
pub trait ILeaderboardEntry {
    fn kdr(self: @LeaderboardEntry) -> u32;
    fn increment_kills(ref self: LeaderboardEntry, amount: u32);
    fn increment_deaths(ref self: LeaderboardEntry, amount: u32);
}

pub impl LeaderboardEntryImpl of ILeaderboardEntry {
    #[inline(always)]
    fn kdr(self: @LeaderboardEntry) -> u32 {
        if *self.deaths == 0_u32 {
            *self.kills * 1000_u32 // Avoid division by zero, treat as high KDR
        } else {
            (*self.kills * 1000_u32) / *self.deaths
        }
    }

    #[inline(always)]
    fn increment_kills(ref self: LeaderboardEntry, amount: u32) {
        assert(amount > 0, 'Amount must be positive');
        self.kills = min(self.kills + amount, 1000);
    }

    #[inline(always)]
    fn increment_deaths(ref self: LeaderboardEntry, amount: u32) {
        assert(amount > 0, 'Amount must be positive');
        self.deaths = min(self.deaths + amount, 1000);
    }
}

pub impl ZeroableLeaderboardEntry of Zero<LeaderboardEntry> {
    #[inline(always)]
    fn zero() -> LeaderboardEntry {
        LeaderboardEntry { player_id: ZERO_ADDRESS(), kills: 0_u32, deaths: 0_u32 }
    }

    #[inline(always)]
    fn is_zero(self: @LeaderboardEntry) -> bool {
        *self.player_id == ZERO_ADDRESS()
    }

    #[inline(always)]
    fn is_non_zero(self: @LeaderboardEntry) -> bool {
        !Self::is_zero(self)
    }
}


#[cfg(test)]
mod tests {
    use starknet::contract_address_const;
    use super::{ILeaderboardEntry, LeaderboardEntry};

    #[test]
    fn test_kdr_normal_case() {
        let entry = LeaderboardEntry {
            player_id: contract_address_const::<0x1>(), kills: 10, deaths: 2,
        };
        assert(entry.kdr() == 5000, 'KDR should be 5000');
    }

    #[test]
    fn test_kdr_zero_deaths() {
        let entry = LeaderboardEntry {
            player_id: contract_address_const::<0x2>(), kills: 25, deaths: 0,
        };
        assert(entry.kdr() == 25000, 'KDR should be 25000');
    }

    #[test]
    fn test_increment_kills() {
        let mut entry = LeaderboardEntry {
            player_id: contract_address_const::<0x3>(), kills: 10, deaths: 2,
        };
        entry.increment_kills(5);
        assert(entry.kills == 15, 'Kills should be 15');
        assert(entry.kdr() == 7500, 'KDR should be 7500');
    }

    #[test]
    fn test_increment_deaths() {
        let mut entry = LeaderboardEntry {
            player_id: contract_address_const::<0x4>(), kills: 10, deaths: 2,
        };
        entry.increment_deaths(3);
        assert(entry.deaths == 5, 'Deaths should be 5');
        assert(entry.kdr() == 2000, 'KDR should be 2000');
    }

    #[test]
    #[should_panic(expected: ('Amount must be positive',))]
    fn test_increment_kills_zero() {
        let mut entry = LeaderboardEntry {
            player_id: contract_address_const::<0x5>(), kills: 10, deaths: 2,
        };
        entry.increment_kills(0);
    }

    #[test]
    #[should_panic(expected: ('Amount must be positive',))]
    fn test_increment_deaths_zero() {
        let mut entry = LeaderboardEntry {
            player_id: contract_address_const::<0x6>(), kills: 10, deaths: 2,
        };
        entry.increment_deaths(0);
    }
}
