#include <raylib.h>
#include "./game.hpp"

#define GRID_SIZE 3
#define SLOT_SIZE 100
#define PADDING 10
#define START_X ((SCREEN_WIDTH - (GRID_SIZE * (SLOT_SIZE + PADDING) - PADDING)) / 2.0f)
#define START_Y ((SCREEN_HEIGHT - (GRID_SIZE * (SLOT_SIZE + PADDING) - PADDING)) / 2.0f)

typedef struct {
    Rectangle rect;
    int selected;
    int itemID;
    int count;
} InventorySlot;

typedef struct {
    int appleWidth;
    int appleHeight;
    int appleTotal;
    int ID;
} Apple;

extern Camera2D camera;

extern InventorySlot inventory[GRID_SIZE * GRID_SIZE];
extern bool isInventoryOpen;
extern Apple apple;
extern Vector2 mousePos;

void InitInventory();
void AddItemToInventory(int itemID);
void DrawInventory(Camera2D camera);
void ToggleInventory();

