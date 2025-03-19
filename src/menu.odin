package game

import rl "vendor:raylib"
import "core:fmt"

draw_main_menu :: proc() {
    rl.DrawText("Main Menu", SWH- rl.MeasureText("Main Menu", 20) / 2, SHH, 20, rl.PURPLE)
    rl.DrawText("Press Enter to play", SWH - rl.MeasureText("Press Enter to play", 20) / 2, SHH + 40, 20, rl.PURPLE)
    rl.ClearBackground(rl.BLACK)
}

draw_pause_menu :: proc() {
    rl.DrawText("Game Paused", SWH - rl.MeasureText("Game Paused", 20) / 2, SHH, 20, rl.PURPLE)
    rl.ClearBackground(rl.BLACK)
}
