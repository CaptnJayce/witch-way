package game 

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
    rl.InitWindow(SW, SH, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    object_init()
    init_inventory()

    open := false
    
    for !rl.WindowShouldClose() {
        rl.SetExitKey(.KEY_NULL)
        rl.BeginDrawing()
        defer rl.EndDrawing()
        
        game_handler()

        switch state {
            case .MainMenu:
            draw_main_menu()
            case .Pause:
            draw_pause_menu()
            if rl.IsKeyPressed(.S) {
                save()
            }
            case .Game:
            if rl.IsKeyPressed(.L) {
                load()
            }

            player_handler()

            c := rl.Camera2D {
                zoom = 1,
                offset = {f32(SWH), f32(SHH)},
                target = p.position,
            }   

            rl.BeginMode2D(c)

            draw()

            if rl.IsKeyPressed(.E) {
                open = !open
            }

            collision()
        
            flip_texture(p, p.position, p.flipped)
            rl.ClearBackground(rl.DARKGREEN)
            level_editor(c, b.sprite, r.sprite)
        }
        rl.EndMode2D()
        
        draw_inventory(b.sprite, open)
        debug_menu()
    }
}
