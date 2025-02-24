#pragma once
#include <raylib.h>

typedef struct {
    float speed;
    Vector2 pos;
} Player;

typedef struct {
    float w;
    float h;
    Color colour;
} PlayerTexutre;

extern Player player;
extern PlayerTexutre texture;

void PlayerDraw();
void PlayerUpdate();
