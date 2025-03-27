package game 

import rl "vendor:raylib"
import "core:fmt"

Player :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    texture: rl.Texture2D,
    flipped: bool,
    speed: f32,
    health: f32,
    damage: f32,
    can_take_damage: bool,
    iframe_timer: f32,
    pickup: f32,
}

// take in enemy type when more enemies are added
damage_recieved :: proc() {
    if p.can_take_damage == true {
        p.health -= e.damage 
        p.iframe_timer = 0
        iframes(delta)
    }
}

// wait 1.3 seconds before taking damage again
iframes :: proc (delta: f32) {
    p.can_take_damage = false

    if !p.can_take_damage {
        p.iframe_timer += delta

        if p.iframe_timer >= 1.3 {
            p.can_take_damage = true
        }
    } 
}


player_movement :: proc() {
    // store pos from a frame before for collisions
    player_prev_pos = p.position

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
