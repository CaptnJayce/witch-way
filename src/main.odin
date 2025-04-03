package game

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SW, SH, "Witch Way")
	defer rl.CloseWindow()
	rl.SetTargetFPS(120)

	init_all()

	for !rl.WindowShouldClose() {
		rl.SetExitKey(.KEY_NULL)
		rl.BeginDrawing()
		defer rl.EndDrawing()
		delta = rl.GetFrameTime()

		state_handler()

		switch state {
		case .MainMenu:
			draw_main_menu()
		case .DeathScreen:
			draw_death_screen_menu()
		case .Pause:
			draw_pause_menu()
			if rl.IsKeyPressed(.S) {
				save()
			}
		case .Game:
			if rl.IsKeyPressed(.L) {
				load()
			}

			// player stuff
			player_handler()
			iframes(delta)
			toggle_inventory()

			enemy_handler(delta)

			camera()

			// draw 
			draw_grid()
			draw()
			flip_texture(p.flipped)

			rl.ClearBackground(rl.DARKGREEN)
			level_editor()
		}

		camera_end()

		// ui
		draw_inventory()
		debug_menu()
	}
}
