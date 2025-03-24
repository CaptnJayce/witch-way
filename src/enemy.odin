package game 

import rl "vendor:raylib"
import "core:fmt"
import "core:math/rand"
import "core:time"

Enemy :: struct {
    size: rl.Rectangle,
    texture: rl.Texture2D,
    flipped: bool,
    speed: f32,
    health: f32,
    damage: f32,
    sight: f32,
    action_timer: f32,
    direction: int,
}

change_direction :: proc() {
    directions: [4]int = {0, 1, 2, 3}
    e.direction = rand.choice(directions[:])
}

move :: proc() {
    if e.direction == 0 {
        e.size.x += e.speed * rl.GetFrameTime() // right
    }
    if e.direction == 1 {
        e.size.x -= e.speed * rl.GetFrameTime() // left
    }
    if e.direction == 2 {
        e.size.y += e.speed * rl.GetFrameTime() // down
    }
    if e.direction == 3 {
        e.size.y -= e.speed * rl.GetFrameTime() // up
    }
}

enemy_handler :: proc(delta: f32) {
    if len(l.enemies) != 0 {
        move()
        e.action_timer += delta
        if e.action_timer >= 2.0 { 
            change_direction()
            e.action_timer = 0
        }
    }
}
