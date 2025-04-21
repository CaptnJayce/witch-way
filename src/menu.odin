package game

import rl "vendor:raylib"

draw_main_menu :: proc() {
	rl.DrawText("Witch Way", SWH - rl.MeasureText("Witch Way", 40) / 2, 40, 40, rl.PURPLE)

	rl.GuiSetStyle(rl.GuiControl.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 20)
	if rl.GuiButton({f32(SWH) - 150, f32(SHH) - 50, 300, 50}, "Enter / Start") ||
	   rl.IsKeyPressed(.ENTER) {
		state = GameState.Game
	}

	if rl.GuiButton({f32(SWH) - 150, f32(SHH), 300, 50}, "Q / Quit") || rl.IsKeyPressed(.Q) {
		rl.CloseWindow()
	}

	rl.ClearBackground(rl.BLACK)
}

draw_pause_menu :: proc() {
	rl.DrawLine(SWH, 0, SWH, SH, rl.RED)
	rl.DrawText("Paused", SWH - rl.MeasureText("Paused", 40) / 2, 40, 40, rl.PURPLE)

	rl.GuiSetStyle(rl.GuiControl.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 20)
	if rl.GuiButton({f32(SWH) - 125, f32(SHH) - 50, 250, 50}, "ESC / Resume") ||
	   rl.IsKeyPressed(.Q) {
		state = GameState.Game
	}

	if rl.GuiButton({f32(SWH) - 125, f32(SHH), 250, 50}, "Q / Quit") || rl.IsKeyPressed(.Q) {
		state = GameState.MainMenu
	}

	if rl.GuiButton({f32(SWH) - 80, f32(SHH) + 50, 80, 50}, "Save") {
		save()
		save_tiles(fp, current_level)
	}
	if rl.GuiButton({f32(SWH), f32(SHH) + 50, 80, 50}, "Load") {
		load()
		load_tiles(fp, current_level)
	}
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
