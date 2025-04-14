package game

import "core:math/rand"
import rl "vendor:raylib"

Enemy :: struct {
	// enemy data
	position:        rl.Vector2,
	size:            rl.Rectangle,
	source:          rl.Rectangle,
	sight:           f32,
	action_timer:    f32,

	// texture
	texture:         rl.Texture2D,
	flipped:         bool,
	direction:       int,

	// stats
	speed:           f32,
	health:          f32,
	damage:          f32,
	affect_attack:   int,
	affect_recieved: int,

	// iframes
	iframes:         f32,
	iframe_duration: f32,
	is_invincible:   bool,
}

red_guy: Enemy
tall_guy: Enemy
snake_guy: Enemy
enemy_prev_pos: rl.Vector2

init_enemy :: proc() {
	// red_guy.position
	red_guy.size = {0, 0, 24, 24}
	red_guy.source = {0, 0, red_guy.source.width, red_guy.source.height}
	red_guy.sight = 150.0
	red_guy.action_timer = 0

	red_guy.texture = rl.LoadTexture("textures/sprite_enemy.png")
	// red_guy.flipped
	red_guy.direction = 0

	red_guy.speed = 50.0
	red_guy.health = 40.0
	red_guy.damage = 5.0
	red_guy.affect_attack = 0
	red_guy.affect_recieved = 0

	// red_guy.iframes
	red_guy.iframe_duration = 1.0

	// tall_guy.position
	tall_guy.size = {0, 0, 24, 48}
	tall_guy.source = {0, 0, tall_guy.source.width, tall_guy.source.height}
	tall_guy.sight = 200.0
	tall_guy.action_timer = 0

	tall_guy.texture = rl.LoadTexture("textures/sprite_enemy_two.png")
	// tall_guy.flipped
	tall_guy.direction = 0

	tall_guy.speed = 25.0
	tall_guy.health = 80.0
	tall_guy.damage = 10.0
	tall_guy.affect_attack = 0
	tall_guy.affect_recieved = 0

	// tall_guy.iframes
	tall_guy.iframe_duration = 1.0
	tall_guy.is_invincible = false

	// snake_guy.position
	snake_guy.size = {0, 0, 48, 24}
	snake_guy.source = {0, 0, snake_guy.source.width, snake_guy.source.height}
	snake_guy.sight = 200.0
	snake_guy.action_timer = 0

	snake_guy.texture = rl.LoadTexture("textures/sprite_enemy_three.png")
	// snake_guy.flipped
	snake_guy.direction = 0

	snake_guy.speed = 25.0
	snake_guy.health = 80.0
	snake_guy.damage = 10.0
	snake_guy.affect_attack = 0
	snake_guy.affect_recieved = 0

	// snake_guy.iframes
	snake_guy.iframe_duration = 1.0
	snake_guy.is_invincible = false
}

draw_enemy :: proc(enemy: ^Enemy) {
	enemy.source = flip_texture(enemy.flipped, enemy.texture, enemy.size)
	rl.DrawTextureRec(enemy.texture, enemy.source, enemy.position, rl.WHITE)

	if enemy.affect_recieved == 1 {
		rl.DrawRectangleRec(enemy.size, rl.ORANGE)
	}
	if enemy.affect_recieved == 2 {
		rl.DrawRectangleRec(enemy.size, rl.BLUE)
	}
	if enemy.affect_recieved == 3 {
		rl.DrawRectangleRec(enemy.size, rl.YELLOW)
	}
}

move_enemy :: proc(enemy: ^Enemy) {
	dist_to_player := rl.Vector2Distance(p.position, {enemy.size.x, enemy.size.y})

	if enemy.affect_recieved != 3 {
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
				damage_enemy(i, j)

				if l.projectiles[j].pierce == 0 {
					unordered_remove(&l.projectiles, j)
				}

				break
			}
		}
	}
}

damage_enemy :: proc(i: int, j: int) {
	if l.enemies[i].is_invincible == false {
		l.enemies[i].health -= l.projectiles[j].damage
		enemy_iframes(i)
		l.projectiles[j].pierce -= 1
	}

	if l.enemies[i].health <= 0 {
		unordered_remove(&l.enemies, i)
	} else {
		status_handler(i, j)
	}

}

enemy_iframes :: proc(i: int) {
	if !l.enemies[i].is_invincible {
		l.enemies[i].is_invincible = true
		l.enemies[i].iframes = l.enemies[i].iframe_duration
	}
}

enemy_handler :: proc(delta: f32) {
	for &enemy in l.enemies {
		// movement
		enemy_prev_pos = enemy.position
		move_enemy(&enemy)
		enemy.action_timer += delta

		if enemy.action_timer >= 2.0 {
			change_direction(&enemy)
			enemy.action_timer = 0
		}

		// iframes
		if enemy.is_invincible {
			enemy.iframes -= delta
		}
		if enemy.iframes <= 0 {
			enemy.is_invincible = false
			enemy.iframes = enemy.iframe_duration
		}

		enemy_collision(&enemy)
	}
}
