#include "../headers/game.hpp"
#include <raylib.h>

/*
Doing:
  - Items added to inventory when picked up
  - Right clicking drops one of the stack
  - Shift right clicking drops entire stack
*/

#define GRID_SIZE 3
#define SLOT_SIZE 100
#define PADDING 10
#define START_X ((SCREEN_WIDTH - (GRID_SIZE * (SLOT_SIZE + PADDING) - PADDING)) / 2.0f)
#define START_Y ((SCREEN_HEIGHT - (GRID_SIZE * (SLOT_SIZE + PADDING) - PADDING)) / 2.0f)

bool isInventoryOpen = false;

typedef struct {
    Rectangle rect;
    int selected;
} InventorySlot;

typedef struct {
    Rectangle sqr;
    int appleWidth;
    int appleHeight;
    int appleTotal;
    int ID;
} Apple;

Apple apple = {
    .appleWidth = 10,
    .appleHeight = 10,
    .appleTotal = 0,
    .ID = 1,
};

const GameState DefaultState = {
    .state = MENU,
    .playerHeight = 150,
    .playerWidth = 50,
    .playerPos = {SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f},
    .playerSpeed = 500.0f,
};

int main() {
    // Initialize the window
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Forage Game");
    SetTargetFPS(120);

    InventorySlot inventory[GRID_SIZE * GRID_SIZE];
    for (int y = 0; y < GRID_SIZE; y++) {
        for (int x = 0; x < GRID_SIZE; x++) {
            inventory[y * GRID_SIZE + x] =
                (InventorySlot){{static_cast<float>(START_X + x * (SLOT_SIZE + PADDING)),
                                 static_cast<float>(START_Y + y * (SLOT_SIZE + PADDING)),
                                 static_cast<float>(SLOT_SIZE), static_cast<float>(SLOT_SIZE)},
                                0};
        }
    }

    // Initialize game state
    GameState gameState = DefaultState;

    // Grid setup
    const int tileSize = 32;
    const int gridWidth = SCREEN_WIDTH / tileSize;
    const int gridHeight = SCREEN_HEIGHT / tileSize;

    int grid[gridHeight][gridWidth] = {0};

    // Place some objects in the grid (will randomize later)
    // Apple = 1
    grid[5][5] = apple.ID;
    grid[10][15] = 2;
    grid[20][20] = 2;
    grid[16][14] = 2;
    grid[32][30] = apple.ID;

    // Main game loop
    while (!WindowShouldClose()) {
        Vector2 mousePos = GetMousePosition();

        for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
            inventory[i].selected = CheckCollisionPointRec(mousePos, inventory[i].rect);
        }

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
            // Player Movement
            if (IsKeyDown(KEY_W)) {
                gameState.playerPos.y -= gameState.playerSpeed * GetFrameTime();
            }
            if (IsKeyDown(KEY_S)) {
                gameState.playerPos.y += gameState.playerSpeed * GetFrameTime();
            }
            if (IsKeyDown(KEY_A)) {
                gameState.playerPos.x -= gameState.playerSpeed * GetFrameTime();
            }
            if (IsKeyDown(KEY_D)) {
                gameState.playerPos.x += gameState.playerSpeed * GetFrameTime();
            }

            // Draw player
            DrawRectangle(gameState.playerPos.x, gameState.playerPos.y, gameState.playerWidth,
                          gameState.playerHeight, WHITE);

            // Draw inventory grid
            if (IsKeyPressed(KEY_E)) {
                isInventoryOpen = !isInventoryOpen;
            }
            if (isInventoryOpen == true) {
                for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
                    DrawRectangleRec(inventory[i].rect, LIGHTGRAY);
                    DrawRectangleLinesEx(inventory[i].rect, 2, inventory[i].selected ? RED : BLACK);
                }
            }

            // Draw Apple Count
            DrawText(TextFormat("Total Apples: %d", apple.appleTotal), SCREEN_WIDTH / 2,
                     SCREEN_HEIGHT - 30, 20, WHITE);

            // Draw grid and objects
            for (int y = 0; y < gridHeight; y++) {
                for (int x = 0; x < gridWidth; x++) {
                    // Define player hitbox
                    Rectangle playerRect = {gameState.playerPos.x, gameState.playerPos.y,
                                            gameState.playerWidth, gameState.playerHeight};

                    // Define pickup hitbox
                    Rectangle cellRect = {
                        static_cast<float>(x * tileSize), static_cast<float>(y * tileSize),
                        static_cast<float>(tileSize), static_cast<float>(tileSize)};

                    // Collision check
                    if (CheckCollisionRecs(playerRect, cellRect)) {
                        if (grid[y][x] == 1) {
                            apple.appleTotal++;
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
            break;
        }
        }
        EndDrawing();
    }

    // Cleanup
    CloseWindow();
    return 0;
}
