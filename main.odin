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
    scale: rl.Vector2,
    speed: f32,
    color: rl.Color,
    health: f32,
    damage: f32,
    level_editor: bool,
}

Berry :: struct {
    size: rl.Rectangle,
    color: rl.Color,
}

Rock :: struct {
    size: rl.Rectangle,
    color: rl.Color,
}

Texture :: struct {
    player_sprite: rl.Texture2D,
}

Level :: struct {
    pickups: [dynamic]Berry,
    obstacles: [dynamic]Rock,
}

main :: proc() {
    screen_width :i32 = 1280
    screen_height :i32 = 720

    rl.InitWindow(screen_width, screen_height, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    l: Level
    p: Player
    p.size = {60, 120}
    p.scale = {1, 1}
    p.speed = 250.0
    p.color = {177, 156, 217, 255}
    p.health = 10
    p.damage = 5
    p.level_editor = false

    player_sprite := rl.LoadTexture("textures/player_sprite.png")
    defer rl.UnloadTexture(player_sprite)

    berry_colour := rl.Color{144, 213, 255, 255}
    rock_colour := rl.Color{65, 66, 65, 255}

    state := GameState.MainMenu
    slot := InventorySlot.One
    editor := LevelEditor.Berry
    quit := 0
                
    for !rl.WindowShouldClose() {
        rl.SetExitKey(.KEY_NULL)
        rl.BeginDrawing()
        defer rl.EndDrawing()

        // state handling
        if rl.IsKeyPressed(.ESCAPE) && state == .Pause {
            state = GameState.Game // If paused, switch to game
        }
        else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
            state = GameState.Pause // if game, switch to pause
        }
        if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
            state = GameState.Game // If menu, switch to game
        }

        switch state {
            case .MainMenu:
                rl.DrawText("Main Menu", screen_width / 2 - rl.MeasureText("Main Menu", 20) / 2, screen_height / 2, 20, rl.PURPLE)
                rl.DrawText("Press Enter to play", screen_width / 2 - rl.MeasureText("Press Enter to play", 20) / 2, screen_height / 2 + 40, 20, rl.PURPLE)
                rl.ClearBackground(rl.BLACK)
            case .Pause:
                rl.DrawText("Game Paused", screen_width / 2 - rl.MeasureText("Game Paused", 20) / 2, screen_height / 2, 20, rl.PURPLE)
                rl.ClearBackground(rl.BLACK)
            case .Game:
                // player movement 
                prev_pos := p.position // used for rock collision
                if rl.IsKeyDown(.W) { p.position.y -= p.speed * rl.GetFrameTime() }
                if rl.IsKeyDown(.S) { p.position.y += p.speed * rl.GetFrameTime() }
                if rl.IsKeyDown(.A) {
                    p.scale = -1.0
                    p.position.x -= p.speed * rl.GetFrameTime() 
                }
                if rl.IsKeyDown(.D) { 
                    p.scale = 1.0
                    p.position.x += p.speed * rl.GetFrameTime() 
                }
                    
                player_rect := rl.Rectangle {
                    x = p.position.x - p.size.x / 2,
                    y = p.position.y - p.size.x / 2,
                    width = p.size.x,
                    height = p.size.y,
                }

                // camera
                camera := rl.Camera2D {
                    zoom = 1,
                    offset = {f32(screen_width / 2), f32(screen_height / 2)},
                    target = p.position,
                }   
                rl.BeginMode2D(camera)

                // drawing
               for berry in l.pickups {
                    rl.DrawRectangleRec(berry.size, berry_colour)
                }
                for rock in l.obstacles {
                    rl.DrawRectangleRec(rock.size, rock_colour)
                }

                // level editor
                mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
                if rl.IsKeyPressed(.T) {
                    p.level_editor = !p.level_editor 
                }
                if p.level_editor == true {
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
        
                // collision
                for i, idx in l.pickups {
                    if rl.CheckCollisionRecs(player_rect, l.pickups[idx].size) {
                        unordered_remove(&l.pickups, idx)
                        //fmt.println(&pickups)
                        break
                    }
                }
                for i, idx in l.obstacles {
                    if rl.CheckCollisionRecs(player_rect, l.obstacles[idx].size) {
                        p.position = prev_pos
                        // fmt.println("bonk") 
                    }
                }

            rl.DrawRectangleV(p.position - p.size.x / 2, p.size, p.color)
            rl.DrawTextureV(player_sprite, p.position - p.size.x / 2, rl.WHITE)
            rl.ClearBackground(rl.DARKGREEN)
        }

        rl.EndMode2D()

        if state == GameState.Game {
            // UI
            rl.DrawFPS(20, 20)
            rl.DrawText(rl.TextFormat("Health: %f", p.health), 20, 50, 20, rl.RAYWHITE)
            rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 20, 75, 20, rl.RAYWHITE)
            rl.DrawText(rl.TextFormat("Editor Enabled: %t", p.level_editor), 20, 100, 20, rl.RAYWHITE)

            // temporary inventory UI, will do proper implementation tomorrow 
            // highlight selected slot
            if rl.IsKeyPressed(.ONE) { slot = InventorySlot.One }
            if rl.IsKeyPressed(.TWO) { slot = InventorySlot.Two }
            if rl.IsKeyPressed(.THREE) { slot = InventorySlot.Three }
            if rl.IsKeyPressed(.FOUR) { slot = InventorySlot.Four }
            
            switch slot {
                case .One:
                    rl.DrawRectangle(screen_width / 2 - 175, screen_height - 80, 80, 80, {255, 255, 255, 150})
                case .Two:
                    rl.DrawRectangle(screen_width / 2 - 85, screen_height - 80, 80, 80, {255, 255, 255, 150})
                case .Three:
                    rl.DrawRectangle(screen_width / 2 + 5, screen_height - 80, 80, 80, {255, 255, 255, 150})
                case .Four:
                    rl.DrawRectangle(screen_width / 2 + 95, screen_height - 80, 80, 80, {255, 255, 255, 150})
            }
            // right
            rl.DrawRectangleLines(screen_width / 2 + 5, screen_height - 80, 80, 80, rl.WHITE)
            rl.DrawRectangleLines(screen_width / 2 + 95, screen_height - 80, 80, 80, rl.WHITE)
            // left
            rl.DrawRectangleLines(screen_width / 2 - 85, screen_height - 80, 80, 80, rl.WHITE)
            rl.DrawRectangleLines(screen_width / 2 - 175, screen_height - 80, 80, 80, rl.WHITE)
        }
    }
}