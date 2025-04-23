package game

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

draw_main_menu :: proc() {
	rl.DrawText("Witch Way", SWH - rl.MeasureText("Witch Way", 40) / 2, 40, 40, rl.PURPLE)

	rl.GuiSetStyle(rl.GuiControl.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 20)
	if rl.GuiButton({f32(SWH) - 150, f32(SHH) - 100, 300, 50}, "Enter / Start") ||
	   rl.IsKeyPressed(.ENTER) {
		state = GameState.Game

		if !save_selected {
			os.make_directory("save_data/save0")
			save_slot = "save0/"
			tfp = strings.concatenate([]string{save_data, save_slot, tile_path})
			sfp = strings.concatenate([]string{save_data, save_slot, json_path})
		}


		load()
		init_tilemap(current_level)
		load_tiles(tfp)

		if !os.exists(sfp) {
			p.position = {-50, -50}
			p.flipped = false
			p.speed = 200.0
			p.max_health = 10
			p.health = p.max_health
			p.damage = 5
			p.pickup = 40.0
		}
	}

	if rl.GuiButton({f32(SWH) - 150, f32(SHH), 300, 50}, "L / Load") || rl.IsKeyPressed(.L) {
		state = GameState.Load
	}

	if rl.GuiButton({f32(SWH) - 150, f32(SHH) + 100, 300, 50}, "Q / Quit") || rl.IsKeyPressed(.Q) {
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
		save()
		save_tiles(tfp)
		free_current_tiles()
		state = GameState.MainMenu
	}

	if rl.GuiButton({f32(SWH) - 80, f32(SHH) + 50, 80, 50}, "Save") {
		save()
		save_tiles(tfp)
	}
	if rl.GuiButton({f32(SWH), f32(SHH) + 50, 80, 50}, "Load") {
		load()
		load_tiles(tfp)
	}
	rl.ClearBackground(rl.BLACK)
}

draw_load_save_menu :: proc() {
	rl.DrawText("Choose a Save", SWH - rl.MeasureText("Choose a Save", 40) / 2, 40, 40, rl.WHITE)

	if rl.GuiButton({50, 50, 80, 50}, "Back") || rl.IsKeyPressed(.ESCAPE) {
		state = GameState.MainMenu
	}

	BUTTON_WIDTH :: 200
	BUTTON_HEIGHT :: 50
	BUTTON_SPACING :: 50
	save_button_x: f32 = f32(SWH) - 100
	delete_button_x: f32 = f32(SWH) - 400
	start_y: f32 = f32(SHH) + 50

	for i in 0 ..< 4 {
		save_name := fmt.tprintf("save%d", i)
		save_path := fmt.aprintf("save_data/%s", save_name)
		y_pos := start_y + f32(i) * BUTTON_SPACING

		exists := os.exists(save_path)

		button_text := strings.clone_to_cstring(fmt.tprintf("Save %d", i + 1))
		if !exists {
			button_text = strings.clone_to_cstring(fmt.tprintf("New Save %d", i + 1))
		}

		if rl.GuiButton({save_button_x, y_pos, BUTTON_WIDTH, BUTTON_HEIGHT}, button_text) {
			if !exists {
				os.make_directory(save_path)
			}
			save_slot = fmt.tprintf("%s/", save_name)
			tfp = strings.concatenate([]string{save_data, save_slot, tile_path})
			sfp = strings.concatenate([]string{save_data, save_slot, json_path})
			save_selected = true
		}

		if exists {
			if rl.GuiButton({delete_button_x, y_pos, BUTTON_WIDTH, BUTTON_HEIGHT}, "Delete Save") {
				remove_directory_recursive(save_path)
			}
		}
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

remove_directory_recursive :: proc(path: string) -> bool {
	dir, err := os.open(path)
	defer os.close(dir)

	files, err2 := os.read_dir(dir, 0)
	if err2 != os.ERROR_NONE {
		return false
	}

	for file in files {
		full_path := strings.concatenate([]string{path, "/", file.name})
		if file.is_dir {
			if file.name == "." || file.name == ".." {
				continue
			}
			if !remove_directory_recursive(full_path) {
				return false
			}
		} else {
			if os.remove(full_path) != os.ERROR_NONE {
				return false
			}
		}
	}

	return os.remove_directory(path) == os.ERROR_NONE
}
