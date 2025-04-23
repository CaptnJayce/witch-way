package game

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import "core:os"

save :: proc() {
	SaveData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
		krushem:   type_of(lv_one.pickups),
		rock:      type_of(lv_one.obstacles),
	}

	save_data := SaveData {
		player    = p,
		inventory = i,
		krushem   = lv_one.pickups,
		rock      = lv_one.obstacles,
	}

	if data, err := json.marshal(save_data, allocator = context.temp_allocator); err == nil {
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
	SaveData :: struct {
		player:    type_of(p),
		inventory: type_of(i),
		krushem:   type_of(lv_one.pickups),
		rock:      type_of(lv_one.obstacles),
	}

	save_data: SaveData

	if data, ok := os.read_entire_file(sfp, context.temp_allocator); ok {
		if err := json.unmarshal(data, &save_data); err == nil {
			p = save_data.player

			i = save_data.inventory

			lv_one.pickups = save_data.krushem
			lv_one.obstacles = save_data.rock
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
