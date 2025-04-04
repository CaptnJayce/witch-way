package game

import rl "vendor:raylib"

SW: i32 = 1280
SH: i32 = 720
SWH: i32 = SW / 2
SHH: i32 = SH / 2

// ensure xy & wh is multiplied by three as i export the sprites with 300% scaling in aseprite
berry_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 48,
	height = 48,
}
rock_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 48,
	height = 48,
}

init_sprite :: proc() {
	k.texture = rl.LoadTexture("textures/sprite_sheet_pickups-export.png")
	r.texture = rl.LoadTexture("textures/sprite_sheet_rocks-export.png")
}

draw :: proc() {
	for berry in l.pickups {
		rl.DrawTextureRec(berry.texture, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
	}
	for rock in l.obstacles {
		rl.DrawTextureRec(rock.texture, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
	}

	for &enemy in l.enemies {
		draw_enemy(&enemy)
	}

	draw_player()
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
