package game

import rl "vendor:raylib"
import "core:fmt"

draw :: proc() {
    // ensure xy & wh is multiplied by three as i export the sprites with 300% scaling in aseprite
    berry_source := rl.Rectangle {
        x = 0,
        y = 0,
        width = 48,
        height = 48,
    }
    rock_source := rl.Rectangle {
        x = 0,
        y = 0,
        width = 48,
        height = 48,
    }

    for berry in l.pickups {
        rl.DrawTextureRec(berry.sprite, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
    }
    for rock in l.obstacles {
        rl.DrawTextureRec(rock.sprite, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
    }
}

flip_texture :: proc(p: Player, pos: rl.Vector2, flip: bool) {
    width := f32(p.texture.width)
    height := f32(p.texture.height)

    source := rl.Rectangle {
        x = 0,
        y = 0,
        width = p.size.x,
        height = p.size.y,
    }

    if flip {
        source.width = -source.width
    }

    rl.DrawTextureRec(p.texture, source, p.position - p.size / 2, rl.WHITE)
}

