package game

import rl "vendor:raylib"

delta: f32

Level :: struct {
	pickups:   [dynamic]Krushem,
	obstacles: [dynamic]Rock,
	enemies:   [dynamic]Enemy,
	editor:    bool,
}

l: Level

