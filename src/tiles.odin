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
	Grass      = 4,
	Tilled     = 5,
	Krushem    = 6,
	Heartium   = 7,
}

Tile :: struct {
	flags:   bit_set[TileFlags;u16],
	variant: u8,
}

TileMap :: struct {
	world_width, world_height: int,
	tile_width, tile_height:   int,
	tiles:                     []Tile,
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

init_tilemap :: proc() {
	rl.SetRandomSeed(u32(seed))

	tm.world_width = LEVEL_WIDTH * 2
	tm.world_height = LEVEL_HEIGHT * 2
	tm.tile_width = int(tm.world_width / TILE_SIZE)
	tm.tile_height = int(tm.world_height / TILE_SIZE)

	tm.tiles = make([]Tile, tm.tile_width * tm.tile_height)

	for row in 0 ..< tm.tile_height {
		for col in 0 ..< tm.tile_width {
			index := row * tm.tile_width + col
			tm.tiles[index].flags = {.Grass}

			selected := rl.GetRandomValue(0, 100)

			if selected <= 1 && selected >= 0 {
				tm.tiles[index].variant = u8(rl.GetRandomValue(3, i32(len(g.atlas.variants) - 1)))
			}
			if selected > 1 {
				tm.tiles[index].variant = u8(rl.GetRandomValue(0, 2))
			}
		}
	}

	for row in 0 ..< tm.tile_height {
		for col in 0 ..< tm.tile_width {
			index := row * tm.tile_width + col
			selected := rl.GetRandomValue(0, 1000)

			if selected == 999 || selected == 998 {
				tm.tiles[index].flags += {.Krushem}
			}
			if selected == 997 {
				tm.tiles[index].flags += {.Heartium}
			}
		}
	}
}

collision_rect := rl.Rectangle{}
current_x: i32
current_y: i32

draw_tilemap :: proc() {
	world_start_x := render_rect.x - TILE_SIZE
	world_start_y := render_rect.y - TILE_SIZE
	world_end_x := render_rect.x + render_rect.width + TILE_SIZE
	world_end_y := render_rect.y + render_rect.height + TILE_SIZE

	start_col := max(0, int(world_start_x / TILE_SIZE) + tm.tile_width / 2)
	end_col := min(tm.tile_width, int(world_end_x / TILE_SIZE) + tm.tile_width / 2)
	start_row := max(0, int(world_start_y / TILE_SIZE) + tm.tile_height / 2)
	end_row := min(tm.tile_height, int(world_end_y / TILE_SIZE) + tm.tile_height / 2)

	for row in start_row ..< end_row {
		for col in start_col ..< end_col {
			index := row * tm.tile_width + col
			tile := tm.tiles[index]

			tile_x := i32(col * TILE_SIZE - tm.world_width / 2)
			tile_y := i32(row * TILE_SIZE - tm.world_height / 2)

			if .Grass in tile.flags {
				rl.DrawTexturePro(
					g.atlas.texture,
					g.atlas.variants[tile.variant],
					{f32(tile_x), f32(tile_y), TILE_SIZE, TILE_SIZE},
					{0, 0},
					0,
					rl.WHITE,
				)
				// rl.DrawText(rl.TextFormat("%d", tile.variant), tile_x, tile_y, 20, rl.RAYWHITE)
			}
			if .Dirt in tile.flags {
				rl.DrawTexture(d.atlas.texture, tile_x, tile_y, rl.WHITE) // make TexturePro later
			}
			if .Krushem in tile.flags {
				rl.DrawTexture(k.texture, tile_x, tile_y, rl.WHITE)
			}
			if .Heartium in tile.flags {
				rl.DrawTexture(h.texture, tile_x, tile_y, rl.WHITE)
			}
			if .Stone in tile.flags {
				rl.DrawRectangle(tile_x, tile_y, TILE_SIZE, TILE_SIZE, rl.GRAY)
			}
		}
	}

	mouse_world_x := mouse_rect.x
	mouse_world_y := mouse_rect.y

	mouse_tile_x := int((mouse_world_x + f32(tm.world_width / 2)) / TILE_SIZE)
	mouse_tile_y := int((mouse_world_y + f32(tm.world_height / 2)) / TILE_SIZE)

	if mouse_tile_x >= 0 &&
	   mouse_tile_x < tm.tile_width &&
	   mouse_tile_y >= 0 &&
	   mouse_tile_y < tm.tile_height {

		if rl.Vector2Distance({mouse_world_x, mouse_world_y}, {p.position.x, p.position.y}) < 50 {
			highlight_x := (f32(mouse_tile_x) * TILE_SIZE) - f32(tm.world_width / 2)
			highlight_y := (f32(mouse_tile_y) * TILE_SIZE) - f32(tm.world_height / 2)

			rl.DrawRectangleRec(
				rl.Rectangle {
					x = highlight_x,
					y = highlight_y,
					width = TILE_SIZE,
					height = TILE_SIZE,
				},
				rl.ColorAlpha(rl.WHITE, 0.5),
			)

			if rl.IsMouseButtonPressed(.LEFT) {
				index := mouse_tile_y * tm.tile_width + mouse_tile_x

				if .Krushem in tm.tiles[index].flags {
					tm.tiles[index].flags = {.Dirt, .Modified}
					i.slots[0].count += 1
				}
				if .Heartium in tm.tiles[index].flags {
					tm.tiles[index].flags = {.Dirt, .Modified}
					i.slots[1].count += 1
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
