package game

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

save :: proc() {
	PlayerData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
	}

	player_data := PlayerData {
		player    = p,
		inventory = i,
	}

	if data, err := json.marshal(player_data, allocator = context.temp_allocator); err == nil {
		json_path = "player_data.json"
		sfp = strings.concatenate([]string{save_data_path, save_slot, json_path})
		os.write_entire_file(sfp, data)
	}
}

save_level_data :: proc() {
	SaveData :: struct {
		seed: type_of(seed),
	}

	save_data := SaveData {
		seed = seed,
	}

	if data, err := json.marshal(save_data, allocator = context.temp_allocator); err == nil {
		json_path = "save_data.json"
		sfp = strings.concatenate([]string{save_data_path, save_slot, json_path})
		os.write_entire_file(sfp, data)
	}
}

save_tiles :: proc(filename: string) -> bool {
	count: u32 = 0
	for index in 0 ..< tm.width * tm.height {
		if .Modified in tm.tiles[index].flags {
			count += 1
		}
	}

	if count == 0 {
		return false
	}

	header_size := size_of(u32)
	tile_size := size_of(u32) + size_of(u8)
	total_size := header_size + int(count) * tile_size

	buffer := make([]u8, total_size)
	defer delete(buffer)

	mem.copy(&buffer[0], &count, size_of(u32))

	offset := header_size
	for index in 0 ..< tm.width * tm.height {
		if .Modified in tm.tiles[index].flags {

			index_u32 := u32(index)
			mem.copy(&buffer[offset], &index_u32, size_of(u32))
			offset += size_of(u32)

			flags := tm.tiles[index].flags
			mem.copy(&buffer[offset], &flags, size_of(u8))
			offset += size_of(u8)

			tm.tiles[index].flags -= {.Modified}
		}
	}

	os.write_entire_file(filename, buffer)
	return true
}

load :: proc() {
	PlayerData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
	}

	player_data: PlayerData

	if data, ok := os.read_entire_file(sfp, context.temp_allocator); ok {
		if err := json.unmarshal(data, &player_data); err == nil {
			p = player_data.player

			i = player_data.inventory
		}
	}
}

load_level_data :: proc() {
	SaveData :: struct {
		seed: type_of(seed),
	}

	save_data: SaveData

	if data, ok := os.read_entire_file(sfp, context.temp_allocator); ok {
		if err := json.unmarshal(data, &save_data); err == nil {
			seed = save_data.seed
		}
	}
}

load_tiles :: proc(filename: string) -> bool {
	data, ok := os.read_entire_file(filename)
	if !ok do return false
	defer delete(data)

	if len(data) < size_of(u32) do return false

	count: u32
	mem.copy(&count, &data[0], size_of(u32))
	offset := size_of(u32)

	tile_size := size_of(u32) + size_of(u8)
	expected_size := offset + int(count) * tile_size
	if len(data) != expected_size do return false

	for _ in 0 ..< count {
		if offset + tile_size > len(data) do return false

		index: u32
		mem.copy(&index, &data[offset], size_of(u32))
		offset += size_of(u32)

		flags: u8
		mem.copy(&flags, &data[offset], size_of(u8))
		offset += size_of(u8)

		if int(index) < tm.width * tm.height {
			tm.tiles[index].flags = transmute(bit_set[TileFlags;u8])flags
			tm.tiles[index].flags += {.Modified}
		}
	}

	return true
}

// unfinished
load_spell :: proc(path: string) -> (spell: SpellDefinition, ok: bool) {
	data, read_ok := os.read_entire_file(path)
	if !ok {
		return
	}
	defer delete(data)

	if err := json.unmarshal(data, &spell); err != nil {
		return spell, false
	}

	return spell, true
}
