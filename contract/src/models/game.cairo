#[derive(Drop, Serde, Copy, Clone)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u32,
    pub team_ids: Span<u32>,
    pub status: GameStatus,
    pub winner_id: Option<felt252>,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum GameStatus {
    NotStarted,
    InProgress,
    Finished,
}

#[generate_trait]
pub impl GameImpl of GameTrait {
    // The winner_id is a team? So i think that we can change the type of winer_id to Option<u32>
    fn new(id: u32, team_ids: Span<u32>, status: GameStatus, winner_id: Option<felt252>) -> Game {
        Game { id, team_ids, status, winner_id }
    }

    // TODO: Where should i get the team status, is there the `Team` model missing?
    // Team { #[key] game_id: u32, #[key] id: u32, players: Span<ContractAddress>, is_alive: bool }
    // So end_game logic will be some like
    fn end_game(ref self: Game) -> Game {
        self.status = GameStatus::Finished;
        self.winner_id = Option::Some('winner');
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
