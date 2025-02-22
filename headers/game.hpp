#pragma once
#include <raylib.h>

// Screen dimensions
#define SCREEN_WIDTH  (1920)
#define SCREEN_HEIGHT (1080)

// Game state
typedef enum State {
    MENU,
    GAME,
} State;

typedef struct GameState {
    State state;
    float playerHeight;
    float playerWidth;
    Vector2 playerPos;
    float playerSpeed;
} GameState;

extern const GameState DefaultState;
