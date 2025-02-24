#include "../headers/items.hpp"
#include "../headers/game.hpp"
#include "../headers/inventory.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

Apple apple = {
    .radius = tileSize / 2,
    .colour = {20, 60, 0, 255},
    .ID = 1,
};

Berry berry = {
    .w = tileSize,
    .h = tileSize,
    .colour = {40, 0, 255, 255},
    .ID = 2,
};

const float tileSize = 32;
const int gridWidth = SCREEN_WIDTH / tileSize;
const int gridHeight = SCREEN_HEIGHT / tileSize;

int grid[gridWidth][gridHeight] = {0};

void InitializeGrid() {
    grid[5][5] = apple.ID;
    grid[10][15] = berry.ID;
    grid[20][20] = apple.ID;
    grid[16][14] = berry.ID;
    grid[32][30] = apple.ID;
}

void DrawItem() {
    for (int y = 0; y < gridHeight; y++) {
        for (int x = 0; x < gridWidth; x++) {
            if (grid[x][y] == apple.ID) {
                DrawCircle(x * tileSize, y * tileSize, apple.radius, apple.colour);
            }
            if (grid[x][y] == berry.ID) {
                DrawRectangle(x * tileSize, y * tileSize, berry.w, berry.h, berry.colour);
            }
        }
    }
}

void UpdateItem() {
    int playerGridX = playerTexture.w / tileSize;
    int playerGridY = playerTexture.h / tileSize;

    Rectangle playerRect = {
        player.pos.x,
        player.pos.y,
        playerTexture.w,
        playerTexture.h,
    };

    for (int y = 0; y < gridHeight; y++) {
        for (int x = 0; x < gridWidth; x++) {
            if (grid[x][y] == apple.ID) {
                Vector2 appleCenter = {x * tileSize + apple.radius, y * tileSize + apple.radius};
                if (CheckCollisionCircleRec(appleCenter, apple.radius, playerRect)) {
                    grid[x][y] = 0;
                    AddItemToInventory(apple.ID);
                }
            }
            if (grid[x][y] == berry.ID) {
                Rectangle berryRect = {x * tileSize, y * tileSize, berry.w, berry.h};
                if (CheckCollisionRecs(berryRect, playerRect)) {
                    grid[x][y] = 0;
                    AddItemToInventory(berry.ID);
                }
            }
        }
    }
}
