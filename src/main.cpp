#include "../headers/game.hpp"
#include "../headers/inventory.hpp"
#include "../headers/items.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

/*
TODO (most to least): 
  debugging function, include:
    - Drawing hitboxes
    - Drawing grid

  chunk system:
    - draw chunks of 32x32 grids for infinite generation
    - draw around 0,0 and go outwards in each direction
*/

const GameState DefaultState = {
    .state = MENU,
};

int main() {
    // Initialization
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Forage Game");
    SetTargetFPS(120);

    InitInventory();
    InitializeGrid();

    GameState gameState = DefaultState;

    // Main game loop
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKGREEN);

        switch (gameState.state) {
        // Main Menu
        case MENU: {
            DrawText("PRESS ENTER", SCREEN_WIDTH / 2 - MeasureText("PRESS ENTER", 20) / 2, 20, 20, WHITE);
            if (IsKeyPressed(KEY_ENTER)) {
                gameState = DefaultState;
                gameState.state = GAME;
            }
            break;
        }

        // Game
        case GAME: {
            PlayerUpdate();
            MouseUpdate();
            UpdateItem();
            if (IsKeyPressed(KEY_E)) {
                ToggleInventory();
            }
            BeginMode2D(camera);

            DrawGrid();
            PlayerDraw();
            MouseDraw();
            DrawItem();
            if (isInventoryOpen) {
                DrawInventory(camera);
            }
            break;
        }
        }
        EndDrawing();
    }

    // Cleanup
    CloseWindow();
    return 0;
}
