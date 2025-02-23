#include "../headers/inventory.hpp"

InventorySlot inventory[GRID_SIZE * GRID_SIZE];
bool isInventoryOpen = false;

Apple apple = {
    .appleWidth = 10,
    .appleHeight = 10,
    .appleTotal = 0,
    .ID = 1,
};

void InitInventory() {
    for (int y = 0; y < GRID_SIZE; y++) {
        for (int x = 0; x < GRID_SIZE; x++) {
            inventory[y * GRID_SIZE + x] = {
                {static_cast<float>(START_X + x * (SLOT_SIZE + PADDING)),
                 static_cast<float>(START_Y + y * (SLOT_SIZE + PADDING)),
                 static_cast<float>(SLOT_SIZE), static_cast<float>(SLOT_SIZE)},
                0,
                0,
                0};
        }
    }
}

void AddItemToInventory(int itemID) {
    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        if (inventory[i].itemID == itemID) {
            inventory[i].count++;
            return;
        }
    }

    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        if (inventory[i].itemID == 0) {
            inventory[i].itemID = itemID;
            inventory[i].count = 1;
            return;
        }
    }
}

void DrawInventory() {
    Vector2 mousePos = GetMousePosition();

    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        bool isMouseOver = CheckCollisionPointRec(mousePos, inventory[i].rect);
        inventory[i].selected = isMouseOver;

        DrawRectangleRec(inventory[i].rect, LIGHTGRAY);
        DrawRectangleLinesEx(inventory[i].rect, 2, inventory[i].selected ? RED : BLACK);

        if (inventory[i].itemID == 1) {
            DrawRectangle(inventory[i].rect.x + 10, inventory[i].rect.y + 10, 20, 20, RED);
            DrawText(TextFormat("%d", inventory[i].count), inventory[i].rect.x + 40,
                     inventory[i].rect.y + 10, 20, WHITE);
        }
    }
}

void ToggleInventory() { isInventoryOpen = !isInventoryOpen; }
