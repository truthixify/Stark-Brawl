#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Statistics {
    #[key]
    pub player_id: felt252,
    pub matches_played: u8,
    pub wins: u8,
    pub defeats: u8,
}

pub fn initialize_statistics(player_id: felt252) -> Statistics {
    Statistics {
        player_id,
        matches_played: 0,
        wins: 0,
        defeats: 0,
    }
}

pub trait StatisticsTrait<T> {
    fn increment_matches_played(ref self: T);
    fn increment_wins(ref self: T);
    fn increment_defeats(ref self: T);
    fn get_win_rate(self: @T) -> felt252;
}

pub impl StatisticsImpl of StatisticsTrait<Statistics> {
    fn increment_matches_played(ref self: Statistics) {
        self.matches_played += 1;
    }

    fn increment_wins(ref self: Statistics) {
        self.wins += 1;
    }

    fn increment_defeats(ref self: Statistics) {
        self.defeats += 1;
    }

    fn get_win_rate(self: @Statistics) -> felt252 {
        if (*self.matches_played == 0) {
            return 0;
        }

        let win_rate = (*self.wins) * 100 / (*self.matches_played);
        
        win_rate.into()
    }
}