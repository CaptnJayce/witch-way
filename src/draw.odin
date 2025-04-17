package game

import "core:fmt"
import rl "vendor:raylib"

SW: i32 = 1920
SH: i32 = 1080
SWH: i32 = SW / 2
SHH: i32 = SH / 2

draw :: proc() {
	for berry in l.pickups {
		rl.DrawTextureRec(berry.texture, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
	}
	for rock in l.obstacles {
		rl.DrawTextureRec(rock.texture, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
	}
	for spell in l.projectiles {
		rl.DrawTextureRec(spell.texture, spell.source, spell.position, rl.WHITE)
	}
	for &enemy in l.enemies {
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
