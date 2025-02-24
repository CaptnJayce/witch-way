#include "../headers/inventory.hpp"
#include "../headers/items.hpp"

InventorySlot inventory[GRID_SIZE * GRID_SIZE];
bool isInventoryOpen = false;

void InitInventory() {
    for (int y = 0; y < GRID_SIZE; y++) {
        for (int x = 0; x < GRID_SIZE; x++) {
            inventory[y * GRID_SIZE + x] = {
                {static_cast<float>(START_X + x * (SLOT_SIZE + PADDING)), static_cast<float>(START_Y + y * (SLOT_SIZE + PADDING)), static_cast<float>(SLOT_SIZE), static_cast<float>(SLOT_SIZE)},
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

void DrawItemInSlot(InventorySlot slot, float adjustedX, float adjustedY, float zoom) {
    if (slot.itemID == 1) {
        DrawCircle(adjustedX + SLOT_SIZE * zoom / 2, adjustedY + SLOT_SIZE * zoom / 2, apple.radius * zoom, apple.colour);
    } else if (slot.itemID == 2) {
        float berryX = adjustedX + (SLOT_SIZE * zoom - berry.w * zoom) / 2;
        float berryY = adjustedY + (SLOT_SIZE * zoom - berry.h * zoom) / 2;
        DrawRectangle(berryX, berryY, berry.w * zoom, berry.h * zoom, berry.colour);
    }

    if (slot.count > 1) {
        DrawText(TextFormat("%d", slot.count), adjustedX + 40 * zoom, adjustedY + 10 * zoom, 20, WHITE);
    }
}

void DrawInventory(Camera2D camera) {
    if (!isInventoryOpen)
        return;

    Vector2 mousePos = GetMousePosition();

    float xOffset = camera.target.x - SCREEN_WIDTH / 2.0f;
    float yOffset = camera.target.y - SCREEN_HEIGHT / 2.0f;

    mousePos.x = (mousePos.x + xOffset) / camera.zoom;
    mousePos.y = (mousePos.y + yOffset) / camera.zoom;

    for (int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        float adjustedX = inventory[i].rect.x * camera.zoom + xOffset;
        float adjustedY = inventory[i].rect.y * camera.zoom + yOffset;

        bool isMouseOver = CheckCollisionPointRec(mousePos, {adjustedX, adjustedY, inventory[i].rect.width * camera.zoom, inventory[i].rect.height * camera.zoom});
        inventory[i].selected = isMouseOver;

        DrawRectangleRec({adjustedX, adjustedY, inventory[i].rect.width * camera.zoom, inventory[i].rect.height * camera.zoom}, LIGHTGRAY);
        DrawRectangleLinesEx({adjustedX, adjustedY, inventory[i].rect.width * camera.zoom, inventory[i].rect.height * camera.zoom}, 2, inventory[i].selected ? RED : BLACK);

        if (inventory[i].itemID != 0) {
            DrawItemInSlot(inventory[i], adjustedX, adjustedY, camera.zoom);
        }
    }
}

void ToggleInventory() { isInventoryOpen = !isInventoryOpen; }
