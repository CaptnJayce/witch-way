package game

import "core:math/rand"
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

e: Enemy

init_enemy :: proc() {
	e.texture = rl.LoadTexture("textures/sprite_enemy.png")
	e.flipped = false
	e.speed = 50.0
	e.health = 4
	e.damage = 2
	e.sight = 150.0
	e.action_timer = 0
	e.direction = 0
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

		enemy_collision(&enemy)
	}
}

enemy_collision :: proc(enemy: ^Enemy) {
	for j, idx in l.obstacles {
		if rl.CheckCollisionRecs(enemy.size, l.obstacles[idx].size) {
			enemy.size.x = enemy_prev_pos.x
			enemy.size.y = enemy_prev_pos.y
		}
	}
}