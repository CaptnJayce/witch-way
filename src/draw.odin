package game

import rl "vendor:raylib"

draw :: proc() {
	for berry in lv_one.pickups {
		rl.DrawTextureRec(berry.texture, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
	}
	for rock in lv_one.obstacles {
		rl.DrawTextureRec(rock.texture, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
	}
	for spell in projectiles {
		rl.DrawTextureRec(spell.texture, spell.source, spell.position, rl.WHITE)
	}
	for &enemy in enemies {
		draw_enemy(&enemy)
	}

	rl.DrawTextureRec(house.texture, house_source, house.xy, rl.WHITE)

	rl.DrawRectangleLinesEx(current_bounds^, 2, rl.WHITE) // bounds

	draw_tilemap()

	draw_player()
	draw_wand()
}

flip_texture :: proc(flip: bool, texture: rl.Texture2D, size: rl.Rectangle) -> rl.Rectangle {
	source := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = size.width,
		height = size.height,
	}

	if flip {
		source.width = -source.width
	}

	return source
}
