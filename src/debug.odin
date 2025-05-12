package game

import "core:fmt"
import rl "vendor:raylib"

draw_debug := false

debug_menu :: proc() {
	if state == GameState.Game {
		if rl.GuiButton(rl.Rectangle{f32(SWH) - 50, 0, 100, 50}, "Debug Menu") {
			draw_debug = !draw_debug
		}

		if draw_debug {
			rl.DrawFPS(SW - 100, 20)

			rl.DrawText(rl.TextFormat("iframes: %t", p.can_take_damage), 10, 20, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Health: %f", p.health), 10, 40, 20, rl.RAYWHITE)

			//rl.DrawText(rl.TextFormat("Damage: %f", s.damage), 10, 60, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{8, 80, 240, 20}, fmt.ctprintf("Editor: %t", editor)) {
				editor = !editor
			}

			rl.DrawText(rl.TextFormat("Coords: %f", p.position / 10), 10, 100, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Speed: %f", p.speed), 10, 120, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Pickup: %f", p.pickup), 10, 140, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Delta: %f", delta), 10, 160, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{200, 180, 50, 20}, "Clear All") {
				clear(&enemies)
			}
			rl.DrawText(rl.TextFormat("Entities: %d", entity_counter), 10, 180, 20, rl.RAYWHITE)
		}
	}
}

hitbox :: proc() {
	if state == GameState.Game {
		if draw_debug {
			for &enemy in enemies {
				rl.DrawRectangleRec(enemy.size, {100, 100, 255, 100})
			}
		}
	}
}

level_editor :: proc() {
	if editor {
		if rl.IsKeyPressed(.Z) {
			red_guy.position = mp
			append(&enemies, red_guy)
		}
		if rl.IsKeyPressed(.X) {
			tall_guy.position = mp
			append(&enemies, tall_guy)
		}
		if rl.IsKeyPressed(.C) {
			snake_guy.position = mp
			append(&enemies, snake_guy)
		}
	}
}
