package main

import rl "vendor:raylib"
import "core:fmt"

Player :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    speed: f32,
    color: rl.Color,
}

Berry :: struct {
    size: rl.Rectangle,
    color: rl.Color,
}

main :: proc() {
    screen_width :i32 = 1280
    screen_height :i32 = 720

    rl.InitWindow(screen_width, screen_height, "game")
    rl.SetTargetFPS(120)

    p: Player
    p.position = {20, 20}
    p.size = {20, 40}
    p.speed = 5.0
    p.color = {177, 156, 217, 255}

    berryColour := rl.Color{144, 213, 255, 255}

    pickups: [dynamic]Berry
    append(&pickups, Berry{rl.Rectangle{150, 150, 15, 15}, berryColour})
    append(&pickups, Berry{rl.Rectangle{100, 100, 15, 15}, berryColour})
    append(&pickups, Berry{rl.Rectangle{175, 175, 15, 15}, berryColour})
    append(&pickups, Berry{rl.Rectangle{125, 125, 15, 15}, berryColour})

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        if rl.IsKeyDown(.W) { p.position.y -= p.speed }
        if rl.IsKeyDown(.S) { p.position.y += p.speed }
        if rl.IsKeyDown(.A) { p.position.x -= p.speed }
        if rl.IsKeyDown(.D) { p.position.x += p.speed }

        camera := rl.Camera2D {
            zoom = 1,
            offset = {f32(screen_width / 2), f32(screen_height / 2)},
            target = p.position,
        }   
        rl.BeginMode2D(camera)

        player_rect := rl.Rectangle {
            x = p.position.x,
            y = p.position.y,
            width = p.size.x,
            height = p.size.y,
        }

        for berry in pickups {
            rl.DrawRectangleRec(berry.size, berry.color)
        }

        for i, idx in pickups {
            if rl.CheckCollisionRecs(player_rect, pickups[idx].size) {
                unordered_remove(&pickups, idx)
                //fmt.println(&pickups)
                break
            }
        }

        rl.DrawRectangleV(p.position, p.size, p.color)
        rl.ClearBackground(rl.DARKGREEN)
        rl.EndMode2D()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}