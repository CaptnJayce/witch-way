package game

import "core:fmt"
import rl "vendor:raylib"

GameState :: enum {
	MainMenu,
	Pause,
	Game,
	Save,
	Load,
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
	init_spells()
	init_inventory()

	init_enemy()

	init_tilemap(current_level)
}

state_handler :: proc() {
	if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
		state = GameState.Game
	} else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
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
