#include "raylib.h"

#define SCREEN_WIDTH (1920)
#define SCREEN_HEIGHT (1080)

typedef enum State {
	MENU,
	GAME,
}State;

typedef struct GameSate {
	State state;
	int playerHeight;
	int playerWidth;
	Vector2 playerPos;
	float playerSpeed;
}GameState;

static const GameState DefaultState = {
	.state = MENU,
	.playerHeight = 150,
	.playerWidth = 50,
	.playerPos = {SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f},
	.playerSpeed = 500.0f,
};

int main() {
	InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Forage Game");
	SetTargetFPS(120);

	GameState gameState = DefaultState;

	const int tileSize = 32;
	const int gridWidth = SCREEN_WIDTH / tileSize;
	const int gridHeight = SCREEN_HEIGHT / tileSize;

	int grid[gridHeight][gridWidth] = { 0 };
	
	// will randomize later 
	grid[5][5] = 1;
	grid[10][15] = 2;

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(DARKGREEN);
	
		switch (gameState.state)
		{
		case MENU:
		{
			DrawText("PRESS ENTER", SCREEN_WIDTH / 2 - MeasureText("PRESS ENTER", 20) / 2, 20, 20, WHITE);
			if (IsKeyPressed(KEY_ENTER)) {
				gameState = DefaultState;
				gameState.state = GAME;
			}
			break;
		}
		case GAME:
		{
			// Player Movement
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

			// Draw grid and objects
			for (int y = 0; y < gridHeight; y++) {
				for (int x = 0; x < gridWidth; x++) {
					if (grid[y][x] == 1) {
						DrawRectangle(x * tileSize, y * tileSize, tileSize, tileSize, RED);
					}

					if (grid[y][x] == 2) {
						DrawRectangle(x * tileSize, y * tileSize, tileSize, tileSize, BLUE);
					}
				}
			}
		}
		}
		EndDrawing();
	}

	CloseWindow();
	return 0;
}