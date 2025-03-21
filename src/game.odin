package game

import rl "vendor:raylib"
import "core:fmt"

SW :i32 = 1280
SH :i32 = 720
SWH :i32 = SW / 2
SHH :i32 = SH / 2

SLOT_SIZE :: 60
INVENTORY_COLUMNS :: 5
INVENTORY_ROWS :: 10 
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

GameState :: enum {
    MainMenu,
    Pause,
    Game,    
}

Level :: struct {
    pickups: [dynamic]Krushem,
    obstacles: [dynamic]Rock,
    editor: bool
}

state := GameState.MainMenu
quit := 0

p: Player
k: Krushem 
r: Rock
l: Level 

init_player :: proc() {
    p.size = {60, 120}
    p.texture = rl.LoadTexture("textures/player_sprite.png")
    p.flipped = false
    p.speed = 250.0
    p.color = {177, 156, 217, 255}
    p.health = 10
    p.damage = 5
    p.pickup = 75.0
}

init_sprite :: proc() {
    k.sprite = rl.LoadTexture("textures/sprite_sheet_pickups-export.png")
    r.sprite = rl.LoadTexture("textures/sprite_sheet_rocks-export.png")
}

state_handler :: proc() {
    if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
        state = GameState.Game // if paused, switch to game
    }
    else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
        state = GameState.Pause // if game, switch to pause
    }
    if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
        state = GameState.Game // if menu, switch to game
    }
}
