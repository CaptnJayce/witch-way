package game

import "core:fmt"
import rl "vendor:raylib"

draw_grid :: proc() {
	mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), c)

	total_length: i32 = TILE_GRID_COLUMNS * TILE_SIZE
	total_height: i32 = TILE_GRID_ROWS * TILE_SIZE

	// origin coords
	offset_x: i32 = 0
	offset_y: i32 = 0

	draw_at_x: i32 = offset_x
	draw_at_y: i32 = offset_y

	mouse_grid_x := mp.x / TILE_SIZE
	mouse_grid_y := mp.y / TILE_SIZE

	for idx in 0 ..< TOTAL_TILES {
		current_grid_x := (draw_at_x - offset_x) / TILE_SIZE
		current_grid_y := (draw_at_y - offset_y) / TILE_SIZE

		is_highlighted :=
			current_grid_x == i32(mouse_grid_x) &&
			current_grid_y == i32(mouse_grid_y) &&
			mouse_grid_x >= 0 &&
			mouse_grid_x < TILE_GRID_COLUMNS &&
			mouse_grid_y >= 0 &&
			mouse_grid_y < TILE_GRID_ROWS

		if is_highlighted {
			rl.DrawRectangle(
				draw_at_x,
				draw_at_y,
				TILE_SIZE,
				TILE_SIZE,
				rl.Color{255, 255, 255, 128},
			)
		}

		rl.DrawRectangleLines(draw_at_x, draw_at_y, TILE_SIZE, TILE_SIZE, rl.WHITE)

		draw_at_x += TILE_SIZE

		if draw_at_x == (offset_x + (TILE_GRID_COLUMNS * TILE_SIZE)) {
			draw_at_x = offset_x
			draw_at_y += TILE_SIZE
		}
	}
}
