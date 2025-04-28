package game

import rl "vendor:raylib"

draw :: proc() {
	draw_tilemap()

	for &enemy in enemies {
		draw_enemy(&enemy)
	}

	if highlight_attunement {
		rl.DrawTextureV(attunement_p.texture, {0, 0}, rl.BLUE)
	} else {
		rl.DrawTextureV(attunement_p.texture, {0, 0}, rl.WHITE)
	}

	draw_player()
	draw_wand()
	draw_spell_menu()
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
