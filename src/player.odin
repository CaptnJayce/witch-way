package game 

import rl "vendor:raylib"
import "core:fmt"

Player :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    texture: rl.Texture2D,
    flipped: bool,
    speed: f32,
    color: rl.Color,
    health: f32,
    damage: f32,
    pickup: f32,
}

player_handler :: proc() {
    // store pos from a frame before for collisions
    prev_pos = p.position

    if rl.IsKeyDown(.W) { p.position.y -= p.speed * rl.GetFrameTime() }
    if rl.IsKeyDown(.S) { p.position.y += p.speed * rl.GetFrameTime() }
    if rl.IsKeyDown(.A) {
        p.flipped = true
        p.position.x -= p.speed * rl.GetFrameTime() 
    }
    if rl.IsKeyDown(.D) { 
        p.flipped = false
        p.position.x += p.speed * rl.GetFrameTime() 
    }
}
