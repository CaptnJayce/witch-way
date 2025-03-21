package game

import rl "vendor:raylib"
import "core:fmt"

c := rl.Camera2D {}

camera :: proc() {
    c.zoom = 1
    c.offset = {f32(SWH), f32(SHH)}
    c.target = p.position

    rl.BeginMode2D(c)
}

camera_end :: proc() {
    rl.EndMode2D()
}
