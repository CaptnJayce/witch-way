package game

import "core:fmt"
import rl "vendor:raylib"

Player :: struct {
	position:        rl.Vector2,
	velocity:        rl.Vector2,
	size:            rl.Rectangle,
	texture:         rl.Texture2D,
	flipped:         bool,
	speed:           f32,
	max_health:      f32,
	health:          f32,
	damage:          f32,
	can_take_damage: bool,
	iframe_timer:    f32,
	pickup:          f32,
	source:          rl.Rectangle,
	acceleration:    f32,
	friction:        f32,
}

p: Player
player_prev_pos: rl.Vector2
render_rect: rl.Rectangle = {}
mouse_rect: rl.Rectangle = {}

mouse_handler :: proc() {
	mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), c)

	mouse_rect = {
		x      = mp.x - 2,
		y      = mp.y,
		width  = 4,
		height = 4,
	}
}

init_player :: proc() {
	p.position = {-50, -50}
	p.size = {16, 32, 16, 32}
	p.texture = rl.LoadTexture("textures/sprite_player.png")
	p.flipped = false
	p.speed = 200.0
	p.velocity = {0, 0}
	p.max_health = 10
	p.health = p.max_health
	p.damage = 5
	p.can_take_damage = true
	p.pickup = 40.0
	p.source = {0, 0, p.size.width, p.size.height}
	p.acceleration = 1400.0
	p.friction = 600.0
}

// wait 1.3 seconds before taking damage again
player_iframes :: proc(delta: f32) {
	p.can_take_damage = false

	if !p.can_take_damage {
		p.iframe_timer += delta

		if p.iframe_timer >= 1.3 {
			p.can_take_damage = true
		}
	}
}

damage_recieved :: proc(damage: f32) {
	if p.can_take_damage == true {
		p.health -= damage
		p.iframe_timer = 0
		player_iframes(delta)
	}
}

player_movement :: proc() {
	player_prev_pos = p.position
	move_dir := rl.Vector2{}

	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		p.flipped = true
		w.flipped = true
		move_dir.x -= 1
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		p.flipped = false
		w.flipped = false
		move_dir.x += 1
	}
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) do move_dir.y -= 1
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) do move_dir.y += 1

	if move_dir.x != 0 && move_dir.y != 0 {
		move_dir = move_dir / rl.Vector2Length(move_dir)
	}

	target_velocity := move_dir * p.speed

	max_delta := p.acceleration * delta
	delta_vel := target_velocity - p.velocity

	if rl.Vector2LengthSqr(delta_vel) <= (max_delta * max_delta) {
		p.velocity = target_velocity
	} else {
		p.velocity += (delta_vel / rl.Vector2Length(delta_vel)) * max_delta
	}

	if move_dir.x == 0 && move_dir.y == 0 {
		friction_force := p.friction * delta
		if rl.Vector2LengthSqr(p.velocity) <= (friction_force * friction_force) {
			p.velocity = {0, 0}
		} else {
			p.velocity -= (p.velocity / rl.Vector2Length(p.velocity)) * friction_force
		}
	}

	p.position += p.velocity * delta
}

player_collision :: proc() {
	player_rect := rl.Rectangle {
		x      = p.position.x - p.size.x / 2,
		y      = p.position.y - p.size.y / 2,
		width  = p.size.x,
		height = p.size.y,
	}

	player_rect_y := rl.Rectangle {
		x      = player_prev_pos.x - p.size.x / 2,
		y      = p.position.y - p.size.y / 2,
		width  = p.size.x,
		height = p.size.y,
	}

	player_rect_x := rl.Rectangle {
		x      = p.position.x - p.size.x / 2,
		y      = player_prev_pos.y - p.size.y / 2,
		width  = p.size.x,
		height = p.size.y,
	}

	for j, idx in enemies {
		if rl.CheckCollisionRecs(player_rect, enemies[idx].size) && p.can_take_damage == true {
			damage_recieved(enemies[idx].damage)
		}
	}

	player_col := int(p.position.x / TILE_SIZE)
	player_row := int(p.position.y / TILE_SIZE)

	search_radius := 2

	start_col := max(0, player_col - search_radius)
	end_col := min(tm.width - 1, player_col + search_radius)
	start_row := max(0, player_row - search_radius)
	end_row := min(tm.height - 1, player_row + search_radius)

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

				if rl.CheckCollisionRecs(player_rect, tile_rect) {
					if rl.CheckCollisionRecs(player_rect_x, tile_rect) {
						p.position.x = player_prev_pos.x
						p.velocity.x = 0
					}

					if rl.CheckCollisionRecs(player_rect_y, tile_rect) {
						p.position.y = player_prev_pos.y
						p.velocity.y = 0
					}
				}
			}
		}
	}
}

draw_player :: proc() {
	p.source = flip_texture(p.flipped, p.texture, p.size)
	rl.DrawTextureRec(p.texture, p.source, p.position - {p.size.x / 2, p.size.y / 2}, rl.WHITE)
}

player_handler :: proc() {
	player_movement()
	player_collision()

	render_rect = {
		p.position.x - f32(SWH) / 2,
		p.position.y - f32(SHH) / 2,
		f32(SW) / 2,
		f32(SH) / 2,
	}
}
