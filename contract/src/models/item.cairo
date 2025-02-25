struct Item {
    id: felt,
    name: felt,
    effect: felt,
    is_consumable: felt,
}


func initialize_item(id: felt, name: felt, effect: felt) -> (item: Item) {
    let is_consumable = 1;
    let item = Item(id, name, effect, is_consumable);
    return (item,);
}


func use_item(item: Item, target_id: felt) -> () {
    // Placeholder logic for applying the effect to the target
    return ();
}

func is_consumable(item: Item) -> (result: felt) {
    return (item.is_consumable,);
}