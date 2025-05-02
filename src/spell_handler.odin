package game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"

show_spell_menu := false
show_spell_drawer := false

highlight_attunement := false
enable_attunement := false

cSpell: SpellType
projectiles: [dynamic]SpellData

select_spell :: proc() {
	switch {
	case rl.IsKeyPressed(.ONE):
		cSpell = .NebulaEye
	case rl.IsKeyPressed(.TWO):
		cSpell = .NebulaBolt
	case rl.IsKeyPressed(.THREE):
		cSpell = .NebulaShield
	}
}

cast_spell :: proc() {
	sp_x := p.position.x
	sp_y := p.position.y

	if rl.IsMouseButtonPressed(.LEFT) {
		direction := rl.Vector2Normalize(mp - p.position)

		switch {
		case cSpell == .NebulaEye:
			spell_data[cSpell].source = {sp_x, sp_y, 60, 60}
			spell_data[cSpell].dir = direction
			append(&projectiles, spell_data[cSpell])
		case cSpell == .NebulaBolt:
			spell_data[cSpell].source = {sp_x, sp_y, 10, 20}
			spell_data[cSpell].dir = direction
			append(&projectiles, spell_data[cSpell])
		case cSpell == .NebulaShield:
			spell_data[cSpell].source = {sp_x, sp_y, 25, 30}
			spell_data[cSpell].dir = direction
			append(&projectiles, spell_data[cSpell])
		}
	}
}

update_spell :: proc() {
	// TODO : Update spell position and collision
	for &proj in projectiles {
		if len(projectiles) != 0 {
			if proj.type == "Projectile" {
				proj.source.x += proj.dir.x * proj.speed * rl.GetFrameTime()
				proj.source.y += proj.dir.y * proj.speed * rl.GetFrameTime()
			}
			if proj.type == "Utility" {
			}
			if proj.type == "Buff" {
			}
			if proj.type == "Debuff" {
			}
		}
	}
}

draw_spell :: proc() {
	// TODO : Draw spell
	for &proj in projectiles {
		if len(projectiles) != 0 {
			if proj.type == "Projectile" {
				rl.DrawRectangleV(
					{proj.source.x, proj.source.y},
					{proj.source.width, proj.source.height},
					rl.DARKPURPLE,
				)
			}
			if proj.type == "Utility" {
			}
			if proj.type == "Buff" {
			}
			if proj.type == "Debuff" {
			}
		}
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
