#pragma once
#include <raylib.h>

typedef struct {
    float radius;
    Color colour;
    int ID;
} Apple;

typedef struct {
    float w;
    float h;
    Color colour;
    int ID;
} Berry;

extern Vector2 mousePos;

extern Apple apple;
extern Berry berry;

extern const float tileSize;
extern const int gridWidth;
extern const int gridHeight;
extern int grid[][33];

void InitializeGrid();
void DrawGrid();
void DrawItem();
void UpdateItem();
