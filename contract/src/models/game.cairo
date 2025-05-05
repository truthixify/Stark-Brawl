use starknet::ContractAddress;

#[derive(Drop, Serde, Copy, Clone)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u32,
    pub team_ids: Span<(ContractAddress, bool)>, // (player, is_alive)
    pub status: GameStatus,
    pub winner_id: Option<ContractAddress>,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum GameStatus {
    NotStarted,
    InProgress,
    Finished,
}

#[generate_trait]
pub impl GameImpl of GameTrait {
    fn new(id: u32, team_ids: Span<(ContractAddress, bool)>) -> Game {
        Game { id, team_ids, status: GameStatus::NotStarted, winner_id: Option::None }
    }

    fn end_game(ref self: Game) -> Game {
        assert!(
            self.status == GameStatus::InProgress,
            "[end_game] - Game should be `In progress` status, current status `{}`",
            self.status,
        );
        let mut teams_alive = 0;
        let mut winner = Option::None;

        for (team_id, is_alive) in self.team_ids {
            if *is_alive {
                teams_alive += 1;
                winner = Option::Some(*team_id);
            }
        };

        if teams_alive == 1 {
            self.status = GameStatus::Finished;
            self.winner_id = winner;
        } else {
            // This means that there is more than 1 team thats alive so, the game should'nt be ended
            panic!(
                "[end_game] - Game cannot be ended because there is {} teams alive", teams_alive,
            );
        }
        self
    }
}

impl GameStatusIntoU8 of Into<GameStatus, u8> {
    fn into(self: GameStatus) -> u8 {
        match self {
            GameStatus::NotStarted => { 0 },
            GameStatus::InProgress => { 1 },
            GameStatus::Finished => { 2 },
        }
    }
}

pub impl GameStatusDisplay of core::fmt::Display<GameStatus> {
    fn fmt(self: @GameStatus, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            GameStatus::InProgress => "Not Started",
            GameStatus::NotStarted => "In Progress",
            GameStatus::Finished => "Finished",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
