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

void DrawGrid() {
    for (int x = 0; x <= gridWidth; x++) {
        DrawLine(x * tileSize, 0, x * tileSize, SCREEN_HEIGHT, BLACK);
    }

    for (int y = 0; y <= gridHeight; y++) {
        DrawLine(0, y * tileSize, SCREEN_WIDTH, y * tileSize, BLACK);
    }
}

void DrawItem() {
    for (int y = 0; y < gridHeight; y++) {
        for (int x = 0; x < gridWidth; x++) {
            if (grid[x][y] == apple.ID) {
                DrawCircle(x * tileSize + tileSize / 2, y * tileSize + tileSize / 2, apple.radius, apple.colour);
            }
            if (grid[x][y] == berry.ID) {
                DrawRectangle(x * tileSize, y * tileSize, berry.w, berry.h, berry.colour);
            }
        }
    }
}

void UpdateItem() {
    int mouseGridX = mouse.pos.x / tileSize;
    int mouseGridY = mouse.pos.y / tileSize;

    if (mouseGridX >= 0 && mouseGridX < gridWidth && mouseGridY >= 0 && mouseGridY < gridHeight) {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
            if (grid[mouseGridX][mouseGridY] == apple.ID) {
                Vector2 appleCenter = {mouseGridX * tileSize + apple.radius, mouseGridY * tileSize + apple.radius};
                if (CheckCollisionPointCircle(mouse.pos, appleCenter, apple.radius)) {
                    grid[mouseGridX][mouseGridY] = 0;
                    AddItemToInventory(apple.ID);
                }
            }
            if (grid[mouseGridX][mouseGridY] == berry.ID) {
                Rectangle berryRect = {mouseGridX * tileSize, mouseGridY * tileSize, berry.w, berry.h};
                if (CheckCollisionPointRec(mouse.pos, berryRect)) {
                    grid[mouseGridX][mouseGridY] = 0;
                    AddItemToInventory(berry.ID);
                }
            }
        }
    }
}

