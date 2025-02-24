#include "../headers/items.hpp"
#include "../headers/game.hpp"
#include <raylib.h>

Apple apple = {
    .radius = 8,
    .colour = {20, 60, 0, 255},
    .ID = 1,
};

Berry berry = {
    .w = 8,
    .h = 6,
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
                DrawCircle(x, y, apple.radius, apple.colour);
            }
            if (grid[x][y] == berry.ID) {
                DrawRectangle(x, y, berry.w, berry.h, berry.colour);
            }
        }
    }
}
void UpdateItem() {}
