#include "../headers/game.hpp"
#include "../headers/inventory.hpp"
#include "../headers/items.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

/*
TODO:
Reimplement item spawning
*/

const GameState DefaultState = {
    .state = MENU,
};

int main() {
    // Initialization
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Forage Game");
    SetTargetFPS(120);

    InitInventory();

    GameState gameState = DefaultState;

    // Main game loop
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKGREEN);

        switch (gameState.state) {
        // Main Menu
        case MENU: {
            DrawText("PRESS ENTER", SCREEN_WIDTH / 2 - MeasureText("PRESS ENTER", 20) / 2, 20, 20,
                     WHITE);
            if (IsKeyPressed(KEY_ENTER)) {
                gameState = DefaultState;
                gameState.state = GAME;
            }
            break;
        }

        // Game
        case GAME: {
            PlayerUpdate();
            if (IsKeyPressed(KEY_E)) {
                ToggleInventory();
            }
            UpdateItem();
            BeginMode2D(camera);

            PlayerDraw();
            if (isInventoryOpen) {
                DrawInventory(camera);
            }
            DrawItem();
            break;
        }
        }
        EndDrawing();
    }

    // Cleanup
    CloseWindow();
    return 0;
}
