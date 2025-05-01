package game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"

show_spell_menu := false
show_spell_drawer := false

highlight_attunement := false
enable_attunement := false

CurrentSpellData :: struct {
	name:          string,
	desc:          string,
	icon:          rl.Texture2D,
	unlocked:      bool,
	cooldown:      f32,
	source:        rl.Rectangle,
	dir:           rl.Vector2,
	pj_speed:      f32,
	pj_size:       f32,
	lifetime:      f32,
	pierce:        int,
	dmg:           f32,
	dot:           f32,
	dmg_reduction: f32,
	dot_reduction: f32,
	healing:       f32,
	slow:          f32,
	stun:          f32,
	shatter:       f32,
	pj_colour:     rl.Color,
}

cSpell: SpellType
cSpellData: CurrentSpellData
projectiles: [dynamic]CurrentSpellData

spell_select :: proc() {
	switch {
	case rl.IsKeyPressed(.ONE):
		cSpell = .NebulaEye
	case rl.IsKeyPressed(.TWO):
		cSpell = .NebulaBolt
	case rl.IsKeyPressed(.THREE):
		cSpell = .NebulaShield
	}
}

draw_spell_menu :: proc() {
	if rl.IsKeyPressed(.LEFT_CONTROL) {
		show_spell_menu = !show_spell_menu
	}

	if show_spell_menu {
		rl.DrawCircleLinesV(p.position, 150, rl.ORANGE)
	}
}

unlock_spell :: proc(id: string) {
	if id == "first_attunement" {
		nebulaEye.unlocked = true
		nebulaBolt.unlocked = true
		nebulaShield.unlocked = true
	}
}
