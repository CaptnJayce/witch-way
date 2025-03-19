package game 

import rl "vendor:raylib"
import "core:fmt"

LevelEditor :: enum {
    Berry,
    Rock,
}

editor := LevelEditor.Berry

level_editor :: proc(l: ^Level, c: rl.Camera2D, berry_sprite: rl.Texture2D, rock_sprite: rl.Texture2D) {
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

        if rl.IsKeyPressed(.ONE) { editor = .Berry }
        if rl.IsKeyPressed(.TWO) { editor = .Rock }

        if editor == .Berry && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.pickups, Berry{rl.Rectangle{mp.x, mp.y, 48, 48}, berry_sprite})
        }
        if editor == .Rock && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 48, 48}, rock_sprite})
        }
    }
}

