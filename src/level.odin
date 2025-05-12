package game

import rl "vendor:raylib"

// Enemies/projectiles are global as their data won't be saved
// They will persist until level change
// Static entities, like pickups and obstacles, need to be stored/loaded per level
enemies: [dynamic]Enemy

current_bounds: rl.Rectangle
init_world :: proc() {
	current_bounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}
}
