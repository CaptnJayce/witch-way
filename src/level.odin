package game

import rl "vendor:raylib"

TILE_SIZE :: 16

// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 2960
LEVEL_HEIGHT :: 2000

LevelOne :: struct {
	levelBounds: rl.Rectangle,
}

lv_one: LevelOne
delta: f32

// remove or rework later
Level :: struct {
	pickups:     [dynamic]Krushem,
	obstacles:   [dynamic]Rock,
	enemies:     [dynamic]Enemy,
	projectiles: [dynamic]Spell,
	editor:      bool,
}
l: Level

current_level: int
current_bounds: ^rl.Rectangle
init_levels :: proc() {
	current_level = 1
	current_bounds = &lv_one.levelBounds

	lv_one.levelBounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}
}

level_handler :: proc() {
	level_changed := false

	if rl.IsKeyPressed(.ONE) {
		current_level = 1
		level_changed = true
	}

	switch current_level {
	case 1:
		current_bounds = &lv_one.levelBounds
		fp = "level1_tiles.bin"
	}

	if level_changed == true {
		init_tilemap(current_level)
		load_tiles(fp, current_level)
		level_changed = false
	}
}
