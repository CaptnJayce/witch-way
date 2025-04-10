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

			mp = rl.GetScreenToWorld2D(rl.GetMousePosition(), c)
			entity_count()

			player_handler()
			enemy_handler(delta)

			spell_handler(delta)
			wand_handler()

			player_iframes(delta)

			toggle_inventory()

			camera()

			draw_grid()
			draw()

			hitbox()
			rl.ClearBackground(rl.DARKGREEN)
			level_editor()
		}

		camera_end()

		// ui
		draw_inventory()
		debug_menu()
	}
}
