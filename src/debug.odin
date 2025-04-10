package game

import "core:fmt"
import rl "vendor:raylib"

LevelEditor :: enum {
	Krushem,
	Rock,
}

editor := LevelEditor.Krushem
draw_debug := false

debug_menu :: proc() {
	if state == GameState.Game {
		if rl.GuiButton(rl.Rectangle{f32(SWH) - 50, 0, 100, 50}, "Debug Menu") {
			draw_debug = !draw_debug
		}

		if draw_debug {
			rl.DrawFPS(SW - 100, 20)

			rl.DrawText(rl.TextFormat("iframes: %t", p.can_take_damage), 10, 20, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 40, 240, 20}, "", "", &p.health, 10, 10000)
			rl.DrawText(rl.TextFormat("Health: %f", p.health), 10, 40, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 60, 240, 20}, "", "", &s.damage, 1, 10000)
			rl.DrawText(rl.TextFormat("Damage: %f", s.damage), 10, 60, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{8, 80, 240, 20}, fmt.ctprintf("Editor: %t", l.editor)) {
				l.editor = !l.editor
			}

			rl.DrawText(rl.TextFormat("Coords: %f", p.position), 10, 100, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 120, 240, 20}, "", "", &p.speed, 250, 10000)
			rl.DrawText(rl.TextFormat("Speed: %f", p.speed), 10, 120, 20, rl.RAYWHITE)

			rl.GuiSlider(rl.Rectangle{8, 140, 240, 20}, "", "", &p.pickup, 75, 10000)
			rl.DrawText(rl.TextFormat("Pickup: %f", p.pickup), 10, 140, 20, rl.RAYWHITE)

			rl.DrawText(rl.TextFormat("Delta: %f", delta), 10, 160, 20, rl.RAYWHITE)

			if rl.GuiButton(rl.Rectangle{200, 180, 50, 20}, "Clear All") {
				clear(&l.pickups)
				clear(&l.obstacles)
				clear(&l.enemies)
				clear(&l.projectiles)
			}
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

level_editor :: proc() {
	if l.editor {
		if rl.IsKeyDown(.LEFT_SHIFT) {
			if rl.IsMouseButtonPressed(.RIGHT) {
				for p, idx in l.pickups {
					if rl.CheckCollisionPointRec(mp, l.pickups[idx].size) {
						unordered_remove(&l.pickups, idx)
						break
					}
				}

				for p, idx in l.obstacles {
					if rl.CheckCollisionPointRec(mp, l.obstacles[idx].size) {
						unordered_remove(&l.obstacles, idx)
						break
					}
				}

				for p, idx in l.enemies {
					if rl.CheckCollisionPointRec(mp, l.enemies[idx].size) {
						unordered_remove(&l.enemies, idx)
						break
					}
				}
			}

			if rl.IsKeyPressed(.ONE) {editor = .Krushem}
			if rl.IsKeyPressed(.TWO) {editor = .Rock}

			if rl.IsKeyPressed(.Z) {
				red_guy.position = mp
				append(&l.enemies, red_guy)
			}
			if rl.IsKeyPressed(.X) {
				tall_guy.position = mp
				append(&l.enemies, tall_guy)
			}
			if rl.IsKeyPressed(.C) {
				snake_guy.position = mp
				append(&l.enemies, snake_guy)
			}

			if editor == .Krushem && rl.IsMouseButtonPressed(.LEFT) {
				append(&l.pickups, Krushem{rl.Rectangle{mp.x, mp.y, 48, 48}, k.texture})
			}
			if editor == .Rock && rl.IsMouseButtonPressed(.LEFT) {
				append(&l.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 48, 48}, r.texture})
			}
		}
	}
}
