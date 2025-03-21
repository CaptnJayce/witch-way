package game 

import rl "vendor:raylib"
import "core:fmt"

debug_menu :: proc() {
    if state == GameState.Game {
        rl.DrawFPS(20, 20)
        rl.DrawText(rl.TextFormat("Health: %f", p.health), 10, 40, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 10, 60, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Editor enabled: %t", l.editor), 10, 80, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Coords: %f", p.position), 10, 100, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Speed: %f", p.speed), 10, 120, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Pickup range: %f", p.pickup), 10, 140, 20, rl.RAYWHITE)
    }
}
