package game

import rl "vendor:raylib"

AssetResult :: enum {
	Ok = 0,
	FontNotFound,
}

Assets :: struct {
	font1_reg: rl.Font,
	items:     ItemTextureMap,
}

assets_load :: proc(using assets: ^Assets) -> AssetResult {
	font1_reg = rl.LoadFontEx("ttf/VCR_MONO.ttf", 1000, nil, 0)
	items = item_map_load()

	return AssetResult.Ok
}

// Unload resource
@(private)
unload :: proc {
	rl.UnloadSound,
	rl.UnloadFont,
	rl.UnloadTexture,
	rl.UnloadImage,
	rl.UnloadMesh,
	item_map_unload,
}

assets_unload :: proc(using assets: ^Assets) {
	using rl
	unload(font1_reg)
}
