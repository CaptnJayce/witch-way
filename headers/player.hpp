#include <raylib.h>
#include "../headers/inventory.hpp"

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

void PlayerMovement();
void CameraMovement();
void DrawPlayer();
