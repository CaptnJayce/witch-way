package game

import rl "vendor:raylib"

Krushem :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
k: Krushem

house_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 64,
	height = 64,
}
House :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
	xy:      rl.Vector2,
}
house: House

grass_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 16,
	height = 16,
}
Grass :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
grass: Grass

grass_source_two := rl.Rectangle {
	x      = 16,
	y      = 0,
	width  = 16,
	height = 16,
}
GrassTwo :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
grass_two: GrassTwo

anemone_source := rl.Rectangle {
	x      = 72,
	y      = 0,
	width  = 16,
	height = 16,
}
Anemone :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
anemone: Anemone

anemone_source_two := rl.Rectangle {
	x      = 96,
	y      = 0,
	width  = 16,
	height = 16,
}
AnemoneTwo :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
anemone_two: Anemone

attunement_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 16,
	height = 16,
}
AttunementPoint :: struct {
	texture: rl.Texture2D,
	radius:  rl.Vector2,
}
attunement_p: AttunementPoint

NebulaSpellIcons :: struct {
	eye:    rl.Texture2D,
	bolt:   rl.Texture2D,
	shield: rl.Texture2D,
}
i_nebula: NebulaSpellIcons

init_sprite :: proc() {
	k.texture = rl.LoadTexture("textures/props/sprite_krushem.png")

	extras_texture := rl.LoadTexture("textures/props/sprite_sheet_extras.png")

	grass.texture = extras_texture
	grass_two.texture = extras_texture

	anemone.texture = extras_texture
	anemone_two.texture = extras_texture

	attunement_p.texture = rl.LoadTexture("textures/structures/attunement_point.png")
	attunement_p.radius = {0, 0}

	i_nebula.eye = rl.LoadTexture("textures/spells/icon_eye_of_nebula.png")
	i_nebula.bolt = rl.LoadTexture("textures/spells/icon_nebula_bolt.png")
	i_nebula.shield = rl.LoadTexture("textures/spells/icon_nebula_shield.png")
}
