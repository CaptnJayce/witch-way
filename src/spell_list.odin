package game

import rl "vendor:raylib"

// Nebula Spells
NebulaEye :: struct {
	pos:     rl.Rectangle,
	rot:     rl.Vector2,
	texture: rl.Texture2D,
	dur:     f32,
	range:   f32,
}
n_eye: NebulaEye

NebulaBolt :: struct {
	pos:     rl.Rectangle,
	rot:     rl.Vector2,
	texture: rl.Texture2D,
	dur:     f32,
	dmg:     f32,
	status:  string,
}
n_bolt: NebulaBolt

NebulaShield :: struct {
	pos:     rl.Rectangle,
	rot:     rl.Vector2,
	texture: rl.Texture2D,
	dur:     f32,
	def:     f32,
}
n_shield: NebulaShield

init_spell_textures :: proc() {
	n_eye.texture = rl.LoadTexture("textures/spells/icon_eye_of_nebula.png")
	n_bolt.texture = rl.LoadTexture("textures/spells/icon_nebula_bolt.png")
	n_shield.texture = rl.LoadTexture("textures/spells/icon_nebula_shield.png")
}

init_spells :: proc() {
	init_spell_textures()

	// default starting spells
	if len(equipped_spells) == 0 {
		append(&equipped_spells, n_eye)
		append(&equipped_spells, n_bolt)
		append(&equipped_spells, n_shield)
	}

	n_eye.dur = 9999
	n_eye.range = 9999

	n_bolt.dur = 1.5
	n_bolt.dmg = 5
	n_bolt.status = "Crystallium"

	n_shield.dur = 12
	n_shield.def = 3
}
