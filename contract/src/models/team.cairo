
struct Team {
    id: felt,
    members: felt*  

func initialize_team{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    id: felt
) -> (team: Team) {
    alloc_locals;
    let (empty_members: felt*) = alloc(); // Allocate space for the member list

    let team = Team(id=id, members=empty_members);
    
    return (team=team);
}

func add_member{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    team: Team, character_id: felt
) -> (updated_team: Team) {
    alloc_locals;

    let members_len = array_len(team.members);
    
    let mut i = 0;
    loop {
        if i == members_len {
            break;
        }
        if team.members[i] == character_id {
            return (updated_team=team);
        }
        i = i + 1;
    }

    let (new_arr: felt*) = alloc();

    let mut j = 0;
    loop {
        if j == members_len {
            break;
        }
        new_arr[j] = team.members[j];
        j = j + 1;
    }

    new_arr[members_len] = character_id;

    let updated_team = Team(id=team.id, members=new_arr);
    return (updated_team=updated_team);
}

func remove_member{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    team: Team, character_id: felt
) -> (updated_team: Team) {
    alloc_locals;

    let members_len = array_len(team.members);
    let (new_arr: felt*) = alloc();
    let mut new_len = 0;

    let mut i = 0;
    loop {
        if i == members_len {
            break;
        }
        if team.members[i] != character_id {
            new_arr[new_len] = team.members[i];
            new_len = new_len + 1;
        }
        i = i + 1;
    }

    let updated_team = Team(id=team.id, members=new_arr);
    return (updated_team=updated_team);
}

func is_team_alive{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    team: Team
) -> (alive: felt) {
    let members_len = array_len(team.members);
    return (alive=members_len > 0);
}
