#include <raylib.h>

typedef struct {
    Rectangle rect;
    float w;
    float h;
    float speed;
    Vector2 pos;
    Color colour;
} Player;

// move camera here later

extern Player player;

void playerMovement();
