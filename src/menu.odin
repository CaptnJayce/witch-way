package game

import rl "vendor:raylib"

draw_main_menu :: proc() {
	rl.DrawText("Main Menu", SWH - rl.MeasureText("Main Menu", 20) / 2, SHH, 20, rl.PURPLE)
	rl.DrawText(
		"Press Enter to play",
		SWH - rl.MeasureText("Press Enter to play", 20) / 2,
		SHH + 40,
		20,
		rl.PURPLE,
	)
	rl.ClearBackground(rl.BLACK)
}

draw_pause_menu :: proc() {
	rl.DrawText("Game Paused", SWH - rl.MeasureText("Game Paused", 20) / 2, SHH, 20, rl.PURPLE)
	rl.ClearBackground(rl.BLACK)
}

draw_death_screen_menu :: proc() {
	rl.DrawText("You Died", SWH - rl.MeasureText("You Died", 20) / 2, SHH, 20, rl.RED)
	rl.DrawText(
		"Press 'Enter' to respawn",
		SWH - rl.MeasureText("Press 'Enter' to respawn", 20) / 2,
		SHH + 40,
		20,
		rl.LIME,
	)
	rl.DrawText(
		"Press 'Escape' to quit",
		SWH - rl.MeasureText("Press 'Escape' to quit", 20) / 2,
		SHH + 80,
		20,
		rl.WHITE,
	)
	rl.ClearBackground(rl.BLACK)
}
