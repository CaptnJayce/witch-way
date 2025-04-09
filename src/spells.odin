package game

import "core:fmt"
import rl "vendor:raylib"

CurrentSpell :: enum {
	None,
	Fireball,
	Waterbolt,
	Sparking,
}

SpellTextures :: struct {
	fireball:  rl.Texture2D,
	waterbolt: rl.Texture2D,
	sparking:  rl.Texture2D,
}

Spell :: struct {
	type:      CurrentSpell,
	texture:   rl.Texture2D,
	position:  rl.Vector2,
	size:      rl.Rectangle,
	source:    rl.Rectangle,
	damage:    f32,
	speed:     f32,
	delay:     f32,
	fire_rate: f32,
	direction: rl.Vector2,
}

s: Spell
cs: CurrentSpell
st: SpellTextures

spell_select :: proc() {
	if rl.IsKeyPressed(.ONE) {
		cs = .Fireball
		spell_change()
	}
	if rl.IsKeyPressed(.TWO) {
		cs = .Waterbolt
		spell_change()
	}
	if rl.IsKeyPressed(.THREE) {
		cs = .Sparking
		spell_change()
	}
}

spell_change :: proc() {
	if cs == .Fireball {
		s.type = .Fireball
		s.texture = st.fireball
		s.source = {0, 0, 48, 48}
		s.damage = 10.0
		s.speed = 100.0
		s.fire_rate = 2.0
	}

	if cs == .Waterbolt {
		s.type = .Waterbolt
		s.texture = st.waterbolt
		s.source = {0, 0, 24, 24}
		s.damage = 5.0
		s.speed = 200.0
		s.fire_rate = 1.0
	}

	if cs == .Sparking {
		s.type = .Sparking
		s.texture = st.sparking
		s.source = {0, 0, 15, 40}
		s.damage = 1.0
		s.speed = 500.0
		s.fire_rate = 1.5
	}
}

spell_direction: rl.Vector2
spell_fire :: proc(spell: ^Spell) {
	spell.position = p.position
	spell.size = {spell.position.x, spell.position.y, spell.source.width, spell.source.height}

	direction := mp - p.position

	if rl.Vector2Length(direction) > 0 {
		direction = rl.Vector2Normalize(direction)
	}

	append(
		&l.projectiles,
		Spell {
			spell.type,
			s.texture,
			spell.position,
			s.size,
			s.source,
			s.damage,
			s.speed,
			s.delay,
			s.fire_rate,
			direction,
		},
	)
}

timer: f32
spell_handler :: proc(delta: f32) {
	spell_select()

	timer += delta
	if rl.IsMouseButtonPressed(.LEFT) && timer >= s.fire_rate {
		spell_fire(&s)
		timer = 0
	}

	for &spell in l.projectiles {
		spell.delay += delta

		spell.position.x += spell.direction.x * spell.speed * delta
		spell.position.y += spell.direction.y * spell.speed * delta

		spell.size.x += spell.direction.x * spell.speed * delta
		spell.size.y += spell.direction.y * spell.speed * delta

		if spell.delay >= 2.0 {
			ordered_remove(&l.projectiles, 0)
		}
	}
}
