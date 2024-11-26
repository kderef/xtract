// This file is compiled as part of the `odin.dll` file. It contains the
// procs that `game_hot_reload.exe` will call, such as:
//
// game_init: Sets up the game state
// game_update: Run once per frame
// game_shutdown: Shuts down game and frees memory
// game_memory: Run just before a hot reload, so game.exe has a pointer to the
//		game's memory.
// game_hot_reloaded: Run after a hot reload so that the `g_mem` global variable
//		can be set to whatever pointer it was in the old DLL.
//
// Note: When compiled as part of the release executable this whole package is imported as a normal
// odin package instead of a DLL.

package game

import "core:c/libc"
import "core:fmt"
import "core:io"
import "core:math/linalg"
import rl "vendor:raylib"

// Some types
Vec2 :: rl.Vector2
Vec3 :: rl.Vector3
Rect :: rl.Rectangle
Color :: rl.Color

SCRIPT_EXT :: "bat" when ODIN_OS == .Windows else "sh"
PIXEL_WINDOW_HEIGHT :: 180

run_cmd :: libc.system

current_cursor: rl.MouseCursor = .DEFAULT


// The Memory
Game_Memory :: struct {
	camera:             rl.Camera2D,
	show_debug_overlay: bool,
}

g_mem: ^Game_Memory


// Exported functions
@(export)
game_update :: proc() -> bool {
	update()
	draw()
	return !rl.WindowShouldClose()
}

@(export)
game_init_window :: proc() {
	flags: rl.ConfigFlags : {.WINDOW_RESIZABLE, .WINDOW_HIGHDPI}
	rl.SetConfigFlags(flags)
	rl.InitWindow(600, 420, "XTract")
	rl.SetTargetFPS(240)
	rl.SetExitKey(.KEY_NULL)
}

@(export)
game_init :: proc() {
	g_mem = new(Game_Memory)

	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	g_mem^ = Game_Memory {
		camera = {zoom = h / PIXEL_WINDOW_HEIGHT, target = {}, offset = {w / 2, h / 2}},
		show_debug_overlay = ODIN_DEBUG,
	}

	game_hot_reloaded(g_mem)
}

@(export)
game_shutdown :: proc() {
	free(g_mem)
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
}

@(export)
game_memory :: proc() -> rawptr {
	return g_mem
}

@(export)
game_memory_size :: proc() -> int {
	return size_of(Game_Memory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^Game_Memory)(mem)
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
