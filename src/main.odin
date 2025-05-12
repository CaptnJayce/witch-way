package game

import "core:fmt"
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
		case .Load:
			draw_load_save_menu()
		case .Save:
			rl.DrawText("uhhh", 300, 300, 20, rl.WHITE)
		case .Game:
			mp = rl.GetScreenToWorld2D(rl.GetMousePosition(), c)

			player_handler()
			mouse_handler()
			enemy_handler(delta)

			wand_handler()

			// spell stuff
			select_spell()
			cast_spell()
			update_spell()

			player_iframes(delta)

			toggle_inventory()

			camera()

			draw()

			hitbox()
			rl.ClearBackground(rl.WHITE)
			level_editor()
		}

		camera_end()

		// ui
		debug_menu()
		draw_inventory()
		draw_attunement()
	}
}
