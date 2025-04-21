package game

import rl "vendor:raylib"

// Enemies/projectiles are global as their data won't be saved
// They will persist until level change
// Static entities, like pickups and obstacles, need to be stored/loaded per level
enemies: [dynamic]Enemy
projectiles: [dynamic]Spell

LevelOne :: struct {
	level_bounds: rl.Rectangle,
	been_loaded:  bool,

	// level specific, will need to be saved
	pickups:      [dynamic]Krushem,
	obstacles:    [dynamic]Rock,
}
lv_one: LevelOne

current_level: int
current_bounds: ^rl.Rectangle
init_levels :: proc() {
	// future reference
	// if no save_data then do this, else load save_data
	current_level = 1
	current_bounds = &lv_one.level_bounds

	lv_one.level_bounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}
}

level_handler :: proc() {
	if rl.IsKeyPressed(.ONE) {
		current_level = 1

		// tilemap needs to be loaded before changes  
		init_tilemap(current_level)
	}

	switch current_level {
	case 1:
		current_bounds = &lv_one.level_bounds
		tile_path = "level1_tiles.bin"
	}
}
