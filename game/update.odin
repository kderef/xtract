package game

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

update :: proc() {
	using rl

	KEY_RECOMPILE :: rl.KeyboardKey.R
	input: Vector2
	mousewheel := math.sign(GetMouseWheelMove())

	w := f32(GetScreenWidth())
	h := f32(GetScreenHeight())

	g_mem.camera.offset = {w, h} / 2

	if IsKeyDown(.UP) || IsKeyDown(.W) {
		input.y -= 1
	}
	if IsKeyDown(.DOWN) || IsKeyDown(.S) {
		input.y += 1
	}
	if IsKeyDown(.LEFT) || IsKeyDown(.A) {
		input.x -= 1
	}
	if IsKeyDown(.RIGHT) || IsKeyDown(.D) {
		input.x += 1
	}

	if IsKeyPressed(.SEMICOLON) {
		g_mem.show_debug_overlay ~= true
	}

	ZOOM_STEP :: 0.5
	ZOOM_MIN :: 1.0
	ZOOM_MAX :: 100.0

	zoom_delta: f32 = 0.0

	if mousewheel > 0 || IsKeyPressed(.EQUAL) {
		zoom_delta = ZOOM_STEP
	} else if mousewheel < 0 || IsKeyPressed(.MINUS) {
		zoom_delta = -ZOOM_STEP
	}

	if zoom_delta != 0.0 {
		g_mem.camera.zoom = math.clamp(g_mem.camera.zoom + zoom_delta, ZOOM_MIN, ZOOM_MAX)
	}

	camera_movement()


	when ODIN_DEBUG {
		if IsKeyPressed(KEY_RECOMPILE) {
			fmt.println("\n[DEBUG] Hotreloading code...")
			ok := run_cmd("cd .. ; ./build_hot_reload." + SCRIPT_EXT + "; cd bin")

			fmt.print("[DEBUG] ")
			fmt.println("Ok!" if ok == 0 else "Failed!")
			fmt.println()
		}
	}

	input = linalg.normalize0(input)
	g_mem.camera.target += input * GetFrameTime() * 100
}
