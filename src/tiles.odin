package game

import "core:fmt"
import "core:math/rand"
import "core:time"
import rl "vendor:raylib"

TileFlags :: enum {
	Collidable = 0,
	Modified   = 1,
	Stone      = 2,
	Dirt       = 3,
	Tilled     = 4,
	Prop       = 5,
}
Tile :: struct {
	flags: bit_set[TileFlags;u8],
}
TileMap :: struct {
	width, height: int,
	tiles:         []Tile,
}
tm: TileMap

tile_grid_columns: f32
tile_grid_rows: f32

total_tiles: f32

total_length: f32
total_height: f32

seed_generator :: proc() {
	rl.SetRandomSeed(u32(time.now()._nsec))
	seed = rl.GetRandomValue(0, 1000000)
}

init_tilemap :: proc(level_id: int) {
	rl.SetRandomSeed(u32(seed))

	tm.width = int(current_bounds.width / TILE_SIZE)
	tm.height = int(current_bounds.height / TILE_SIZE)

	tm.tiles = make([]Tile, tm.width * tm.height)

	// initial tiles
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			index := row * tm.width + col
			selected := rl.GetRandomValue(0, 10)

			if selected == 0 {
				tm.tiles[index].flags = {.Stone, .Collidable}
			} else {
				tm.tiles[index].flags = {.Dirt}
			}
		}
	}

	// initial props
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			index := row * tm.width + col
			selected := rl.GetRandomValue(0, 100)

			if .Dirt in tm.tiles[index].flags && selected == 0 {
				tm.tiles[index].flags += {.Prop}
			}
		}
	}
}

collision_rect := rl.Rectangle{}
current_x: i32
current_y: i32

draw_tilemap :: proc() {
	start_col := max(0, int(render_rect.x / TILE_SIZE) - 1)
	end_col := min(tm.width, int((render_rect.x + render_rect.width) / TILE_SIZE) + 1)
	start_row := max(0, int(render_rect.y / TILE_SIZE) - 1)
	end_row := min(tm.height, int((render_rect.y + render_rect.height) / TILE_SIZE) + 1)

	for row in start_row ..< end_row {
		for col in start_col ..< end_col {
			index := row * tm.width + col
			tile := tm.tiles[index]
			tile_x := i32(col * TILE_SIZE)
			tile_y := i32(row * TILE_SIZE)

			if .Tilled in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.DARKBROWN)
			}

			if .Dirt in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.BROWN)

				// use 'seed' to randomly select from sprite sheet
				if .Prop in tile.flags {
					rl.DrawTexture(k.texture, tile_x, tile_y, rl.WHITE)
				}
			}

			if .Stone in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.GRAY)
			}
		}
	}

	mouse_grid_x := int(mouse_rect.x) / TILE_SIZE
	mouse_grid_y := int(mouse_rect.y) / TILE_SIZE

	if mouse_grid_x >= 0 &&
	   mouse_grid_x < tm.width &&
	   mouse_grid_y >= 0 &&
	   mouse_grid_y < tm.height {

		if rl.Vector2Distance({mouse_rect.x, mouse_rect.y}, {p.position.x, p.position.y}) < 50 {
			highlight_x := i32(mouse_grid_x * TILE_SIZE)
			highlight_y := i32(mouse_grid_y * TILE_SIZE)

			rl.DrawRectangleRec(
				rl.Rectangle {
					x = f32(highlight_x),
					y = f32(highlight_y),
					width = TILE_SIZE,
					height = TILE_SIZE,
				},
				rl.ColorAlpha(rl.WHITE, 0.5),
			)

			if rl.IsMouseButtonPressed(.LEFT) {
				index := mouse_grid_y * tm.width + mouse_grid_x

				// very half assed state machine
				if .Dirt in tm.tiles[index].flags && .Prop in tm.tiles[index].flags == false {
					tm.tiles[index].flags = {.Tilled, .Modified}
				}
				if .Prop in tm.tiles[index].flags {
					tm.tiles[index].flags = {.Dirt, .Modified}
					i.slots[0].count += 1
				}
				if .Stone in tm.tiles[index].flags {
					tm.tiles[index].flags = {.Dirt, .Modified}
				}
			}
		}
	}
}

free_current_tiles :: proc() {
	delete(tm.tiles)
	tm = TileMap{}
}
