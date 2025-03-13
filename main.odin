package main

import rl "vendor:raylib"
import "core:fmt"

GameState :: enum {
    MainMenu,
    Pause,
    Game,    
}

InventorySlot :: enum {
    One,
    Two,
    Three,
    Four,
}

LevelEditor :: enum {
    Berry,
    Rock,
}

Player :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    texture: rl.Texture2D,
    flipped: bool,
    speed: f32,
    color: rl.Color,
    health: f32,
    damage: f32,
}

Berry :: struct {
    size: rl.Rectangle,
    color: rl.Color,
}

Rock :: struct {
    size: rl.Rectangle,
    color: rl.Color,
}

Level :: struct {
    pickups: [dynamic]Berry,
    obstacles: [dynamic]Rock,
    editor: bool
}

// global definitions
sw :i32 = 1280
sh :i32 = 720
sw_half :i32 = sw / 2
sh_half :i32 = sh / 2

berry_colour := rl.Color{144, 213, 255, 255}
rock_colour := rl.Color{65, 66, 65, 255}

state := GameState.MainMenu
slot := InventorySlot.One
editor := LevelEditor.Berry
quit := 0

prev_pos : rl.Vector2

flip_texture :: proc(p: Player, pos: rl.Vector2, flip: bool) {
    width := f32(p.texture.width)
    height := f32(p.texture.height)

    source := rl.Rectangle {
        x = 0,
        y = 0,
        width = p.size.x,
        height = p.size.y,
    }

    if flip {
        source.width = -source.width
    }

    rl.DrawTextureRec(p.texture, source, p.position - p.size.x / 2, rl.WHITE)
}

player_init :: proc(p: ^Player) {
    p.size = {60, 120}
    p.texture = rl.LoadTexture("textures/player_sprite.png")
    p.flipped = false
    p.speed = 250.0
    p.color = {177, 156, 217, 255}
    p.health = 10
    p.damage = 5
}

player_handler :: proc(p: ^Player) {
    // store pos from a frame before for collisions
    prev_pos = p.position

    if rl.IsKeyDown(.W) { p.position.y -= p.speed * rl.GetFrameTime() }
    if rl.IsKeyDown(.S) { p.position.y += p.speed * rl.GetFrameTime() }
    if rl.IsKeyDown(.A) {
        p.flipped = true
        p.position.x -= p.speed * rl.GetFrameTime() 
    }
    if rl.IsKeyDown(.D) { 
        p.flipped = false
        p.position.x += p.speed * rl.GetFrameTime() 
    }
}

game_handler :: proc() {
    if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
        state = GameState.Game // If paused, switch to game
    }
    else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
        state = GameState.Pause // if game, switch to pause
    }
    if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
        state = GameState.Game // If menu, switch to game
    }
}

collision :: proc(p: ^Player, l: ^Level) {
    player_rect := rl.Rectangle {
        x = p.position.x - p.size.x / 2,
        y = p.position.y - p.size.x / 2,
        width = p.size.x,
        height = p.size.y,
    }

    for i, idx in l.pickups {
        if rl.CheckCollisionRecs(player_rect, l.pickups[idx].size) {
            unordered_remove(&l.pickups, idx)
            break
        }
    }
    for i, idx in l.obstacles {
        if rl.CheckCollisionRecs(player_rect, l.obstacles[idx].size) {
            p.position = prev_pos
        }
    }
}

draw :: proc(l: Level) {
    for berry in l.pickups {
        rl.DrawRectangleRec(berry.size, berry_colour)
    }
    for rock in l.obstacles {
        rl.DrawRectangleRec(rock.size, rock_colour)
    }
}

