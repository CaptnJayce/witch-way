package game

import rl "vendor:raylib"

draw_debug := false

debug_menu :: proc() {
	if state == GameState.Game {
		if rl.IsKeyPressed(.TAB) {
			draw_debug = !draw_debug
		}

		if draw_debug {
			rl.DrawFPS(SW - 100, 20)
			rl.DrawText(rl.TextFormat("iframes: %t", p.can_take_damage), 10, 20, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Health: %f", p.health), 10, 40, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 10, 60, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Editor enabled: %t", l.editor), 10, 80, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Coords: %f", p.position), 10, 100, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Speed: %f", p.speed), 10, 120, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Pickup range: %f", p.pickup), 10, 140, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Delta: %f", delta), 10, 160, 20, rl.RAYWHITE)
			rl.DrawText(rl.TextFormat("Entities: %d", entity_counter), 10, 180, 20, rl.RAYWHITE)
		}
	}
}

hitbox :: proc() {
	if state == GameState.Game {
		if draw_debug {
			for &enemy in l.enemies {
				rl.DrawRectangleRec(enemy.size, {100, 100, 255, 100})
			}

			for &spell in l.projectiles {
				rl.DrawRectangleRec(spell.size, {100, 100, 255, 100})
			}
		}
	}
}
