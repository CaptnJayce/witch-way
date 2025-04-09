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
	w.size = {0, 0, 24, 24}
	w.texture = rl.LoadTexture("textures/sprite_wand.png")
	w.flipped = false
	w.damage = 5
	w.source = {0, 0, w.size.width, w.size.height}
	w.selected_spell = 1

	st.fireball = rl.LoadTexture("textures/sprite_fireball.png")
	st.waterbolt = rl.LoadTexture("textures/sprite_waterbolt.png")
	st.sparking = rl.LoadTexture("textures/sprite_sparking.png")
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
