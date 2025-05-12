package game

import "core:fmt"
import rl "vendor:raylib"

SpellType :: enum {
	None,
	NebulaEye,
	NebulaBolt,
	NebulaShield,
}

SpellData :: struct {
	// info
	name:          string,
	desc:          string,
	icon:          rl.Texture2D,
	type:          string,
	unlocked:      bool,

	// costs
	cooldown:      f32,

	// properties
	source:        rl.Rectangle,
	dir:           rl.Vector2,
	rot:           f32,
	speed:         f32,
	lifetime:      f32,
	pierce:        int,

	// offensive 
	dmg:           f32,
	dot:           f32,

	// defensive
	dmg_reduction: f32,
	dot_reduction: f32,
	healing:       f32,

	// effects
	status:        string, // use string to apply in apply_status
	status_val:    f32,

	// visual
	pj_colour:     rl.Color,
}

spell_data: [SpellType]SpellData = {
	.None = {},
	.NebulaEye = {
		name = "Eye of The Nebula",
		desc = "A flare that seeks out your objectives",
		type = "Utility",
		unlocked = false,
		cooldown = 300,
		speed = 5,
		lifetime = 2400000000,
		pj_colour = rl.Color{80, 100, 80, 255},
	},
	.NebulaBolt = {
		name = "Nebula Bolt",
		desc = "A bolt of crystal which shatters on impact",
		type = "Projectile",
		unlocked = false,
		cooldown = 1.5,
		speed = 100,
		lifetime = 4,
		dmg = 5,
		status = "Shatter",
		status_val = 10,
		pj_colour = rl.Color{80, 100, 80, 255},
	},
	.NebulaShield = {
		name = "Nebula Shield",
		desc = "A rudimentary defensive spell, negates a minor amount of damage",
		type = "Buff",
		unlocked = false,
		cooldown = 12,
		lifetime = 2400000000,
		dmg_reduction = 10,
		dot_reduction = 5,
		pj_colour = rl.Color{80, 100, 80, 255},
	},
}

nebulaEye := spell_data[.NebulaEye]
nebulaBolt := spell_data[.NebulaBolt]
nebulaShield := spell_data[.NebulaShield]

init_spells :: proc() {
	nebulaEye.icon = rl.LoadTexture("textures/spells/nebula_eye.png")
	nebulaBolt.icon = rl.LoadTexture("textures/spells/nebula_bolt.png")
	nebulaShield.icon = rl.LoadTexture("textures/spells/nebula_shield.png")

	if len(p.equipped_spells) == 0 {
		append(&p.equipped_spells, nebulaEye)
		append(&p.equipped_spells, nebulaBolt)
		append(&p.equipped_spells, nebulaShield)
	}
}
