#pragma once
#include <raylib.h>

typedef struct {
    int radius;
    Color colour;
    int ID;
} Apple;

typedef struct {
    int w;
    int h;
    Color colour;
    int ID;
} Berry;

extern Vector2 mousePos;

extern const int tileSize;
extern const int gridWidth;
extern const int gridHeight;
extern int grid[][33];

void InitializeGrid();
void DrawItem();
void UpdateItem();
