struct Inventory {
    player_id: felt,
    items: felt*,  
    item_count: felt,  
}

func initialize_inventory(player_id: felt) -> (inventory: Inventory) {
    let items: felt* = alloc();
    let inventory = Inventory(player_id, items, 0);
    return (inventory,);
}

func add_item{range_check_ptr}(inventory: Inventory*, item_id: felt) -> () {
    let exists = has_item(inventory, item_id);
    assert exists = 0;

    let item_count = inventory.item_count;
    assert [inventory.items + item_count] = item_id;
    inventory.item_count = item_count + 1;
    return ();
}

func remove_item{range_check_ptr}(inventory: Inventory*, item_id: felt) -> () {
    let item_count = inventory.item_count;
    let items = inventory.items;

    let index = 0;
    while index < item_count {
        let current_item = [items + index];
        if current_item = item_id {
            break;
        }
        index = index + 1;
    }

    if index < item_count {
        let shift_index = index;
        while shift_index < item_count - 1 {
            [items + shift_index] = [items + shift_index + 1];
            shift_index = shift_index + 1;
        }
        inventory.item_count = item_count - 1;
    }
    return ();
}

func has_item{range_check_ptr}(inventory: Inventory*, item_id: felt) -> (result: felt) {
    let item_count = inventory.item_count;
    let items = inventory.items;

    let index = 0;
    while index < item_count {
        let current_item = [items + index];
        if current_item = item_id {
            return (1,);
        }
        index = index + 1;
    }
    return (0,);
}