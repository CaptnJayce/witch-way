package game

import "core:encoding/json"
import "core:fmt"
import "core:math"
import "core:os"
import rl "vendor:raylib"

show_spell_menu := false
show_spell_drawer := false

highlight_attunement := false
enable_attunement := false

cSpell: SpellType
cooldown: f32
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

	i: f32 = 0
	for i < cooldown {
		cooldown -= rl.GetFrameTime()
		i += 1
	}

	if rl.IsMouseButtonPressed(.LEFT) && cooldown <= 0 {
		direction := rl.Vector2Normalize(mp - p.position)

		switch {
		case cSpell == .NebulaEye:
			spell_data[cSpell].source = {sp_x, sp_y, 60, 60}
			spell_data[cSpell].dir = direction
			append(&projectiles, spell_data[cSpell])
		case cSpell == .NebulaBolt:
			spell_data[cSpell].source = {sp_x, sp_y, 16, 4}
			spell_data[cSpell].dir = direction
			spell_data[cSpell].txt = nebulaBolt.txt
			append(&projectiles, spell_data[cSpell])
		case cSpell == .NebulaShield:
			spell_data[cSpell].source = {sp_x, sp_y, 25, 30}
			spell_data[cSpell].dir = direction
			append(&projectiles, spell_data[cSpell])
		}

		cooldown = spell_data[cSpell].cooldown
	}
}

update_spell :: proc() {
	i := 0
	for i < len(projectiles) {
		proj := &projectiles[i]

		if proj.type == "Projectile" {
			proj.source.x += proj.dir.x * proj.speed * rl.GetFrameTime()
			proj.source.y += proj.dir.y * proj.speed * rl.GetFrameTime()
		}

		projectiles[i].time += rl.GetFrameTime()
		if proj.time >= proj.lifetime {
			unordered_remove(&projectiles, i)
		}

		i += 1
	}
}

draw_spell :: proc() {
	for &proj in projectiles {
		if len(projectiles) != 0 {
			if proj.type == "Projectile" {
				rot := math.atan2(proj.dir.y, proj.dir.x)

				rect := rl.Rectangle {
					x      = proj.source.x,
					y      = proj.source.y,
					width  = proj.source.width,
					height = proj.source.height,
				}

				origin := rl.Vector2{proj.source.width / 4, proj.source.height / 4}

				rl.DrawTextureEx(proj.txt, {rect.x, rect.y}, rot * rl.RAD2DEG, 1, rl.WHITE)
				// rl.DrawRectanglePro(rect, origin, rot * rl.RAD2DEG, rl.DARKPURPLE)
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
