package game

import rl "vendor:raylib"

berry_source := rl.Rectangle {
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

rock_source := rl.Rectangle {
	x      = 0,
	y      = 0,
	width  = 16,
	height = 16,
}
Rock :: struct {
	size:    rl.Rectangle,
	texture: rl.Texture2D,
}
r: Rock

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

init_objects :: proc() {
	house.size = {100, -300, house_source.width - 200, house_source.height - 340}
	house.texture = rl.LoadTexture("textures/sprite_player_home.png")
	house.xy = {0, -500}
}

init_sprite :: proc() {
	k.texture = rl.LoadTexture("textures/sprite_krushem.png")
	r.texture = rl.LoadTexture("textures/sprite_rock.png")

	// extras
	extras_texture := rl.LoadTexture("textures/sprite_sheet_extras.png")

	grass.texture = extras_texture
	grass_two.texture = extras_texture

	anemone.texture = extras_texture
	anemone_two.texture = extras_texture
}
