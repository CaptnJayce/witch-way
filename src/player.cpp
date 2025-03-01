#include "../headers/player.hpp"
#include "../headers/game.hpp"
#include <raylib.h>

Player player = {
    .pos = {},
    .speed = 350.0f,
    .w = 60,
    .h = 150,
    .colour = {120, 81, 169, 255},
    .pickUpRadius = {0, 255, 255, 100},
};

Mouse mouse = {
    .pos = {},
    .radius = 25,
    .hitbox = {255, 0, 255, 255},
};

Camera2D camera = {0};

void PlayerUpdate() {
    if (IsKeyDown(KEY_W)) {
        player.pos.y -= player.speed * GetFrameTime();
    }
    if (IsKeyDown(KEY_S)) {
        player.pos.y += player.speed * GetFrameTime();
    }
    if (IsKeyDown(KEY_A)) {
        player.pos.x -= player.speed * GetFrameTime();
    }
    if (IsKeyDown(KEY_D)) {
        player.pos.x += player.speed * GetFrameTime();
    }

    camera.target = (Vector2){player.pos.x + 20.0f, player.pos.y + 20.0f};
    camera.offset = (Vector2){SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f};
    camera.rotation = 0.0f;
    camera.zoom = 1.0f;
}

void MouseUpdate() {
    mouse.pos = GetScreenToWorld2D(GetMousePosition(), camera);
}

void PlayerDraw() {
    DrawRectangle(player.pos.x, player.pos.y, player.w, player.h,
                  player.colour);
    DrawCircle(player.pos.x + (player.w / 2), player.pos.y + (player.h / 2), 175, player.pickUpRadius);
}

void MouseDraw() {
    DrawCircle(mouse.pos.x, mouse.pos.y, mouse.radius, mouse.hitbox);
}
