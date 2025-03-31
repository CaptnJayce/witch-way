package game

import "core:fmt"
import rl "vendor:raylib"

player_prev_pos: rl.Vector2
enemy_prev_pos: rl.Vector2

collision :: proc() {
	player_rect := rl.Rectangle {
		x      = p.position.x - p.size.x / 2,
		y      = p.position.y - p.size.y / 2,
		width  = p.size.x,
		height = p.size.y,
	}

	for j, idx in l.pickups {
		if rl.Vector2Distance(p.position, {l.pickups[idx].size.x, l.pickups[idx].size.y}) <=
		   p.pickup {
			if rl.IsKeyPressed(.F) {
				unordered_remove(&l.pickups, idx)
				i.slots[0].count += 1
				break
			}
		}
	}

	for j, idx in l.obstacles {
		if rl.CheckCollisionRecs(player_rect, l.obstacles[idx].size) {
			player_rect_x := rl.Rectangle {
				x      = p.position.x - p.size.x / 2,
				y      = player_prev_pos.y - p.size.y / 2,
				width  = p.size.x,
				height = p.size.y,
			}
			if rl.CheckCollisionRecs(player_rect_x, l.obstacles[idx].size) {
				p.position.x = player_prev_pos.x
			}

			player_rect_y := rl.Rectangle {
				x      = player_prev_pos.x - p.size.x / 2,
				y      = p.position.y - p.size.y / 2,
				width  = p.size.x,
				height = p.size.y,
			}
			if rl.CheckCollisionRecs(player_rect_y, l.obstacles[idx].size) {
				p.position.y = player_prev_pos.y
			}
		}
	}

	for j, idx in l.enemies {
		if rl.CheckCollisionRecs(player_rect, l.enemies[idx].size) {
			damage_recieved()
		}
	}

	for j, idx in l.obstacles {
		if rl.CheckCollisionRecs(e.size, l.obstacles[idx].size) {
			e.size.x = enemy_prev_pos.x
			e.size.y = enemy_prev_pos.y
		}
	}
}
