package game

import rl "vendor:raylib"
import "core:fmt"

prev_pos : rl.Vector2

collision :: proc(p: ^Player, l: ^Level) {
    player_rect := rl.Rectangle {
        x = p.position.x - p.size.x / 2,
        y = p.position.y - p.size.x / 2,
        width = p.size.x,
        height = p.size.y,
    }

    for j, idx in l.pickups {
        if rl.Vector2Distance(p.position, {l.pickups[idx].size.x, l.pickups[idx].size.y}) <= p.pickup {
            if rl.IsKeyPressed(.F) {
                unordered_remove(&l.pickups, idx)
                i.slots[0].count += 1
                break
            }
        }
    }

    for j, idx in l.obstacles {
        if rl.CheckCollisionRecs(player_rect, l.obstacles[idx].size) {
            p.position = prev_pos
        }
    }
}
