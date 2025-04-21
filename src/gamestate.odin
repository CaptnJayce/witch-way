package game

import rl "vendor:raylib"

GameState :: enum {
	MainMenu,
	Pause,
	Game,
	DeathScreen,
}

state := GameState.MainMenu
entity_counter: int
mp: rl.Vector2

init_all :: proc() {
	init_sprite()
	init_objects()

	init_levels()

	init_player()
	init_wand()
	init_inventory()

	init_enemy()

	init_tilemap(current_level)
	load_tiles(fp, current_level)
}

entity_count :: proc() {
	entity_counter = len(lv_one.pickups) + len(enemies) + len(lv_one.obstacles) + len(projectiles)
}

state_handler :: proc() {
	if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
		state = GameState.Game
	} else if rl.IsKeyPressed(.ESCAPE) {
		state = GameState.Pause
	}

	if p.health <= 0 {
		state = GameState.DeathScreen // if no health left, switch to deathscreen
	}

	// death screen logic 
	if state == GameState.DeathScreen && rl.IsKeyPressed(.ENTER) {
		p.health = p.max_health
		state = GameState.Game
		load()
	}
	if state == GameState.DeathScreen && rl.IsKeyPressed(.ESCAPE) {
		p.health = p.max_health
		state = GameState.MainMenu
	}
}
