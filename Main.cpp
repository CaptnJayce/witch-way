#include "raylib.h"

#define SCREEN_WIDTH (1920)
#define SCREEN_HEIGHT (1080)

typedef struct GameSate {
	int playerHeight;
	int playerWidth;
	Vector2 playerPos;
	float playerSpeed;
}GameState;

static const GameState DefaultState = {
	.playerHeight = 150,
	.playerWidth = 50,
	.playerPos = {SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f},
	.playerSpeed = 500.0f,
};

int main() {
	InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Forage Game");
	SetTargetFPS(120);

	GameState gameState = DefaultState;

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(DARKGREEN);

		if (IsKeyDown(KEY_W)) {
			gameState.playerPos.y -= gameState.playerSpeed * GetFrameTime();
		}
		if (IsKeyDown(KEY_S)) {
			gameState.playerPos.y += gameState.playerSpeed * GetFrameTime();
		}
		if (IsKeyDown(KEY_A)) {
			gameState.playerPos.x -= gameState.playerSpeed * GetFrameTime();
		}
		if (IsKeyDown(KEY_D)) {
			gameState.playerPos.x += gameState.playerSpeed * GetFrameTime();
		}

		DrawRectangle(gameState.playerPos.x, gameState.playerPos.y, gameState.playerWidth, gameState.playerHeight, WHITE);

		EndDrawing();
	}


	CloseWindow();
	return 0;
}