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
    DeathScreen,
}

Level :: struct {
    pickups: [dynamic]Krushem,
    obstacles: [dynamic]Rock,
    enemies: [dynamic]Enemy,
    editor: bool
}

state := GameState.MainMenu
quit := 0
delta : f32

p: Player
e: Enemy
k: Krushem 
r: Rock
l: Level 

init_player :: proc() {
    p.size = {36, 84}
    p.texture = rl.LoadTexture("textures/sprite_player.png")
    p.flipped = false
    p.speed = 250.0
    p.max_health = 10
    p.health = p.max_health
    p.damage = 5
    p.can_take_damage = true
    p.pickup = 75.0
}

init_enemy :: proc() {
    e.texture = rl.LoadTexture("textures/sprite_enemy.png")
    e.flipped = false
    e.speed = 50.0
    e.health = 4
    e.damage = 2
    e.sight = 150.0 
    e.action_timer = 0
    e.direction = 0
}

init_sprite :: proc() {
    k.texture = rl.LoadTexture("textures/sprite_sheet_pickups-export.png")
    r.texture = rl.LoadTexture("textures/sprite_sheet_rocks-export.png")
}

state_handler :: proc() {
    if state == GameState.MainMenu && rl.IsKeyPressed(.Q) {
        rl.CloseWindow() // if in main menu and press q, quit game
    }
    if state == GameState.Pause && rl.IsKeyPressed(.ESCAPE) {
        state = GameState.MainMenu // if in pause menu and press escape again, go to main menu
    }

    if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
        state = GameState.Game // if paused, switch to game
    }
    else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
        state = GameState.Pause // if game, switch to pause
    }
    if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
        state = GameState.Game // if menu, switch to game
    }

    if p.health <= 0 {
        state = GameState.DeathScreen // if no health left, switch to deathscreen
    }

    // death screen logic 
    if state == GameState.DeathScreen && rl.IsKeyPressed(.ENTER) {
        p.health = p.max_health
        state = GameState.Game 
        load()
    }
    if state == GameState.DeathScreen && rl.IsKeyPressed(.ESCAPE) {
        p.health = p.max_health
        state = GameState.MainMenu
    }
}
