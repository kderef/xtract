package game

import "core:math"
import rl "vendor:raylib"

Toolbar :: struct {
	slots: u32,
}

toolbar_new :: proc(slots: u32) -> (t: Toolbar) {
	t.slots = slots

	return
}


toolbar_draw_slot :: proc(slot: Rect, border_w: f32, border_color: Color) {
	using rl
	// Draw the outline
	DrawRectangleRec(slot, BLACK)
	DrawRectangleLinesEx(slot, border_w, border_color)

	// Draw the texture
}

toolbar_show :: proc(toolbar: ^Toolbar) {
	using rl

	BORDER_W :: 1.5
	BORDER_COLOR :: rl.GRAY
	BORDER_COLOR_HOV :: rl.WHITE

	mouse_pos := GetMousePosition()

	w := GetScreenWidth()
	h := GetScreenHeight()

	slot_size := f32(math.clamp(w / 15, 60, 80))

	cx := f32(w) / 2

	toolbar_w := (slot_size + BORDER_W) * f32(toolbar.slots)
	start_x: f32 = cx - toolbar_w / 2
	y: f32 = f32(h) - slot_size - 5.0

	for x := start_x; x < cx + toolbar_w / 2; x += slot_size + BORDER_W {
		// Draw the slot
		slot := Rect{x, y, slot_size, slot_size}
		color := BORDER_COLOR
		border := BORDER_W

		// The slot is hovered
		if CheckCollisionPointRec(mouse_pos, slot) {
			color = BORDER_COLOR_HOV
			border += 2
			// TODO: set mouse cursor
		}

		toolbar_draw_slot(slot, BORDER_W, color)
	}
}
