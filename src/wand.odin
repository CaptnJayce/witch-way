package game

import rl "vendor:raylib"

Wand :: struct {
	position:       rl.Vector2,
	size:           rl.Rectangle,
	texture:        rl.Texture2D,
	flipped:        bool,
	damage:         f32,
	source:         rl.Rectangle,
	selected_spell: int,
}

w: Wand

init_wand :: proc() {
	w.size = {0, 0, 16, 16}
	w.texture = rl.LoadTexture("textures/player/sprite_wand.png")
	w.flipped = false
	w.damage = 5
	w.source = {0, 0, w.size.width, w.size.height}
	w.selected_spell = 1
}

draw_wand :: proc() {
	w.source = flip_texture(w.flipped, w.texture, w.size)

	if w.flipped {
		rl.DrawTextureRec(
			w.texture,
			w.source,
			{p.position.x - w.size.width, p.position.y - w.size.height / 3},
			rl.WHITE,
		)
	}

	if !w.flipped {
		rl.DrawTextureRec(
			w.texture,
			w.source,
			{p.position.x, p.position.y - w.size.height / 3},
			rl.WHITE,
		)
	}
}

wand_handler :: proc() {

}
