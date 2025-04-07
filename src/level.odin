package game

import rl "vendor:raylib"

delta: f32

Level :: struct {
	pickups:     [dynamic]Krushem,
	obstacles:   [dynamic]Rock,
	enemies:     [dynamic]Enemy,
	projectiles: [dynamic]Spell,
	editor:      bool,
}

l: Level
