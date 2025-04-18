package game

import "core:fmt"
import rl "vendor:raylib"

LevelEditor :: enum {
	Krushem,
	Rock,
}

debugger := LevelEditor.Krushem
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

			rl.GuiSlider(rl.Rectangle{8, 60, 240, 20}, "", "", &s.damage, 1, 10000)
			rl.DrawText(rl.TextFormat("Damage: %f", s.damage), 10, 60, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{8, 80, 240, 20}, fmt.ctprintf("Editor: %t", editor)) {
				editor = !editor
			}

			rl.DrawText(rl.TextFormat("Coords: %f", p.position), 10, 100, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 120, 240, 20}, "", "", &p.speed, 250, 10000)
			rl.DrawText(rl.TextFormat("Speed: %f", p.speed), 10, 120, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 140, 240, 20}, "", "", &p.pickup, 75, 10000)
			rl.DrawText(rl.TextFormat("Pickup: %f", p.pickup), 10, 140, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Delta: %f", delta), 10, 160, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{200, 180, 50, 20}, "Clear All") {
				clear(&lv_one.pickups)
				clear(&lv_one.obstacles)
				clear(&enemies)
				clear(&projectiles)
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

			for &spell in projectiles {
				rl.DrawRectangleRec(spell.size, {100, 100, 255, 100})
			}

			for &obstacles in lv_one.obstacles {
				rl.DrawRectangleRec(obstacles.size, {100, 100, 255, 100})
			}
		}
	}
}

level_editor :: proc() {
	if editor {
		if rl.IsKeyDown(.LEFT_SHIFT) {
			if rl.IsMouseButtonPressed(.RIGHT) {
				for p, idx in lv_one.pickups {
					if rl.CheckCollisionPointRec(mp, lv_one.pickups[idx].size) {
						unordered_remove(&lv_one.pickups, idx)
						break
					}
				}

				for p, idx in lv_one.obstacles {
					if rl.CheckCollisionPointRec(mp, lv_one.obstacles[idx].size) {
						unordered_remove(&lv_one.obstacles, idx)
						break
					}
				}

				for p, idx in enemies {
					if rl.CheckCollisionPointRec(mp, enemies[idx].size) {
						unordered_remove(&enemies, idx)
						break
					}
				}
			}

			if rl.IsKeyPressed(.ONE) {debugger = .Krushem}
			if rl.IsKeyPressed(.TWO) {debugger = .Rock}

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

			if debugger == .Krushem && rl.IsMouseButtonPressed(.LEFT) {
				append(&lv_one.pickups, Krushem{rl.Rectangle{mp.x, mp.y, 16, 16}, k.texture})
			}
			if debugger == .Rock && rl.IsMouseButtonPressed(.LEFT) {
				append(&lv_one.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 16, 16}, r.texture})
			}
		}
	}
}
