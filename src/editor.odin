package game 

import rl "vendor:raylib"
import "core:fmt"

LevelEditor :: enum {
    Krushem,
    Rock,
}

editor := LevelEditor.Krushem

level_editor :: proc() {
    mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), c)

    if rl.IsKeyPressed(.T) {
        l.editor = !l.editor
    }

    if l.editor {
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
        }

        if rl.IsKeyPressed(.ONE) { editor = .Krushem }
        if rl.IsKeyPressed(.TWO) { editor = .Rock }

        if rl.IsKeyPressed(.H) {
            append(&l.enemies, Enemy{{mp.x, mp.y, 24, 24}, e.texture, e.flipped, e.speed, e.health, e.damage, e.sight, e.action_timer, e.direction})
        }
 
        if editor == .Krushem && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.pickups, Krushem{rl.Rectangle{mp.x, mp.y, 48, 48}, k.texture})
        }
        if editor == .Rock && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 48, 48}, r.texture})
        }
    }
}

