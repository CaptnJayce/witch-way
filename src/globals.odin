package game

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

fp := "save_data/level1_tiles.bin"
