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
	w.size = {0, 0, 12, 12}
	w.texture = rl.LoadTexture("textures/player/wand.png")
	w.flipped = false
	w.damage = 5
	w.source = {0, 0, w.size.width, w.size.height}
	w.selected_spell = 1
}

draw_wand :: proc() {
	w.source = flip_texture(w.flipped, w.texture, w.size)

	if !w.flipped {
		rl.DrawTexturePro(
			w.texture,
			w.source,
			{p.position.x, p.position.y - 2, 12, 12},
			{},
			30,
			rl.WHITE,
		)
	}

	if w.flipped {
		rl.DrawTexturePro(
			w.texture,
			w.source,
			{p.position.x - 10, p.position.y + 3, 12, 12},
			{},
			-30,
			rl.WHITE,
		)

	}
}

wand_handler :: proc() {

}
