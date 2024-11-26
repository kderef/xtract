package game

import rl "vendor:raylib"

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PIXEL_WINDOW_HEIGHT}
}

camera_movement :: proc() {
	using rl

	move_camera := IsMouseButtonDown(.LEFT)
	if !move_camera do return

	mouse_delta := GetMouseDelta()
	if mouse_delta == {} do return

	move := -mouse_delta / 2

	g_mem.camera.target += move
}
