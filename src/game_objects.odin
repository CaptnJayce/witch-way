package game

import rl "vendor:raylib"

// PLANTS
Krushem :: struct {
	texture: rl.Texture2D,
}
k: Krushem
Heartium :: struct {
	texture: rl.Texture2D,
}
h: Heartium

// SPRITESHEETS
Spritesheets :: struct {
	txt_grass: rl.Texture2D,
}
sheet: Spritesheets

SHEET_WIDTH :: 48
SHEET_HEIGHT :: 48
cols := SHEET_WIDTH / TILE_SIZE
rows := SHEET_HEIGHT / TILE_SIZE


tl_grass := rl.Rectangle{0, 0, f32(TILE_SIZE), f32(TILE_SIZE)}
tm_grass := rl.Rectangle{TILE_SIZE, 0, f32(TILE_SIZE), f32(TILE_SIZE)}
tr_grass := rl.Rectangle{TILE_SIZE * 2, 0, f32(TILE_SIZE), f32(TILE_SIZE)}

ml_grass := rl.Rectangle{0, TILE_SIZE, f32(TILE_SIZE), f32(TILE_SIZE)}
mm_grass := rl.Rectangle{TILE_SIZE, TILE_SIZE, f32(TILE_SIZE), f32(TILE_SIZE)}
mr_grass := rl.Rectangle{TILE_SIZE * 2, TILE_SIZE, f32(TILE_SIZE), f32(TILE_SIZE)}

bl_grass := rl.Rectangle{0, TILE_SIZE * 2, f32(TILE_SIZE), f32(TILE_SIZE)}
bm_grass := rl.Rectangle{TILE_SIZE, TILE_SIZE * 2, f32(TILE_SIZE), f32(TILE_SIZE)}
br_grass := rl.Rectangle{TILE_SIZE * 2, TILE_SIZE * 2, f32(TILE_SIZE), f32(TILE_SIZE)}

Rock :: struct {
	texture: rl.Texture2D,
}

NebulaSpellIcons :: struct {
	eye:    rl.Texture2D,
	bolt:   rl.Texture2D,
	shield: rl.Texture2D,
}
i_nebula: NebulaSpellIcons

init_sprite :: proc() {
	sheet.txt_grass = rl.LoadTexture("textures/spritesheets/spritesheet_grass.png")

	k.texture = rl.LoadTexture("textures/props/sprite_krushem.png")
	h.texture = rl.LoadTexture("textures/props/sprite_heartium.png")

	extras_texture := rl.LoadTexture("textures/props/sprite_sheet_extras.png")

	i_nebula.eye = rl.LoadTexture("textures/spells/icon_eye_of_nebula.png")
	i_nebula.bolt = rl.LoadTexture("textures/spells/icon_nebula_bolt.png")
	i_nebula.shield = rl.LoadTexture("textures/spells/icon_nebula_shield.png")
}
