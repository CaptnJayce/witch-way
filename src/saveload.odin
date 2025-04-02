package game

import "core:encoding/json"
import "core:os"

save :: proc() {
	SaveData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
		enemy:     type_of(l.enemies),
		krushem:   type_of(l.pickups),
		rock:      type_of(l.obstacles),
		tiles:     type_of(g.tiles),
	}

	save_data := SaveData {
		player    = p,
		inventory = i,
		enemy     = l.enemies,
		krushem   = l.pickups,
		rock      = l.obstacles,
		tiles     = g.tiles,
	}

	if data, err := json.marshal(save_data, allocator = context.temp_allocator); err == nil {
		os.write_entire_file("save.json", data)
	}
}

load :: proc() {
	SaveData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
		enemy:     type_of(l.enemies),
		krushem:   type_of(l.pickups),
		rock:      type_of(l.obstacles),
		tiles:     type_of(g.tiles),
	}

	save_data: SaveData

	if data, ok := os.read_entire_file("save.json", context.temp_allocator); ok {
		if err := json.unmarshal(data, &save_data); err == nil {
			p = save_data.player

			i = save_data.inventory

			l.enemies = save_data.enemy
			l.pickups = save_data.krushem
			l.obstacles = save_data.rock

			g.tiles = save_data.tiles
		}
	}
}
