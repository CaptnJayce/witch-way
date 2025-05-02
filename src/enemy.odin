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
	velocity:        rl.Vector2,
	friction:        f32,
	acceleration:    f32,
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
	red_guy.size = {0, 0, 16, 16}
	red_guy.source = {0, 0, red_guy.source.width, red_guy.source.height}
	red_guy.sight = 60.0
	red_guy.action_timer = 0

	red_guy.texture = rl.LoadTexture("textures/enemies/sprite_enemy.png")
	// red_guy.flipped
	red_guy.direction = 0

	red_guy.speed = 50.0
	red_guy.velocity = {0, 0}
	red_guy.friction = 0.9
	red_guy.acceleration = 200.0
	red_guy.health = 40.0
	red_guy.damage = 5.0
	red_guy.affect_attack = 0
	red_guy.affect_recieved = 0

	// red_guy.iframes
	red_guy.iframe_duration = 1.0

	// tall_guy.position
	tall_guy.size = {0, 0, 16, 16}
	tall_guy.source = {0, 0, tall_guy.source.width, tall_guy.source.height}
	tall_guy.sight = 80.0
	tall_guy.action_timer = 0

	tall_guy.texture = rl.LoadTexture("textures/enemies/sprite_enemy_two.png")
	// tall_guy.flipped
	tall_guy.direction = 0

	tall_guy.speed = 25.0
	tall_guy.velocity = {0, 0}
	tall_guy.friction = 0.85
	tall_guy.acceleration = 150.0
	tall_guy.health = 60.0
	tall_guy.damage = 10.0
	tall_guy.affect_attack = 0
	tall_guy.affect_recieved = 0

	// tall_guy.iframes
	tall_guy.iframe_duration = 1.0
	tall_guy.is_invincible = false

	// snake_guy.position
	snake_guy.size = {0, 0, 16, 8}
	snake_guy.source = {0, 0, snake_guy.source.width, snake_guy.source.height}
	snake_guy.sight = 80.0
	snake_guy.action_timer = 0

	snake_guy.texture = rl.LoadTexture("textures/enemies/sprite_enemy_three.png")
	// snake_guy.flipped
	snake_guy.direction = 0

	snake_guy.speed = 25.0
	snake_guy.velocity = {0, 0}
	snake_guy.friction = 0.95
	snake_guy.acceleration = 250.0
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
	dt := rl.GetFrameTime()
	dist_to_player := rl.Vector2Distance(p.position, {enemy.size.x, enemy.size.y})

	if enemy.affect_recieved != 3 {
		if dist_to_player <= enemy.sight {
			direction := rl.Vector2Normalize(p.position - enemy.position)
			enemy.velocity.x += direction.x * enemy.acceleration * dt
			enemy.velocity.y += direction.y * enemy.acceleration * dt
		} else {
			switch enemy.direction {
			case 0:
				enemy.velocity.x += enemy.acceleration * dt
			case 1:
				enemy.velocity.x -= enemy.acceleration * dt
			case 2:
				enemy.velocity.y += enemy.acceleration * dt
			case 3:
				enemy.velocity.y -= enemy.acceleration * dt
			}
		}

		enemy.velocity.x *= enemy.friction
		enemy.velocity.y *= enemy.friction

		speed := rl.Vector2Length(enemy.velocity)
		if speed > enemy.speed {
			enemy.velocity = (enemy.velocity / speed) * enemy.speed
		}

		enemy.position.x += enemy.velocity.x * dt
		enemy.position.y += enemy.velocity.y * dt

		enemy.size.x = enemy.position.x
		enemy.size.y = enemy.position.y
	}

	if enemy.velocity.x > 0 {
		enemy.flipped = true
	} else if enemy.velocity.x < 0 {
		enemy.flipped = false
	}
}

change_direction :: proc(enemy: ^Enemy) {
	directions: [4]int = {0, 1, 2, 3}
	enemy.direction = rand.choice(directions[:])
}

enemy_collision :: proc(enemy: ^Enemy) {
	enemy_col := int(enemy.position.x / TILE_SIZE)
	enemy_row := int(enemy.position.y / TILE_SIZE)
	search_radius := 2

	start_col := max(0, enemy_col - search_radius)
	end_col := min(tm.width - 1, enemy_col + search_radius)
	start_row := max(0, enemy_row - search_radius)
	end_row := min(tm.height - 1, enemy_row + search_radius)

	enemy_rect := rl.Rectangle {
		x      = enemy.position.x,
		y      = enemy.position.y,
		width  = enemy.size.width,
		height = enemy.size.height,
	}

	enemy_prev_pos := enemy.position - enemy.velocity * delta

	enemy_rect_x := rl.Rectangle {
		x      = enemy.position.x,
		y      = enemy_prev_pos.y,
		width  = enemy.size.width,
		height = enemy.size.height,
	}

	enemy_rect_y := rl.Rectangle {
		x      = enemy_prev_pos.x,
		y      = enemy.position.y,
		width  = enemy.size.width,
		height = enemy.size.height,
	}

	for row in start_row ..= end_row {
		for col in start_col ..= end_col {
			index := row * tm.width + col
			tile := tm.tiles[index]

			if .Collidable in tile.flags {
				tile_rect := rl.Rectangle {
					x      = f32(col * TILE_SIZE),
					y      = f32(row * TILE_SIZE),
					width  = TILE_SIZE,
					height = TILE_SIZE,
				}

				if rl.CheckCollisionRecs(enemy_rect, tile_rect) {
					if rl.CheckCollisionRecs(enemy_rect_x, tile_rect) {
						enemy.position.x = enemy_prev_pos.x
						enemy.velocity.x = 0
					}

					if rl.CheckCollisionRecs(enemy_rect_y, tile_rect) {
						enemy.position.y = enemy_prev_pos.y
						enemy.velocity.y = 0
					}
				}
			}
		}
	}

	for i := len(enemies) - 1; i >= 0; i -= 1 {
		for j := len(projectiles) - 1; j >= 0; j -= 1 {
			if rl.CheckCollisionRecs(enemies[i].size, projectiles[j].source) {
				damage_enemy(i, j)

				if projectiles[j].pierce == 0 {
					unordered_remove(&projectiles, j)
				}

				break
			}
		}
	}
}

damage_enemy :: proc(i: int, j: int) {
	if enemies[i].is_invincible == false {
		enemy_iframes(i)
	}

	if enemies[i].health <= 0 {
		unordered_remove(&enemies, i)
	}
}

enemy_iframes :: proc(i: int) {
	if !enemies[i].is_invincible {
		enemies[i].is_invincible = true
		enemies[i].iframes = enemies[i].iframe_duration
	}
}

enemy_handler :: proc(delta: f32) {
	for &enemy in enemies {
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
