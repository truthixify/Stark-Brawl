// Test for inventory initialization
func test_initialize_inventory() -> ():
    let inventory = initialize_inventory(1);
    assert(inventory.player_id == 1, 'Inventory should be initialized for player 1');
    assert(inventory.items.len() == 0, 'Inventory should be initialized as empty');
    return ();

// Test for adding an item
func test_add_item() -> ():
    let inventory = initialize_inventory(1);
    inventory.add_item(1001);
    assert(inventory.items.len() == 1, 'Inventory should have 1 item after adding');
    inventory.add_item(1002);
    assert(inventory.items.len() == 2, 'Inventory should have 2 items after adding another');
    return ();

// Test for duplicate items
func test_add_duplicate_item() -> ():
    let inventory = initialize_inventory(1);
    inventory.add_item(1001);
    inventory.add_item(1001); // Trying to add the same item again
    assert(inventory.items.len() == 1, 'Duplicate items should not be allowed');
    return ();

// Test for removing an item
func test_remove_item() -> ():
    let inventory = initialize_inventory(1);
    inventory.add_item(1001);
    inventory.remove_item(1001);
    assert(inventory.items.len() == 0, 'Inventory should be empty after removing the item');
    return ();

// Test for checking item existence
func test_has_item() -> ():
    let inventory = initialize_inventory(1);
    inventory.add_item(1001);
    assert(inventory.has_item(1001) == 1, 'Inventory should contain item 1001');
    assert(inventory.has_item(9999) == 0, 'Inventory should not contain item 9999');
    return ();