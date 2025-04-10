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

	init_player()
	init_wand()
	init_inventory()

	init_grid()

	init_enemy()
}

entity_count :: proc() {
	entity_counter = len(l.pickups) + len(l.enemies) + len(l.obstacles) + len(l.projectiles)
}

state_handler :: proc() {
	if state == GameState.MainMenu && rl.IsKeyPressed(.Q) {
		rl.CloseWindow() // if main menu, quit game
	}
	if state == GameState.Pause && rl.IsKeyPressed(.Q) {
		state = GameState.MainMenu // if paused, go to main menu
	}

	if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
		state = GameState.Game // if paused, switch to game
	} else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
		state = GameState.Pause // if game, switch to pause
	}
	if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
		state = GameState.Game // if menu, switch to game
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
