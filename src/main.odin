package game 

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
    rl.InitWindow(SW, SH, "Witch Way")
    defer rl.CloseWindow()
    rl.SetTargetFPS(120)

    // initialise everything
    init_player()
    init_enemy()
    init_sprite()
    init_inventory()
    
    for !rl.WindowShouldClose() {
        rl.SetExitKey(.KEY_NULL)
        rl.BeginDrawing()
        defer rl.EndDrawing()
        delta = rl.GetFrameTime()
        
        state_handler()

        switch state {
            case .MainMenu:
            draw_main_menu()
            case .DeathScreen:
            draw_death_screen_menu()
            case .Pause:
            draw_pause_menu()
            if rl.IsKeyPressed(.S) {
                save()
            }
            case .Game:
            if rl.IsKeyPressed(.L) {
                load()
            }

            player_movement()
            iframes(delta)
            enemy_handler(delta)
            camera()

            draw()
            flip_texture(p.flipped)

            collision()
        
            rl.ClearBackground(rl.DARKGREEN)
            level_editor()
        }

        camera_end()
        
        draw_inventory()
        debug_menu()
    }
}
