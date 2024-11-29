package game

import "core:fmt"
import rl "vendor:raylib"

BG :: rl.Color{}


draw_grid :: proc(target: Vec2, spacing: i32, radius: i32) {
	using rl

	THICK :: 2.0
	COLOR :: rl.DARKGRAY

	start_x := f32((i32(target.x) - radius) / spacing * spacing)
	end_x := f32((i32(target.x) + radius) / spacing * spacing)
	start_y := f32((i32(target.y) - radius) / spacing * spacing)
	end_y := f32((i32(target.y) + radius) / spacing * spacing)


	for x := i32(start_x); x <= i32(end_x); x += spacing {
		xf := f32(x)
		DrawLineEx({xf, start_y}, {xf, end_y}, THICK, COLOR)
	}
	for y := i32(start_y); y <= i32(end_y); y += spacing {
		yf := f32(y)
		DrawLineEx({start_x, yf}, {end_x, yf}, THICK, COLOR)
	}
}

draw_background :: proc() {
	using rl
	draw_grid(g_mem.camera.target, 100, i32(0.5 * g_mem.camera.zoom))
}

draw_debug_overlay :: proc() {
	using rl

	w := GetScreenWidth()
	h := GetScreenHeight()

	cx := w / 2
	cy := h / 2

	DrawFPS(w - 100, 5)
	ui_text("Raylib version " + rl.VERSION, {f32(w) - 220, 25}, 18, BLUE)

	ui_text(fmt.ctprintf("camera: %#v", g_mem.camera), {5, 5}, 18, WHITE)

	ui_text("Press ; (semicolon) to close", {f32(w) - 380, f32(h) - 30}, 20, YELLOW)

	// Draw line through middle
	DrawLine(cx, 0, cx, h, GREEN)
	DrawLine(0, cy, w, cy, GREEN)
}

draw :: proc() {
	using rl

	BeginDrawing()


	ClearBackground(BLACK)

	BeginMode2D(g_mem.camera)
	{

		// 1. Background
		draw_background()

		// 2. Draw camera 
		// DrawRectangleV(g_mem.camera.target, {10, 20}, WHITE)
		// DrawRectangleV({20, 20}, {10, 10}, RED)
		// DrawRectangleV({-30, -20}, {10, 10}, GREEN)
	}
	EndMode2D()

	BeginMode2D(ui_camera())
	// Note: main_hot_reload.odin clears the temp allocator at end of frame.
	EndMode2D()

	// Draw all the other stuff ON TOP
	ui_draw()

	if g_mem.show_debug_overlay do draw_debug_overlay()

	EndDrawing()
}
