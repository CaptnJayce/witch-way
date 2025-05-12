package game

import rl "vendor:raylib"

// TILES
TextureAtlas :: struct {
	texture:  rl.Texture,
	variants: []rl.Rectangle,
}
Grass :: struct {
	atlas: TextureAtlas,
}
g: Grass

Krushem :: struct {
	texture: rl.Texture2D,
}
k: Krushem
Heartium :: struct {
	texture: rl.Texture2D,
}
h: Heartium

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
	g.atlas.texture = rl.LoadTexture("textures/tiles/grass_tile_atlas.png")
	g.atlas.variants = make([]rl.Rectangle, GRASS_VARIANTS)

	for i in 0 ..< GRASS_VARIANTS {
		g.atlas.variants[i] = rl.Rectangle {
			x      = 0,
			y      = f32(i * TILE_SIZE),
			width  = TILE_SIZE,
			height = TILE_SIZE,
		}
	}

	k.texture = rl.LoadTexture("textures/props/krushem.png")
	h.texture = rl.LoadTexture("textures/props/heartium.png")

	i_nebula.eye = rl.LoadTexture("textures/spells/nebula_eye.png")
	i_nebula.bolt = rl.LoadTexture("textures/spells/nebula_bolt.png")
	i_nebula.shield = rl.LoadTexture("textures/spells/nebula_shield.png")
}
