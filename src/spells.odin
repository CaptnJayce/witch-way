package game

import rl "vendor:raylib"

// i manage spells with enum to make as it makes it easier to apply status affects to enemies
// may change later
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
	// data
	type:      CurrentSpell,
	position:  rl.Vector2,
	size:      rl.Rectangle,
	direction: rl.Vector2,

	// texture
	texture:   rl.Texture2D,
	source:    rl.Rectangle,

	// stats
	damage:    f32,
	speed:     f32,
	delay:     f32,
	fire_rate: f32,
	pierce:    int,
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

// add one to actual amount of pierce wanted, no pierce == 1
spell_change :: proc() {
	if cs == .Fireball {
		s.type = .Fireball
		s.texture = st.fireball
		s.source = {0, 0, 48, 48}
		s.damage = 10.0
		s.speed = 100.0
		s.fire_rate = 2.0
		s.pierce = 5
	}

	if cs == .Waterbolt {
		s.type = .Waterbolt
		s.texture = st.waterbolt
		s.source = {0, 0, 24, 24}
		s.damage = 5.0
		s.speed = 200.0
		s.fire_rate = 1.0
		s.pierce = 2
	}

	if cs == .Sparking {
		s.type = .Sparking
		s.texture = st.sparking
		s.source = {0, 0, 15, 40}
		s.damage = 1.0
		s.speed = 500.0
		s.fire_rate = 1.5
		s.pierce = 1
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

	if s.type != .None {
		append(
			&l.projectiles,
			Spell {
				spell.type,
				spell.position,
				s.size,
				direction,
				s.texture,
				s.source,
				s.damage,
				s.speed,
				s.delay,
				s.fire_rate,
				s.pierce,
			},
		)
	}
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

status_handler :: proc(i: int, j: int) {
	if l.enemies[i].affect_recieved == 0 {
		if l.projectiles[j].type == .Fireball {
			l.enemies[i].affect_recieved = 1
		}
		if l.projectiles[j].type == .Waterbolt {
			l.enemies[i].affect_recieved = 2
		}
		if l.projectiles[j].type == .Sparking {
			l.enemies[i].affect_recieved = 3
		}
	}
}
