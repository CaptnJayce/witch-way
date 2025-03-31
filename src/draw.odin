package game

import rl "vendor:raylib"

SW: i32 = 1280
SH: i32 = 720
SWH: i32 = SW / 2
SHH: i32 = SH / 2

init_sprite :: proc() {
	k.texture = rl.LoadTexture("textures/sprite_sheet_pickups-export.png")
	r.texture = rl.LoadTexture("textures/sprite_sheet_rocks-export.png")
}

draw :: proc() {
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
	enemy_source := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = 24,
		height = 24,
	}

	for berry in l.pickups {
		rl.DrawTextureRec(berry.texture, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
	}
	for rock in l.obstacles {
		rl.DrawTextureRec(rock.texture, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
	}
	for enemy in l.enemies {
		rl.DrawTextureRec(enemy.texture, enemy_source, {enemy.size.x, enemy.size.y}, rl.WHITE)
	}
}

flip_texture :: proc(flip: bool) {
	width := f32(p.texture.width)
	height := f32(p.texture.height)

	source := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = p.size.x,
		height = p.size.y,
	}

	if flip {
		source.width = -source.width
	}

	rl.DrawTextureRec(p.texture, source, p.position - p.size / 2, rl.WHITE)
}
