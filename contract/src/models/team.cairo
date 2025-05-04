#[derive(Copy, Drop, Serde, Default, Debug, PartialEq)]
pub struct Team {
    #[key]
    pub id: felt252,
    pub members: Array<felt252>,
    pub max_size: u8,
}

pub fn initialize_team(id: felt252, max_size: u8) -> Team {
    assert(max_size > 0, 'Max size must be positive');
    Team { 
        id,
        members: ArrayTrait::new(),
        max_size,
    }
}

pub trait TeamTrait<T> {
    fn add_member(ref self: T, member_id: felt252) -> bool;
    fn remove_member(ref self: T, member_id: felt252) -> bool;
    fn is_full(self: @T) -> bool;
    fn has_member(self: @T, member_id: felt252) -> bool;
    fn is_alive(self: @T) -> bool;
}

pub impl TeamImpl of TeamTrait<Team> {
    fn add_member(ref self: Team, member_id: felt252) -> bool {
        // Check if team is full
        if self.is_full() {
            return false;
        }

        // Check for duplicates
        if self.has_member(member_id) {
            return false;
        }

        // Add member
        self.members.append(member_id);
        true
    }

    fn remove_member(ref self: Team, member_id: felt252) -> bool {
        let mut found = false;
        let mut new_members = ArrayTrait::new();

        // Copy all members except the one to remove
        let mut i = 0;
    loop {
            if i >= self.members.len() {
            break;
            }
            let current = *self.members.at(i);
            if current != member_id {
                new_members.append(current);
            } else {
                found = true;
            }
            i += 1;
        };

        if found {
            self.members = new_members;
        }
        found
    }

    fn is_full(self: @T) -> bool {
        self.members.len() >= (*self.max_size).into()
    }

    fn has_member(self: @T, member_id: felt252) -> bool {
    let mut i = 0;
    loop {
            if i >= self.members.len() {
                break false;
            }
            if *self.members.at(i) == member_id {
                break true;
            }
            i += 1;
        }
    }

    fn is_alive(self: @T) -> bool {
        self.members.len() > 0
    }
}
