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

void DrawInventory(Camera2D camera) {
    if (!isInventoryOpen)
        return;

    Vector2 mousePos = GetMousePosition();

    float xOffset = camera.target.x - SCREEN_WIDTH / 2.0f;
    float yOffset = camera.target.y - SCREEN_HEIGHT / 2.0f;

    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        float adjustedX = inventory[i].rect.x * camera.zoom + xOffset;
        float adjustedY = inventory[i].rect.y * camera.zoom + yOffset;

        bool isMouseOver = CheckCollisionPointRec(mousePos, {adjustedX, adjustedY, inventory[i].rect.width, inventory[i].rect.height});
        inventory[i].selected = isMouseOver;

        DrawRectangleRec({adjustedX, adjustedY, inventory[i].rect.width * camera.zoom, inventory[i].rect.height * camera.zoom}, LIGHTGRAY);
        DrawRectangleLinesEx({adjustedX, adjustedY, inventory[i].rect.width * camera.zoom, inventory[i].rect.height * camera.zoom}, 2, inventory[i].selected ? RED : BLACK);

        if (inventory[i].itemID == 1) {
            DrawRectangle(adjustedX + 10, adjustedY + 10, 20 * camera.zoom, 20 * camera.zoom, RED);
            DrawText(TextFormat("%d", inventory[i].count), adjustedX + 40 * camera.zoom, adjustedY + 10 * camera.zoom, 20, WHITE);
        }
    }
}

void ToggleInventory() { isInventoryOpen = !isInventoryOpen; }
