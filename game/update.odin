package game

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

update :: proc() {
	using rl

	KEY_RECOMPILE :: rl.KeyboardKey.R

	dt := rl.GetFrameTime()

	w := f32(GetScreenWidth())
	h := f32(GetScreenHeight())

	g_mem.camera.offset = {w, h} / 2


	if IsKeyPressed(.SEMICOLON) {
		g_mem.show_debug_overlay ~= true
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

}
