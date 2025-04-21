package game

import "core:math/rand"
import rl "vendor:raylib"

TileFlags :: enum {
	Collidable = 0,
	Stone      = 1,
	Dirt       = 2,
}
Tile :: struct {
	flags:    bit_set[TileFlags;u8],
	rect:     rl.Rectangle,
	modified: bool,
	row, col: int,
	id:       int,
}
TileMap :: struct {
	width, height: int,
	tiles:         [][]Tile,
}
tm: TileMap

tile_grid_columns: f32
tile_grid_rows: f32

total_tiles: f32

total_length: f32
total_height: f32

seed: u32 = 4444
init_tilemap :: proc(level_id: int) {
	rl.SetRandomSeed(seed)

	tm.width = int(current_bounds.width / TILE_SIZE)
	tm.height = int(current_bounds.height / TILE_SIZE)

	tm.tiles = make([][]Tile, tm.height)

	for row in 0 ..< tm.height {
		tm.tiles[row] = make([]Tile, tm.width)

		for col in 0 ..< tm.width {
			tile_x := i32(col * TILE_SIZE)
			tile_y := i32(row * TILE_SIZE)

			selected := rl.GetRandomValue(0, 4)

			if selected == 0 {
				tm.tiles[row][col] = Tile {
					flags = {.Stone, .Collidable},
					rect = {
						x = f32(tile_x),
						y = f32(tile_y),
						width = TILE_SIZE,
						height = TILE_SIZE,
					},
					id = level_id,
				}
			}
		}
	}
}

collision_rect := rl.Rectangle{}
current_x: i32
current_y: i32

draw_tilemap :: proc() {
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			tile_x := i32(col * TILE_SIZE)
			tile_y := i32(row * TILE_SIZE)

			tile := tm.tiles[row][col]

			if .Dirt in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.BROWN)
			}
			if .Stone in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.GRAY)
			}

			// rl.DrawRectangleLines(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.WHITE)
		}
	}

	mouse_grid_x := int(mouse_rect.x) / TILE_SIZE
	mouse_grid_y := int(mouse_rect.y) / TILE_SIZE

	if mouse_grid_x >= 0 &&
	   mouse_grid_x < tm.width &&
	   mouse_grid_y >= 0 &&
	   mouse_grid_y < tm.height {

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

		edit_tilemap(mouse_grid_y, mouse_grid_x)
	}
}

edit_tilemap :: proc(row: int, col: int) {
	if rl.IsMouseButtonPressed(.LEFT) && .Stone in tm.tiles[row][col].flags {
		tm.tiles[row][col].flags = {.Dirt}
		tm.tiles[row][col].modified = true
	}
}

free_current_tiles :: proc() {
	for row in 0 ..< tm.height {
		delete(tm.tiles[row])
	}

	delete(tm.tiles)
	tm = TileMap{}
}
