package game

import "core:fmt"
import "core:math/rand"
import "core:time"
import rl "vendor:raylib"

Enemy :: struct {
	size:         rl.Rectangle,
	texture:      rl.Texture2D,
	flipped:      bool,
	speed:        f32,
	health:       f32,
	damage:       f32,
	sight:        f32,
	action_timer: f32,
	direction:    int,
}

move :: proc(enemy: ^Enemy) {
	dist_to_player := rl.Vector2Distance(p.position, {enemy.size.x, enemy.size.y})

	if dist_to_player <= enemy.sight {
		// add pathing to player here
	} else {
		if enemy.direction == 0 {
			enemy.size.x += enemy.speed * rl.GetFrameTime() // right
		}
		if enemy.direction == 1 {
			enemy.size.x -= enemy.speed * rl.GetFrameTime() // left
		}
		if enemy.direction == 2 {
			enemy.size.y += enemy.speed * rl.GetFrameTime() // down
		}
		if enemy.direction == 3 {
			enemy.size.y -= enemy.speed * rl.GetFrameTime() // up
		}
	}
}

change_direction :: proc(enemy: ^Enemy) {
	directions: [4]int = {0, 1, 2, 3}
	enemy.direction = rand.choice(directions[:])
}

enemy_handler :: proc(delta: f32) {
	for &enemy in l.enemies {
		enemy_prev_pos = {enemy.size.x, enemy.size.y}
		move(&enemy)
		enemy.action_timer += delta

		if enemy.action_timer >= 2.0 {
			change_direction(&enemy)
			enemy.action_timer = 0
		}
	}
}
