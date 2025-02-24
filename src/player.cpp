#include "../headers/player.hpp"
#include "../headers/game.hpp"

Player player = {
    .speed = 350.0f,
    .pos = {},
};

PlayerTexutre playerTexture = {
    .w = 30,
    .h = 75,
    .colour = {120, 81, 169, 255},
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

void PlayerDraw() {
    DrawRectangle(player.pos.x, player.pos.y, playerTexture.w, playerTexture.h,
                  playerTexture.colour);
}
