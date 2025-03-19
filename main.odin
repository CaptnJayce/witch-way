package main

import rl "vendor:raylib"
import "core:fmt"

// global definitions
SW :i32 = 1280
SH :i32 = 720
SWH :i32 = SW / 2
SHH :i32 = SH / 2

SLOT_SIZE :: 60
INVENTORY_COLUMNS :: 5
INVENTORY_ROWS :: 10 
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

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
    p.pickup = 50.0

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
    pickup: f32,
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
        state = GameState.Game // if paused, switch to game
    }
    else if rl.IsKeyPressed(.ESCAPE) && state == .Game {
        state = GameState.Pause // if game, switch to pause
    }
    if rl.IsKeyPressed(.ENTER) && state == .MainMenu {
        state = GameState.Game // if menu, switch to game
    }
}
// ----- UI ----- //
// inventory
ItemType :: enum {
    None,
    Berry,
}

ItemStack :: struct {
    item: ItemType,
    count: int,
}

Inventory :: struct {
    slots:[TOTAL_SLOTS]ItemStack, 
}

i: Inventory

init_inventory :: proc() {
    i.slots[0] = ItemStack{.Berry, 0}
}
draw_inventory :: proc(berry_sprite: rl.Texture2D, open: bool) {
    berry_source := rl.Rectangle {
            x = 0,
            y = 0,
            width = 48,
            height = 48,
    }

    total_length : i32  = INVENTORY_COLUMNS * SLOT_SIZE 
    offset_x : i32 = (SW / 2) - (total_length / 2)
    offset_y : i32 = 40 

    draw_at_x : i32 = offset_x 
    draw_at_y : i32 = offset_y

    if open {
        for idx in 0..<TOTAL_SLOTS {
            rl.DrawRectangleLines(draw_at_x, draw_at_y, SLOT_SIZE, SLOT_SIZE, rl.WHITE)

            item_stack := i.slots[idx]
            if item_stack.item != .None {
                #partial switch item_stack.item {
                case .Berry:
                    rl.DrawTextureRec(berry_sprite, berry_source, {f32(draw_at_x), f32(draw_at_y)}, rl.WHITE)

                    // rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.RED)
                    rl.DrawText(rl.TextFormat("%d", item_stack.count), draw_at_x, draw_at_y, 20, rl.WHITE)
                }
            }

            draw_at_x += SLOT_SIZE 

            if draw_at_x == (offset_x + (INVENTORY_COLUMNS * SLOT_SIZE)) {
                draw_at_x = offset_x
                draw_at_y += SLOT_SIZE 
            }
        }
    }
}

debug_menu :: proc(p: ^Player, l: ^Level) {
    if state == GameState.Game {
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

prev_pos : rl.Vector2
collision :: proc(p: ^Player, l: ^Level) {
    player_rect := rl.Rectangle {
        x = p.position.x - p.size.x / 2,
        y = p.position.y - p.size.x / 2,
        width = p.size.x,
        height = p.size.y,
    }

    for j, idx in l.pickups {
        if rl.Vector2Distance(p.position, {l.pickups[idx].size.x, l.pickups[idx].size.y}) <= p.pickup {
            unordered_remove(&l.pickups, idx)
            i.slots[0].count += 1
            break
        }
    }

    for j, idx in l.obstacles {
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


main :: proc() {
    rl.InitWindow(SW, SH, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    p: Player
    b: Berry
    r: Rock
    object_init(&p, &b, &r)
    init_inventory()
    open := false

    l: Level

    for !rl.WindowShouldClose() {
        rl.SetExitKey(.KEY_NULL)
        rl.BeginDrawing()
        defer rl.EndDrawing()

        game_handler()

        switch state {
            case .MainMenu:
            rl.DrawText("Main Menu", SWH- rl.MeasureText("Main Menu", 20) / 2, SHH, 20, rl.PURPLE)
            rl.DrawText("Press Enter to play", SWH - rl.MeasureText("Press Enter to play", 20) / 2, SHH + 40, 20, rl.PURPLE)
            rl.ClearBackground(rl.BLACK)

            case .Pause:
            rl.DrawText("Game Paused", SWH - rl.MeasureText("Game Paused", 20) / 2, SHH, 20, rl.PURPLE)
            rl.ClearBackground(rl.BLACK)

            case .Game:
            player_handler(&p)

            c := rl.Camera2D {
                zoom = 1,
                offset = {f32(SWH), f32(SHH)},
                target = p.position,
            }   
            rl.BeginMode2D(c)

            draw(l)
            if rl.IsKeyPressed(.E) {
                open = !open
            }
            collision(&p, &l)
        
            // rl.DrawRectangleV(p.position - p.size.x / 2, p.size, p.color) // hitbox
            flip_texture(p, p.position, p.flipped)
            rl.ClearBackground(rl.DARKGREEN)
            level_editor(&l, c, b.sprite, r.sprite)
        }

        rl.EndMode2D()

        
        draw_inventory(b.sprite, open)
        // debug_menu(&p, &l)
    }
}
