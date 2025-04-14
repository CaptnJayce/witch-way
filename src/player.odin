package game

import "core:fmt"
import rl "vendor:raylib"

Player :: struct {
	position:        rl.Vector2,
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
}

p: Player
player_prev_pos: rl.Vector2

init_player :: proc() {
	p.position = {50, 50}
	p.size = {36, 84, 36, 84}
	p.texture = rl.LoadTexture("textures/sprite_player.png")
	p.flipped = false
	p.speed = 250.0
	p.max_health = 10
	p.health = p.max_health
	p.damage = 5
	p.can_take_damage = true
	p.pickup = 75.0
	p.source = {0, 0, p.size.width, p.size.height}
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
	// store pos from a frame before for collisions
	player_prev_pos = p.position

	if rl.IsKeyDown(.W) {p.position.y -= p.speed * rl.GetFrameTime()}
	if rl.IsKeyDown(.S) {p.position.y += p.speed * rl.GetFrameTime()}
	if rl.IsKeyDown(.A) {
		p.flipped = true
		w.flipped = true
		p.position.x -= p.speed * rl.GetFrameTime()
	}
	if rl.IsKeyDown(.D) {
		p.flipped = false
		w.flipped = false
		p.position.x += p.speed * rl.GetFrameTime()
	}
}

player_collision :: proc() {
	for j, idx in l.pickups {
		if rl.Vector2Distance(p.position, {l.pickups[idx].size.x, l.pickups[idx].size.y}) <=
		   p.pickup {
			if rl.IsKeyPressed(.F) {
				unordered_remove(&l.pickups, idx)
				i.slots[0].count += 1
				break
			}
		}
	}

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

	for j, idx in l.obstacles {
		if rl.CheckCollisionRecs(player_rect, l.obstacles[idx].size) {

			if rl.CheckCollisionRecs(player_rect_x, l.obstacles[idx].size) {
				p.position.x = player_prev_pos.x
			}

			if rl.CheckCollisionRecs(player_rect_y, l.obstacles[idx].size) {
				p.position.y = player_prev_pos.y
			}
		}
	}

	for j, idx in l.enemies {
		if rl.CheckCollisionRecs(player_rect, l.enemies[idx].size) {
			damage_recieved(l.enemies[idx].damage)
		}
	}

	if rl.CheckCollisionRecs(player_rect_y, house.size) {
		p.position.y = player_prev_pos.y
	}
	if rl.CheckCollisionRecs(player_rect_x, house.size) {
		p.position.x = player_prev_pos.x
	}
}

draw_player :: proc() {
	p.source = flip_texture(p.flipped, p.texture, p.size)
	rl.DrawTextureRec(p.texture, p.source, p.position - {p.size.x / 2, p.size.y / 2}, rl.WHITE)
}

player_handler :: proc() {
	player_movement()
	player_collision()
}
