#include "../headers/items.hpp"
#include "../headers/game.hpp"
#include "../headers/player.hpp"
#include <raylib.h>

Apple apple = {
    .radius = tileSize,
    .colour = {20, 60, 0, 255},
    .ID = 1,
};

Berry berry = {
    .w = tileSize,
    .h = tileSize,
    .colour = {40, 0, 255, 255},
    .ID = 2,
};

const int tileSize = 32;
const int gridWidth = SCREEN_WIDTH / tileSize;
const int gridHeight = SCREEN_HEIGHT / tileSize;

int grid[gridWidth][gridHeight] = {0};

void DrawItem() {
    grid[5][5] = apple.ID;
    grid[10][15] = berry.ID;
    grid[20][20] = apple.ID;
    grid[16][14] = berry.ID;
    grid[32][30] = apple.ID;

    // Loop over array and draw here
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
    int playerGridX = player.pos.x / tileSize;
    int playerGridY = player.pos.y / tileSize;

    if (grid[playerGridX][playerGridY] == apple.ID) {
        grid[playerGridX][playerGridY] = 0;
    }
    if (grid[playerGridX][playerGridY] == berry.ID) {
        grid[playerGridX][playerGridY] = 0;
    }
}
