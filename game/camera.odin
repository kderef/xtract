package game

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

CAMERA_ZOOM: [2]f32 : {0.5, 10.0}

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PIXEL_WINDOW_HEIGHT}
}

camera_movement :: proc() {
	using rl

	MOUSE_MOVE_SCALE :: 1.0
	KEYS_MOVE_SPEED :: 10.0

	if IsKeyPressed(.ZERO) {
		g_mem.camera.target = {}
		return
	}

	move: Vec2

	// Move by keyboard
	dt := GetFrameTime()

	if IsKeyDown(.UP) || IsKeyDown(.W) {
		move.y -= KEYS_MOVE_SPEED
	}
	if IsKeyDown(.DOWN) || IsKeyDown(.S) {
		move.y += KEYS_MOVE_SPEED
	}
	if IsKeyDown(.LEFT) || IsKeyDown(.A) {
		move.x -= KEYS_MOVE_SPEED
	}
	if IsKeyDown(.RIGHT) || IsKeyDown(.D) {
		move.x += KEYS_MOVE_SPEED
	}


	// Move by mouse
	move_camera := IsMouseButtonDown(.LEFT)
	if move_camera {
		mouse_delta := GetMouseDelta()
		if mouse_delta != {} {
			move = -mouse_delta * MOUSE_MOVE_SCALE
		}
	}


	// Zoom
	mousewheel := math.sign(GetMouseWheelMove())

	ZOOM_STEP :: 0.5
	ZOOM_MIN :: 1.0
	ZOOM_MAX :: 100.0

	zoom_delta: f32

	if mousewheel > 0 || IsKeyPressed(.EQUAL) {
		zoom_delta = ZOOM_STEP
	} else if mousewheel < 0 || IsKeyPressed(.MINUS) {
		zoom_delta = -ZOOM_STEP
	}

	if zoom_delta != 0.0 {
		g_mem.camera.zoom = math.clamp(
			g_mem.camera.zoom + zoom_delta,
			CAMERA_ZOOM[0],
			CAMERA_ZOOM[1],
		)
	}


	// move = linalg.normalize0(move)
	g_mem.camera.target += move * dt * 100
}
