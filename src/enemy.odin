package game

import "core:math/rand"
import rl "vendor:raylib"

Enemy :: struct {
	position:     rl.Vector2,
	size:         rl.Rectangle,
	texture:      rl.Texture2D,
	flipped:      bool,
	speed:        f32,
	health:       f32,
	damage:       f32,
	sight:        f32,
	action_timer: f32,
	direction:    int,
	source:       rl.Rectangle,
}

e: Enemy
enemy_prev_pos: rl.Vector2

init_enemy :: proc() {
	e.size = {0, 0, 24, 24}
	e.texture = rl.LoadTexture("textures/sprite_enemy.png")
	e.flipped = false
	e.speed = 50.0
	e.health = 4
	e.damage = 2
	e.sight = 150.0
	e.action_timer = 0
	e.direction = 0
	e.source = {0, 0, e.source.width, e.source.height}
}

move :: proc(enemy: ^Enemy) {
	dist_to_player := rl.Vector2Distance(p.position, {enemy.size.x, enemy.size.y})

	if dist_to_player <= enemy.sight {
		// add pathing to player here
	} else {
		if enemy.direction == 0 {
			enemy.position.x += enemy.speed * rl.GetFrameTime() // right
		}
		if enemy.direction == 1 {
			enemy.position.x -= enemy.speed * rl.GetFrameTime() // left
		}
		if enemy.direction == 2 {
			enemy.position.y += enemy.speed * rl.GetFrameTime() // down
		}
		if enemy.direction == 3 {
			enemy.position.y -= enemy.speed * rl.GetFrameTime() // up
		}

		// bit hacky but it works
		enemy.size.x = enemy.position.x
		enemy.size.y = enemy.position.y
	}

	// true/false is inverted because the sprite is inverted and i dont wanna fix it
	if enemy.direction == 0 {
		enemy.flipped = true
	}
	if enemy.direction == 1 {
		enemy.flipped = false
	}
}

change_direction :: proc(enemy: ^Enemy) {
	directions: [4]int = {0, 1, 2, 3}
	enemy.direction = rand.choice(directions[:])
}

enemy_collision :: proc(enemy: ^Enemy) {
	for j, idx in l.obstacles {
		if rl.CheckCollisionRecs(enemy.size, l.obstacles[idx].size) {
			enemy.position.x = enemy_prev_pos.x
			enemy.position.y = enemy_prev_pos.y
		}
	}

	// goodness gracious
	// iterates backwards to avoid panic with unordered_remove
	for i := len(l.enemies) - 1; i >= 0; i -= 1 {
		for j := len(l.projectiles) - 1; j >= 0; j -= 1 {
			if rl.CheckCollisionRecs(l.enemies[i].size, l.projectiles[j].size) {
				l.enemies[i].health -= l.projectiles[j].damage
				kill_enemy(&e)

				// for piercing effect
				if l.projectiles[j].type != .Fireball {
					unordered_remove(&l.projectiles, j)
				}

				break
			}
		}
	}
}

kill_enemy :: proc(enemy: ^Enemy) {
	for j, idx in l.enemies {
		if l.enemies[idx].health <= 0 {
			unordered_remove(&l.enemies, idx)
		}
	}
}

draw_enemy :: proc(enemy: ^Enemy) {
	enemy.source = flip_texture(enemy.flipped, enemy.texture, enemy.size)
	rl.DrawTextureRec(enemy.texture, enemy.source, enemy.position, rl.WHITE)
}

enemy_handler :: proc(delta: f32) {
	for &enemy in l.enemies {
		enemy_prev_pos = enemy.position
		move(&enemy)
		enemy.action_timer += delta

		if enemy.action_timer >= 2.0 {
			change_direction(&enemy)
			enemy.action_timer = 0
		}

		enemy_collision(&enemy)
	}
}
