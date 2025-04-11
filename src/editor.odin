package game

import rl "vendor:raylib"

LevelEditor :: enum {
	Krushem,
	Rock,
}

editor := LevelEditor.Krushem

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
