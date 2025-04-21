package game

import "core:strings"

// CONSTANTS //
SW: i32 = 1920
SH: i32 = 1080
SWH: i32 = SW / 2
SHH: i32 = SH / 2

TILE_SIZE :: 16

// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 2960
LEVEL_HEIGHT :: 2000

SLOT_SIZE :: 60
INVENTORY_COLUMNS :: 5
INVENTORY_ROWS :: 10
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

// global vars //
delta: f32

editor: bool

current_save := 0

save_data := "save_data/"
save_slot := "save0/"
tile_path := "level1_tiles.bin"
json_path := "save.json"

tfp := strings.concatenate([]string{save_data, save_slot, tile_path})
sfp := strings.concatenate([]string{save_data, save_slot, json_path})
