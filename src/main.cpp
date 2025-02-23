#include "../headers/game.hpp"
#include "../headers/inventory.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

/*
TODO:
Draw and Update methods
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
    Player player = Player();
    PlayerTexutre playerTexture = PlayerTexutre();
    PlayerHitbox playerHitbox = PlayerHitbox();

    // Grid setup
    const int tileSize = 32;
    const int gridWidth = SCREEN_WIDTH / tileSize;
    const int gridHeight = SCREEN_HEIGHT / tileSize;

    int grid[gridHeight][gridWidth] = {0};

    // Main game loop
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKGREEN);

        // Handle game state
        switch (gameState.state) {
        case MENU: {
            DrawText("PRESS ENTER", SCREEN_WIDTH / 2 - MeasureText("PRESS ENTER", 20) / 2, 20, 20,
                     WHITE);
            if (IsKeyPressed(KEY_ENTER)) {
                gameState = DefaultState;
                gameState.state = GAME;
            }
            break;
        }
        case GAME: {
            CameraMovement();
            BeginMode2D(camera);

            PlayerMovement();
            DrawPlayer();

            // Inventory
            if (IsKeyPressed(KEY_E)) {
                ToggleInventory();
            }
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
