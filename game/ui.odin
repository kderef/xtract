package game

import "core:math"
import rl "vendor:raylib"


DEFAULT_CAMERA_ZOOM :: 0.5

ui_draw :: proc() {
	toolbar_show(&g_mem.toolbar)
}

ui_text :: proc(text: cstring, pos: Vec2, size: f32, color: Color) {
	SPACING :: 0.0
	rl.DrawTextEx(g_mem.assets.font1_reg, text, pos, size, SPACING, color)
}
