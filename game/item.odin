package game

import rl "vendor:raylib"

Item :: struct {
	// Basic Information
	pos:   Vec2, // The offset from (0, 0)
	count: u32,
	type:  ItemType,
	// The item data
}

ItemType :: enum {
	None = 0,
	Producer,
}

ItemTextureMap :: [ItemType]rl.Texture

item_map_load :: proc() -> ItemTextureMap {
	return ItemTextureMap{.None = {}, .Producer = {}}
}

item_map_unload :: proc(m: ^ItemTextureMap) {
	for i in 0 ..< len(m) {
		unload(m[ItemType(i)])
	}
}
