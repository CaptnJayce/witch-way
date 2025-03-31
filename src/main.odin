package game

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SW, SH, "Witch Way")
	defer rl.CloseWindow()
	rl.SetTargetFPS(120)

	// initialise everything
	init_player()
	init_enemy()
	init_sprite()
	init_inventory()
	init_grid()

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

			player_movement()
			toggle_inventory()
			iframes(delta)
			enemy_handler(delta)
			camera()

			draw_grid()
			draw()
			flip_texture(p.flipped)

			collision()

			rl.ClearBackground(rl.DARKGREEN)
			level_editor()
		}

		camera_end()

		draw_inventory()

		debug_menu()
	}
}
