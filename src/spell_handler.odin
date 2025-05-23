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

		spell := &spell_data[cSpell]

		if game_time - spell.last_cast < spell.cooldown {
			fmt.println("spell is on cooldown")
			return
		}
		fmt.println("casting", spell)

		spell.last_cast = game_time

		#partial switch cSpell {
		case .NebulaEye:
			spell.source = {sp_x, sp_y, 60, 60}
			spell.dir = direction
			spell.txt = nebulaEye.txt
			append(&projectiles, spell^)
		case .NebulaBolt:
			spell.source = {sp_x, sp_y, 16, 4}
			spell.dir = direction
			spell.txt = nebulaBolt.txt
			append(&projectiles, spell^)
		case .NebulaShield:
			spell.source = {sp_x, sp_y, 25, 30}
			spell.dir = direction
			spell.txt = nebulaShield.txt
			append(&projectiles, spell^)
		}
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
			rect := rl.Rectangle {
				x      = proj.source.x,
				y      = proj.source.y,
				width  = proj.source.width,
				height = proj.source.height,
			}

			if proj.type == "Projectile" {
				rot := math.atan2(proj.dir.y, proj.dir.x)
				origin := rl.Vector2{proj.source.width / 4, proj.source.height / 4}

				rl.DrawTextureEx(proj.txt, {rect.x, rect.y}, rot * rl.RAD2DEG, 1, rl.WHITE)
			}
			if proj.type == "Utility" {
				origin := rl.Vector2{proj.source.width / 4, proj.source.height / 4}

				rl.DrawTextureEx(proj.txt, {rect.x, rect.y}, 0, 1, rl.WHITE)
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
