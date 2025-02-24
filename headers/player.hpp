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

typedef struct {
    Rectangle rect;
    float w;
    float h;
    Color colour;
} PlayerHitbox;

extern Player player;
extern PlayerTexutre texture;
extern PlayerHitbox hitbox;

void PlayerDraw();
void PlayerUpdate();
