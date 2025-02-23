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

PlayerHitbox playerHitbox = {
    .rect = {},
    .w = 30,
    .h = 75,
    .colour = {255, 204, 203, 0},
};

Camera2D camera = {0};

void CameraMovement() {
    camera.target = (Vector2){player.pos.x + 20.0f, player.pos.y + 20.0f};
    camera.offset = (Vector2){SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f};
    camera.rotation = 0.0f;
    camera.zoom = 1.0f;
}

void PlayerMovement() {
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
}

void DrawPlayer() {
    DrawRectangle(player.pos.x, player.pos.y, playerTexture.w, playerTexture.h,
                  playerTexture.colour);
    playerHitbox.rect = {player.pos.x, player.pos.y, playerHitbox.w, playerHitbox.h};
    DrawRectangleRec(playerHitbox.rect, playerHitbox.colour);
}
