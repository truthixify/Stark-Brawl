#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct MapTile {
    #[key]
    pub x: u8,
    #[key]
    pub y: u8,
    pub tile_type: felt252
}

#[generate_trait]
pub impl MapTileImpl of MapTileTrait {
    fn new(x: u8, y: u8, tile_type: felt252) -> MapTile {
        assert(tile_type == 'path' || tile_type == 'build_zone' || tile_type == 'obstacle', 'INVALID_TILE_TYPE');
        MapTile { x, y, tile_type }
    }

    fn is_walkable(self: @MapTile) -> bool {
        *self.tile_type == 'path' || *self.tile_type == 'build_zone'
    }

    fn can_place_tower(self: @MapTile) -> bool {
        *self.tile_type == 'build_zone'
    }

}
