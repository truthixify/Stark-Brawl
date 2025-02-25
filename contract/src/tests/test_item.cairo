func test_initialize_item() -> ():
    let item = initialize_item(1, 'Health Potion', 'Restores 50 HP');
    assert(item.id == 1, 'Item ID should be 1');
    assert(item.name == 'Health Potion', 'Item name should be Health Potion');
    assert(item.effect == 'Restores 50 HP', 'Item effect should be Restores 50 HP');
    return ();


func test_use_item() -> ():
    let item = initialize_item(1, 'Health Potion', 'Restores 50 HP');
    let target = initialize_character(2, 'Hero', 50, 20);
    item.use_item(target.id);
    assert(target.health == 100, 'Target health should be 100 after using Health Potion');
    return ();


func test_is_consumable() -> ():
    let item = initialize_item(1, 'Health Potion', 'Restores 50 HP');
    assert(item.is_consumable() == 1, 'Health Potion should be consumable');

    let permanent_item = initialize_item(2, 'Armor', 'Increases defense');
    assert(permanent_item.is_consumable() == 0, 'Armor should be permanent');
    return ();
