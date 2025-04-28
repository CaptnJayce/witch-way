package game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import rl "vendor:raylib"

SpellVisual :: struct {
	icon: string,
}

SpellDefinition :: struct {
	name:        string,
	description: string,
	cooldown:    f32,
	visual:      SpellVisual,
}

show_spell_menu := false
show_spell_drawer := false
highlight_attunement := false
enable_attunement := false
init_spells :: proc() {
}

draw_spell_menu :: proc() {
	if rl.Vector2Distance(p.position, attunement_p.radius) < 35 {
		highlight_attunement = true
		enable_attunement = true
	} else {
		highlight_attunement = false
		enable_attunement = false
	}

	if rl.IsKeyPressed(.LEFT_CONTROL) {
		show_spell_menu = !show_spell_menu
	}

	if show_spell_menu {
		rl.DrawCircleLinesV(p.position, 150, rl.ORANGE)
	}
}
