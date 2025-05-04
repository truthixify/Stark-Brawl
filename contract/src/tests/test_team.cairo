use stark_brawl::models::team::*;
use super::super::models::team::TeamTrait;

fn init_default() -> Team {
    let id = 1;
    let max_size = 3;
    let team = initialize_team(id, max_size);

    assert(team.id == id, 'Team ID should match');
    assert(team.max_size == max_size, 'Max size should match');
    assert(team.members.len() == 0, 'Team should start empty');

    team
}

#[test]
fn test_initialize_team() {
    let _ = init_default();
}

#[test]
fn test_add_member() {
    let mut team = init_default();
    
    // Add first member
    let result = team.add_member(1);
    assert(result == true, 'Should add first member');
    assert(team.members.len() == 1, 'Should have 1 member');
    
    // Add second member
    let result = team.add_member(2);
    assert(result == true, 'Should add second member');
    assert(team.members.len() == 2, 'Should have 2 members');
}

#[test]
fn test_add_duplicate_member() {
    let mut team = init_default();
    
    // Add member
    let result = team.add_member(1);
    assert(result == true, 'Should add member');
    
    // Try to add same member again
    let result = team.add_member(1);
    assert(result == false, 'Should not add duplicate');
    assert(team.members.len() == 1, 'Should still have 1 member');
}

#[test]
fn test_team_full() {
    let mut team = init_default(); // max_size = 3
    
    // Add 3 members
    let result1 = team.add_member(1);
    let result2 = team.add_member(2);
    let result3 = team.add_member(3);
    assert(result1 && result2 && result3, 'Should add all 3 members');
    
    // Try to add 4th member
    let result4 = team.add_member(4);
    assert(result4 == false, 'Should not add 4th member');
    assert(team.members.len() == 3, 'Should still have 3 members');
}

#[test]
fn test_remove_member() {
    let mut team = init_default();
    
    // Add members
    team.add_member(1);
    team.add_member(2);
    
    // Remove existing member
    let result = team.remove_member(1);
    assert(result == true, 'Should remove existing member');
    assert(team.members.len() == 1, 'Should have 1 member left');
    assert(!team.has_member(1), 'Should not have removed member');
}

#[test]
fn test_remove_nonexistent_member() {
    let mut team = init_default();
    
    // Add member
    team.add_member(1);
    
    // Try to remove nonexistent member
    let result = team.remove_member(999);
    assert(result == false, 'Should not remove nonexistent');
    assert(team.members.len() == 1, 'Should still have 1 member');
}

#[test]
fn test_is_alive() {
    let mut team = init_default();
    
    // Empty team should not be alive
    assert(!team.is_alive(), 'Empty team should not be alive');
    
    // Team with members should be alive
    team.add_member(1);
    assert(team.is_alive(), 'Team with members should be alive');
    
    // Team should not be alive after removing all members
    team.remove_member(1);
    assert(!team.is_alive(), 'Empty team should not be alive');
}

#[test]
fn test_has_member() {
    let mut team = init_default();
    
    // Add member
    team.add_member(1);
    
    // Check for existing member
    assert(team.has_member(1), 'Should have member 1');
    
    // Check for nonexistent member
    assert(!team.has_member(999), 'Should not have member 999');
}