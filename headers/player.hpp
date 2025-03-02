#pragma once
#include <raylib.h>

typedef struct {
    Vector2 pos;
    float speed;
    float w;
    float h;

    float pickUp; 
    Color colour;
    Color pickUpRadius;
    Color hitBox;
} Player;

typedef struct {
    Vector2 pos;
    float radius;
    Color hitbox;
} Mouse;

extern Player player;
extern Mouse mouse;

void PlayerDraw();
void PlayerUpdate();
void MouseDraw();
void MouseUpdate();
