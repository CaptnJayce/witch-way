package game 

import rl "vendor:raylib"
import "core:fmt"

Enemy :: struct {
    size: rl.Rectangle,
    texture: rl.Texture2D,
    flipped: bool,
    speed: f32,
    health: f32,
    damage: f32,
}

enemy_handler :: proc() {
    // store pos from a frame before for collisions
}
