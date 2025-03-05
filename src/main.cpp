#include <math.h>
#include <raylib.h>
#include <raymath.h>
#include <vector>

#define SCREEN_WIDTH 1280
#define SCREEN_HEIGHT 720
#define TEMP_BLUE {38, 187, 217, 255}

class Player {
public:
  Vector2 pos;
  Color colour;
  int h;
  int w;
  float speed;

  void Move() {
    if (IsKeyDown(KEY_W))
      pos.y -= speed * GetFrameTime();
    if (IsKeyDown(KEY_S))
      pos.y += speed * GetFrameTime();
    if (IsKeyDown(KEY_A))
      pos.x -= speed * GetFrameTime();
    if (IsKeyDown(KEY_D))
      pos.x += speed * GetFrameTime();
  }

  Player(Vector2 pos, Color colour, int h, int w, float speed) {
    this->pos = pos;
    this->colour = colour;
    this->h = h;
    this->w = w;
    this->speed = speed;
  }
};

class Berry {
public:
  Vector2 pos;
  Color colour;
  int itemRadius;
  int pickupRadius;
  bool pickedUp;

  Berry(Vector2 pos, Color colour, int itemRadius, int pickupRadius) {
    this->pos = pos;
    this->colour = colour;
    this->itemRadius = itemRadius;
    this->pickupRadius = pickupRadius;
    this->pickedUp = false;
  }
};

class Grape {
public:
  Vector2 pos;
  Color colour;
  int itemRadius;
  int pickupRadius;
  bool pickedUp;

  Grape(Vector2 pos, Color colour, int itemRadius, int pickupRadius) {
    this->pos = pos;
    this->colour = colour;
    this->itemRadius = itemRadius;
    this->pickupRadius = pickupRadius;
    this->pickedUp = false;
  }
};

class Inventory {
public:
};

int pickups;
void debugInfo() {
  DrawFPS(10, 20);
  DrawText(TextFormat("Pickups: %d", pickups), 10, 50, 20, BLACK);
}

float pickupRange(const Player &player, const Vector2 &itemPos) {
  return Vector2Distance(player.pos, itemPos);
}

int main() {
  InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "witch way");
  SetTargetFPS(120);

  Player p(Vector2{600, 600}, BLACK, 70, 35, 250.0);

  std::vector<Berry> berries = {
      Berry(Vector2{400, 600}, TEMP_BLUE, 15, 75),
      Berry(Vector2{700, 800}, TEMP_BLUE, 15, 75),
      Berry(Vector2{200, 300}, TEMP_BLUE, 15, 75)};

  std::vector<Grape> grapes = {
      Grape(Vector2{800, 100}, PURPLE, 15, 75),
      Grape(Vector2{600, 200}, PURPLE, 15, 75),
      Grape(Vector2{300, 300}, PURPLE, 15, 75)};

  while (!WindowShouldClose()) {
    // update
    p.Move();

    for (Berry &berry : berries) {
      if (!berry.pickedUp) {
        float dist = pickupRange(p, berry.pos);

        if (dist <= berry.pickupRadius) {
          if (IsKeyPressed(KEY_E)) {
            berry.pickedUp = true;
            berry.colour = RED;
            pickups++; // debug info
          }
        }
      }
    }

    for (Grape &grape : grapes) {
      if (!grape.pickedUp) {
        float dist = pickupRange(p, grape.pos);

        if (dist <= grape.pickupRadius) {
          if (IsKeyPressed(KEY_E)) {
            grape.pickedUp = true;
            grape.colour = RED;
            pickups++; // debug info
          }
        }
      }
    }

    // draw
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawRectangle(p.pos.x, p.pos.y, p.w, p.h, p.colour);

    for (const Berry &berry : berries) {
      if (!berry.pickedUp) {
        DrawCircle(berry.pos.x, berry.pos.y, berry.itemRadius, berry.colour);
        DrawCircleLines(berry.pos.x, berry.pos.y, berry.pickupRadius, berry.colour);
      }
    }
    for (const Grape &grape : grapes) {
      if (!grape.pickedUp) {
        DrawCircle(grape.pos.x, grape.pos.y, grape.itemRadius, grape.colour);
        DrawCircleLines(grape.pos.x, grape.pos.y, grape.pickupRadius, grape.colour);
      }
    }

    debugInfo();
    EndDrawing();
  }

  CloseWindow();
}
