package game

import rl "vendor:raylib"

krushem_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 16,
	height = 16,
}
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


init_objects :: proc() {
	k.texture = rl.LoadTexture("textures/props/sprite_krushem.png")
	k.size = rl.Rectangle{0, 0, 16, 16}

	house.size = {100, -300, house_source.width - 200, house_source.height - 340}
	house.texture = rl.LoadTexture("textures/sprite_player_home.png")
	house.xy = {0, -500}

	attunement_p.texture = rl.LoadTexture("textures/structures/attunement_point.png")
	attunement_p.radius = {0, 0}
}

init_sprite :: proc() {
	// extras
	extras_texture := rl.LoadTexture("textures/props/sprite_sheet_extras.png")

	grass.texture = extras_texture
	grass_two.texture = extras_texture

	anemone.texture = extras_texture
	anemone_two.texture = extras_texture
}
