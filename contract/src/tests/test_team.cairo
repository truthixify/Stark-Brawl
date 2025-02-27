// Test for team initialization
func test_initialize_team() -> ():
    let team = initialize_team(1);
    assert(team.members.len() == 0, 'Team should be initialized with an empty members list');
    return ();

// Test for adding members
func test_add_member() -> ():
    let team = initialize_team(1);
    team.add_member(1);
    assert(team.members.len() == 1, 'Team should have 1 member after adding');
    team.add_member(2);
    assert(team.members.len() == 2, 'Team should have 2 members after adding another');
    return ();

// Test for duplicate members
func test_add_duplicate_member() -> ():
    let team = initialize_team(1);
    team.add_member(1);
    team.add_member(1); // Try adding the same member again
    assert(team.members.len() == 1, 'Duplicate members should not be allowed');
    return ();

// Test for removing members
func test_remove_member() -> ():
    let team = initialize_team(1);
    team.add_member(1);
    team.remove_member(1);
    assert(team.members.len() == 0, 'Team should be empty after removing the only member');
    return ();

// Test for checking if team is alive
func test_is_team_alive() -> ():
    let team = initialize_team(1);
    team.add_member(1);
    assert(team.is_team_alive() == 1, 'Team should be alive if at least one member is alive');
    team.remove_member(1);
    assert(team.is_team_alive() == 0, 'Team should be dead if no members are alive');
    return ();