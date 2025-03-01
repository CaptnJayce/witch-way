#pragma once
#include <raylib.h>

typedef struct {
    Vector2 pos;
    float speed;
    float w;
    float h;

    Color colour;
    Color pickUpRadius;
    Color hitBox;
} Player;

extern Player player;

void PlayerDraw();
void PlayerUpdate();
