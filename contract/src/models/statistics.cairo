use core::num::traits::zero::Zero;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Statistics {
    #[key]
    pub player_id: felt252,
    pub matches_played: u8,
    pub wins: u8,
    pub defeats: u8,
}

#[generate_trait]
pub impl StatisticsImpl of StatisticsTrait {
    #[inline(always)]
    fn increment_matches_played(ref self: Statistics) {
        self.matches_played += 1;
    }

    #[inline(always)]
    fn increment_wins(ref self: Statistics) {
        self.wins += 1;
    }

    #[inline(always)]
    fn increment_defeats(ref self: Statistics) {
        self.defeats += 1;
    }

    #[inline(always)]
    fn get_win_rate(self: @Statistics) -> felt252 {
        if *self.matches_played == 0 {
            return 0;
        }
        let matches: u32 = (*self.matches_played).into();
        let wins: u32 = (*self.wins).into();
        let rate = (wins * 100) / matches;
        rate.into()
    }
}

pub impl ZeroableStatistics of Zero<Statistics> {
    #[inline(always)]
    fn zero() -> Statistics {
        Statistics { player_id: '0', matches_played: 0, wins: 0, defeats: 0 }
    }

    #[inline(always)]
    fn is_zero(self: @Statistics) -> bool {
        *self.matches_played == 0 && *self.wins == 0 && *self.defeats == 0
    }

    #[inline(always)]
    fn is_non_zero(self: @Statistics) -> bool {
        !self.is_zero()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_increment_all() {
        let mut s = Statistics { player_id: '1', matches_played: 0, wins: 0, defeats: 0 };

        StatisticsImpl::increment_matches_played(ref s);
        StatisticsImpl::increment_wins(ref s);
        StatisticsImpl::increment_defeats(ref s);

        assert(s.matches_played == 1, 'Match count');
        assert(s.wins == 1, 'Wins');
        assert(s.defeats == 1, 'Defeats');
    }

    #[test]
    fn test_win_rate() {
        let s = Statistics { player_id: '1', matches_played: 2, wins: 1, defeats: 1 };

        let rate = StatisticsImpl::get_win_rate(@s);
        assert(rate == 50, 'Win rate should be 50');
    }

    #[test]
    fn test_zero_check() {
        let zero = ZeroableStatistics::zero();
        assert(ZeroableStatistics::is_zero(@zero), 'Should be zero');
        assert(!ZeroableStatistics::is_non_zero(@zero), 'Should not be non-zero');

        let s = Statistics { player_id: '1', matches_played: 1, wins: 0, defeats: 1 };

        assert(!ZeroableStatistics::is_zero(@s), 'Should not be zero');
        assert(ZeroableStatistics::is_non_zero(@s), 'Should be non-zero');
    }
}
