package game 

import rl "vendor:raylib"
import "core:fmt"

debug_menu :: proc(p: ^Player, l: ^Level) {
    if state == GameState.Game {
        rl.DrawFPS(20, 20)
        rl.DrawText(rl.TextFormat("Health: %f", p.health), 20, 50, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 20, 75, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Editor Enabled: %t", l.editor), 20, 100, 20, rl.RAYWHITE)
    }
}
