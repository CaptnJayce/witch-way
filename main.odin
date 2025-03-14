package main

import rl "vendor:raylib"
import "core:fmt"

// global definitions
sw :i32 = 1280
sh :i32 = 720
sw_half :i32 = sw / 2
sh_half :i32 = sh / 2

state := GameState.MainMenu
quit := 0

Berry :: struct {
    size: rl.Rectangle,
    sprite: rl.Texture2D,
}
Rock :: struct {
    size: rl.Rectangle,
    sprite: rl.Texture2D,
}
object_init:: proc(p: ^Player, b: ^Berry, r: ^Rock) {
    p.size = {60, 120}
    p.texture = rl.LoadTexture("textures/player_sprite.png")
    p.flipped = false
    p.speed = 250.0
    p.color = {177, 156, 217, 255}
    p.health = 10
    p.damage = 5

    b.sprite = rl.LoadTexture("textures/sprite_sheet_pickups-export.png")

    r.sprite = rl.LoadTexture("textures/sprite_sheet_rocks-export.png")
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

GameState :: enum {
    MainMenu,
    Pause,
    Game,    
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

prev_pos : rl.Vector2
collision :: proc(p: ^Player, l: ^Level, h: ^Hotbar) {
    player_rect := rl.Rectangle {
        x = p.position.x - p.size.x / 2,
        y = p.position.y - p.size.x / 2,
        width = p.size.x,
        height = p.size.y,
    }

    for i, idx in l.pickups {
        if rl.CheckCollisionRecs(player_rect, l.pickups[idx].size) {
            unordered_remove(&l.pickups, idx)
            for i in h.slots {
                if h.slots[i] == 0 {
                    h.slots[i] += 1
                }
            }
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
    // ensure xy & wh is multiplied by three as i export the sprites with 300% scaling in aseprite
    berry_source := rl.Rectangle {
        x = 0,
        y = 0,
        width = 48,
        height = 48,
    }
    rock_source := rl.Rectangle {
        x = 0,
        y = 0,
        width = 48,
        height = 48,
    }

    for berry in l.pickups {
        rl.DrawTextureRec(berry.sprite, berry_source, {berry.size.x, berry.size.y}, rl.WHITE)
    }
    for rock in l.obstacles {
        rl.DrawTextureRec(rock.sprite, rock_source, {rock.size.x, rock.size.y}, rl.WHITE)
    }
}

// ----- UI ----- //
HotbarSlot :: enum {
    Zero,
    One,
    Two,
    Three,
    Four,
}
Hotbar :: struct {
    slots: []i32,
    current_slot: i32,
    total_in_slot: i32,
}
slot := HotbarSlot.Zero
hotbar :: proc(h: ^Hotbar) {
    h := Hotbar {
        slots = []i32{1, 2, 3, 4}
    }

    size_of_slot := i32(60)
    length_of_bar := i32(len(h.slots)) * size_of_slot 
    draw_at_x := sw_half - i32((length_of_bar / 2))
    draw_at_y := sh - size_of_slot 

    for i in h.slots {
        rl.DrawRectangleLines(draw_at_x, draw_at_y, size_of_slot, size_of_slot, rl.BLACK)
        draw_at_x += size_of_slot 
    }

    // enum doesn't need to be handled manually but a more dynamic 
    // implementation won't be necessary unless slot number changes throughout the game 
    if rl.IsKeyPressed(.ONE) {slot = HotbarSlot.One} 
    if rl.IsKeyPressed(.TWO) {slot = HotbarSlot.Two} 
    if rl.IsKeyPressed(.THREE) {slot = HotbarSlot.Three} 
    if rl.IsKeyPressed(.FOUR) {slot = HotbarSlot.Four} 

    switch slot {
    case .Zero:
    rl.DrawRectangle(0, 0, 0, 0, {0, 0, 0, 0})
    case .One:
    rl.DrawRectangle(draw_at_x - length_of_bar, draw_at_y, size_of_slot, size_of_slot, {255, 255, 255, 150})
    rl.DrawText(rl.TextFormat("Berries: %d", h.total_in_slot), draw_at_x - length_of_bar, draw_at_y, 20, rl.RAYWHITE)
    case .Two:
    rl.DrawRectangle(draw_at_x - length_of_bar + size_of_slot, draw_at_y, size_of_slot, size_of_slot, {255, 255, 255, 150})
    case .Three:
    rl.DrawRectangle(draw_at_x - length_of_bar + (size_of_slot * 2), draw_at_y, size_of_slot, size_of_slot, {255, 255, 255, 150})
    case .Four:
    rl.DrawRectangle(draw_at_x - length_of_bar + (size_of_slot * 3), draw_at_y, size_of_slot, size_of_slot, {255, 255, 255, 150})
    }
}
debug_menu :: proc(p: ^Player, l: ^Level) {
    if state == GameState.Game {
        // UI
        rl.DrawFPS(20, 20)
        rl.DrawText(rl.TextFormat("Health: %f", p.health), 20, 50, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Damage: %f", p.damage), 20, 75, 20, rl.RAYWHITE)
        rl.DrawText(rl.TextFormat("Editor Enabled: %t", l.editor), 20, 100, 20, rl.RAYWHITE)
    }
}

LevelEditor :: enum {
    Berry,
    Rock,
}
Level :: struct {
    pickups: [dynamic]Berry,
    obstacles: [dynamic]Rock,
    editor: bool
}
editor := LevelEditor.Berry
level_editor :: proc(l: ^Level, c: rl.Camera2D, berry_sprite: rl.Texture2D, rock_sprite: rl.Texture2D) {
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
            append(&l.pickups, Berry{rl.Rectangle{mp.x, mp.y, 48, 48}, berry_sprite})
        }
        if editor == .Rock && rl.IsMouseButtonPressed(.LEFT) {
            append(&l.obstacles, Rock{rl.Rectangle{mp.x, mp.y, 48, 48}, rock_sprite})
        }
    }
}

main :: proc() {
    rl.InitWindow(sw, sh, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    p: Player
    b: Berry
    r: Rock
    h: Hotbar
    object_init(&p, &b, &r)

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
            
            collision(&p, &l, &h)
        
            // rl.DrawRectangleV(p.position - p.size.x / 2, p.size, p.color) // hitbox
            flip_texture(p, p.position, p.flipped)
            rl.ClearBackground(rl.DARKGREEN)
            level_editor(&l, c, b.sprite, r.sprite)
        }

        rl.EndMode2D()
        // debug_menu(&p, &l)
    }
}
