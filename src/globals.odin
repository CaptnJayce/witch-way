package game

import "core:strings"
import rl "vendor:raylib"

// CONSTANTS //
SW: i32 = 1920
SH: i32 = 1080
SWH: i32 = SW / 2
SHH: i32 = SH / 2

// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 29600
LEVEL_HEIGHT :: 29600

MAX_PROJECTILES :: 100

// TILES //
TILE_SIZE :: 16
GRASS_VARIANTS :: 3
grass_atlas: rl.Texture
grass_src_rects: [GRASS_VARIANTS]rl.Rectangle

// global vars //
delta: f32

editor: bool

current_save := 0
save_selected := false

save_data_path := "save_data/"
save_slot := "save0/"
tile_path := "world_tiles.bin"
json_path := "save_data.json"

seed: i32

tfp := strings.concatenate([]string{save_data_path, save_slot, tile_path})
sfp := strings.concatenate([]string{save_data_path, save_slot, json_path})
