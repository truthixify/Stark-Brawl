mod tests {
    use stark_brawl::models::map_tile::{MapTileTrait, MapTileImpl};

    #[test]
    fn test_map_tile_path() {
        let tile = MapTileImpl::new(0, 0, 'path');
        assert(tile.is_walkable(), 'Tile is not walkable');
        assert(!tile.can_place_tower(), 'Tile allow place tower');
    }

    #[test]
    fn test_map_tile_build_zone() {
        let tile = MapTileImpl::new(0, 0, 'build_zone');
        assert(tile.is_walkable(), 'Tile is not walkable');
        assert(tile.can_place_tower(), 'Tile not allow place tower');
    }

    #[test]
    fn test_map_tile_obstacle() {
        let tile = MapTileImpl::new(0, 0, 'obstacle');
        assert(!tile.is_walkable(), 'Tile is walkable');
        assert(!tile.can_place_tower(), 'Tile allow place tower');
    }
}
