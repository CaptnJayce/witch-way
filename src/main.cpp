#include "../headers/game.hpp"
#include "../headers/inventory.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

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

    // Grid setup
    const int tileSize = 32;
    const int gridWidth = SCREEN_WIDTH / tileSize;
    const int gridHeight = SCREEN_HEIGHT / tileSize;

    int grid[gridHeight][gridWidth] = {0};

    // Place some objects in the grid
    grid[5][5] = apple.ID;
    grid[10][15] = blapple.ID;
    grid[20][20] = apple.ID;
    grid[16][14] = blapple.ID;
    grid[32][30] = apple.ID;

    // Camera
    Camera2D camera = {0};
    camera.target = (Vector2){player.pos.x + 20.0f, player.pos.y + 20.0f};
    camera.offset = (Vector2){SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f};
    camera.rotation = 0.0f;
    camera.zoom = 1.0f;

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
            camera.target = (Vector2){player.pos.x + 20, player.pos.y + 20};
            BeginMode2D(camera);

            // Player Movement
            if (IsKeyDown(KEY_W)) {
                player.pos.y -= player.speed * GetFrameTime();
            }
            if (IsKeyDown(KEY_S)) {
                player.pos.y += player.speed * GetFrameTime();
            }
            if (IsKeyDown(KEY_A)) {
                player.pos.x -= player.speed * GetFrameTime();
            }
            if (IsKeyDown(KEY_D)) {
                player.pos.x += player.speed * GetFrameTime();
            }

            // Draw player
            DrawRectangle(player.pos.x, player.pos.y, player.w, player.h, WHITE);

            // Draw grid and objects
            for (int y = 0; y < gridHeight; y++) {
                for (int x = 0; x < gridWidth; x++) {
                    // Define player hitbox
                    Rectangle playerRect = {player.pos.x, player.pos.y, player.w, player.h};

                    // Define pickup hitbox
                    Rectangle cellRect = {
                        static_cast<float>(x * tileSize), static_cast<float>(y * tileSize),
                        static_cast<float>(tileSize), static_cast<float>(tileSize)};

                    // Collision check
                    if (CheckCollisionRecs(playerRect, cellRect)) {
                        if (grid[y][x] == apple.ID) {
                            AddItemToInventory(apple.ID);
                        }
                        if (grid[y][x] == blapple.ID) {
                            AddItemToInventory(blapple.ID);
                        }
                        grid[y][x] = 0;
                    }
                    if (grid[y][x] == 1) {
                        DrawRectangle(x * tileSize, y * tileSize, tileSize, tileSize, RED);
                    }
                    if (grid[y][x] == 2) {
                        DrawRectangle(x * tileSize, y * tileSize, tileSize, tileSize, BLUE);
                    }
                }
            }

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
