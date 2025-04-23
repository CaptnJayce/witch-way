package game

import rl "vendor:raylib"

draw :: proc() {
	draw_tilemap()

	for spell in projectiles {
		rl.DrawTextureRec(spell.texture, spell.source, spell.position, rl.WHITE)
	}
	for &enemy in enemies {
		draw_enemy(&enemy)
	}

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
