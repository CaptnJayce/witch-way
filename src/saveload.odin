package game

import "core:encoding/json"
import "core:os"

save :: proc() {
    SaveData :: struct {
        position: type_of(p.position),
        tiles:    type_of(grid.tiles),
    }

    save_data := SaveData{
        position = p.position,
        tiles    = grid.tiles,
    }

    if data, err := json.marshal(save_data, allocator = context.temp_allocator); err == nil {
        os.write_entire_file("save.json", data)
    }
}

load :: proc() {
    SaveData :: struct {
        position: type_of(p.position),
        tiles:    type_of(grid.tiles),
    }

    save_data: SaveData

    if data, ok := os.read_entire_file("save.json", context.temp_allocator); ok {
        if err := json.unmarshal(data, &save_data); err == nil {
            p.position = save_data.position
            grid.tiles = save_data.tiles
        } 
	}
}