ui :: proc(p: Player, l: Level) {
    if state == GameState.Game {
        // UI
        rl.DrawFPS(20, 20)
        rl.DrawText(rl.TextFormat("Health: %f", p.health), 20, 50, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 20, 75, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Editor Enabled: %t", l.editor), 20, 100, 20, rl.RAYWHITE)

        // temporary inventory UI, will do proper implementation later 
        // highlight selected slot
        if rl.IsKeyPressed(.ONE) { slot = InventorySlot.One }
        if rl.IsKeyPressed(.TWO) { slot = InventorySlot.Two }
        if rl.IsKeyPressed(.THREE) { slot = InventorySlot.Three }
        if rl.IsKeyPressed(.FOUR) { slot = InventorySlot.Four }
        
        switch slot {
            case .One:
                rl.DrawRectangle(sw_half - 175, sh - 80, 80, 80, {255, 255, 255, 150})
            case .Two:
                rl.DrawRectangle(sw_half - 85, sh - 80, 80, 80, {255, 255, 255, 150})
            case .Three:
                rl.DrawRectangle(sw_half + 5, sh - 80, 80, 80, {255, 255, 255, 150})
            case .Four:
                rl.DrawRectangle(sw_half + 95, sh - 80, 80, 80, {255, 255, 255, 150})
        }
        // right
        rl.DrawRectangleLines(sw_half + 5, sh - 80, 80, 80, rl.WHITE)
        rl.DrawRectangleLines(sw_half + 95, sh - 80, 80, 80, rl.WHITE)
        // left
        rl.DrawRectangleLines(sw_half - 85, sh - 80, 80, 80, rl.WHITE)
        rl.DrawRectangleLines(sw_half - 175, sh - 80, 80, 80, rl.WHITE)
    }
}

level_editor :: proc(l: ^Level, c: rl.Camera2D) {
    mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), c)

    if rl.IsKeyPressed(.T) {
        l.editor = !l.editor
    }

    if l.editor {
        if rl.IsMouseButtonPressed(.RIGHT) {
            for p, idx in l.pickups {
                if rl.CheckCollisionPointRec(mp, l.pickups[idx].size) {
                    unordered_remove(&l.pickups, idx)
                    break
                }
            }

            for p, idx in l.obstacles {
                if rl.CheckCollisionPointRec(mp, l.obstacles[idx].size) {
                    unordered_remove(&l.obstacles, idx)
                    break
                }
            }
        }

        if rl.IsKeyPressed(.ONE) { editor = .Berry }
        if rl.IsKeyPressed(.TWO) { editor = .Rock }

        if editor == .Berry && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.pickups, Berry{rl.Rectangle{mp.x, mp.y, 15, 15}, berry_colour})
        }
        if editor == .Rock && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 20, 20}, rock_colour})
        }
    }
}

main :: proc() {
    rl.InitWindow(sw, sh, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    p: Player
    player_init(&p)

    l: Level

    for !rl.WindowShouldClose() {
        rl.SetExitKey(.KEY_NULL)
        rl.BeginDrawing()
        defer rl.EndDrawing()

        game_handler()

        switch state {
            case .MainMenu:
                rl.DrawText("Main Menu", sw_half - rl.MeasureText("Main Menu", 20) / 2, sh_half, 20, rl.PURPLE)
                rl.DrawText("Press Enter to play", sw_half - rl.MeasureText("Press Enter to play", 20) / 2, sh_half + 40, 20, rl.PURPLE)
                rl.ClearBackground(rl.BLACK)
            case .Pause:
                rl.DrawText("Game Paused", sw_half - rl.MeasureText("Game Paused", 20) / 2, sh_half, 20, rl.PURPLE)
                rl.ClearBackground(rl.BLACK)
            case .Game:
                player_handler(&p)

                c := rl.Camera2D {
                    zoom = 1,
                    offset = {f32(sw_half), f32(sh_half)},
                    target = p.position,
                }   
                rl.BeginMode2D(c)

                draw(l)
                collision(&p, &l)
            
                // rl.DrawRectangleV(p.position - p.size.x / 2, p.size, p.color) // hitbox
                flip_texture(p, p.position, p.flipped)
                rl.ClearBackground(rl.DARKGREEN)
                level_editor(&l, c)
        }

        rl.EndMode2D()
        ui(p, l)
    }
}
