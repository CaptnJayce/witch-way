package game

import "core:fmt"
import rl "vendor:raylib"

SLOT_SIZE :: 48
INVENTORY_COLUMNS :: 4
INVENTORY_ROWS :: 6
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

SLOT_SIZE_TWO :: 140
INVENTORY_COLUMNS_TWO :: 13
INVENTORY_ROWS_TWO :: 7
TOTAL_SLOTS_TWO :: INVENTORY_ROWS_TWO * INVENTORY_COLUMNS_TWO

ItemType :: enum {
	None,

	// Pickups
	Krushem,

	// Spells
	NebulaEye,
	NebulaBolt,
	NebulaShield,
}
ItemStack :: struct {
	item:  ItemType,
	count: int,
}

Inventory :: struct {
	slots:     [TOTAL_SLOTS]ItemStack,
	page_zero: rl.Texture2D,
	page_one:  rl.Texture2D,
	page_two:  rl.Texture2D,
}

SpellInventory :: struct {
	slots: [TOTAL_SLOTS_TWO]ItemStack,
}

Page :: enum {
	Main,
	Pickups,
	Hunts,
}

current_page := Page.Main
i: Inventory
si: SpellInventory

init_inventory :: proc() {
	i.page_zero = rl.LoadTexture("textures/player/sprite_inventory_page_0.png")
	i.page_one = rl.LoadTexture("textures/player/sprite_inventory_page_1.png")

	// Pickup slots
	i.slots[0] = ItemStack{.Krushem, 0}
}

init_spell_inventory :: proc() {
	si.slots[0] = ItemStack{.NebulaEye, 0}
	si.slots[1] = ItemStack{.NebulaBolt, 0}
	si.slots[2] = ItemStack{.NebulaShield, 0}
}

toggled := false
a_toggled := false
toggle_inventory :: proc() {
	if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.A) || rl.IsKeyPressed(.S) || rl.IsKeyPressed(.D) {
		toggled = false
		a_toggled = false
	}

	if rl.IsKeyPressed(.E) && enable_attunement == false {
		toggled = !toggled
	}

	if rl.IsKeyPressed(.E) && enable_attunement == true {
		a_toggled = !a_toggled
	}
}

draw_inventory :: proc() {
	if toggled {
		if rl.IsKeyPressed(.ONE) {
			current_page = .Main
		}
		if rl.IsKeyPressed(.TWO) {
			current_page = .Pickups
		}
	}

	if toggled {
		switch current_page {
		case .Main:
			draw_main_page()
		case .Pickups:
			draw_pickups_page()
		case .Hunts:

		}
	}
}

draw_main_page :: proc() {
	rl.DrawTextureRec(i.page_zero, {0, 0, 320, 480}, {f32(SWH - 160), f32(SHH - 240)}, rl.WHITE)
}

draw_pickups_page :: proc() {
	rl.DrawTextureRec(i.page_one, {0, 0, 640, 480}, {f32(SWH - 320), f32(SHH - 240)}, rl.WHITE)

	total_length: i32 = INVENTORY_COLUMNS * SLOT_SIZE
	total_height: i32 = INVENTORY_ROWS * SLOT_SIZE
	offset_x: i32 = 680
	offset_y: i32 = 330

	draw_x: i32 = offset_x
	draw_y: i32 = offset_y

	for idx in 0 ..< TOTAL_SLOTS {
		item_stack := i.slots[idx]
		if item_stack.item != .None {
			#partial switch item_stack.item {
			case .Krushem:
				pos := rl.Vector2{f32(draw_x) + 11, f32(draw_y) + 11}
				color := item_stack.count > 0 ? rl.WHITE : {40, 40, 40, 200}
				rl.DrawTextureEx(k.texture, pos, 0, 3, color)

				rl.DrawText(
					rl.TextFormat("%d", item_stack.count),
					draw_x + 12,
					draw_y + 42,
					20,
					rl.BLACK,
				)
			}
		}

		draw_x += SLOT_SIZE

		if draw_x == (offset_x + (INVENTORY_COLUMNS * SLOT_SIZE)) {
			draw_x = offset_x
			draw_y += SLOT_SIZE
		}
	}
}

draw_attunement :: proc() {
	if a_toggled {
		gap: i32 = 50

		rl.DrawRectangleLines(gap, gap, SW - (gap * 2), SH - (gap * 2), rl.WHITE)

		total_length: i32 = SW - gap
		total_height: i32 = SH - gap
		offset_x: i32 = gap
		offset_y: i32 = gap

		draw_x: i32 = offset_x
		draw_y: i32 = offset_y

		for idx in 0 ..< TOTAL_SLOTS_TWO {
			rl.DrawRectangleLines(draw_x, draw_y, SLOT_SIZE_TWO, SLOT_SIZE_TWO, rl.WHITE)

			item_stack := si.slots[idx]
			if item_stack.item != .None {
				#partial switch item_stack.item {
				case .NebulaEye:
					pos := rl.Vector2{f32(draw_x) + 5, f32(draw_y) + 5}
					color := nebulaEye.unlocked ? rl.WHITE : {40, 40, 40, 200}
					rl.DrawTextureEx(nebulaEye.icon, pos, 0, 4, color)

				case .NebulaBolt:
					pos := rl.Vector2{f32(draw_x) + 5, f32(draw_y) + 5}
					color := nebulaBolt.unlocked ? rl.WHITE : {40, 40, 40, 200}
					rl.DrawTextureEx(nebulaBolt.icon, pos, 0, 4, color)

				case .NebulaShield:
					pos := rl.Vector2{f32(draw_x) + 5, f32(draw_y) + 5}
					color := nebulaShield.unlocked ? rl.WHITE : {40, 40, 40, 200}
					rl.DrawTextureEx(nebulaShield.icon, pos, 0, 4, color)
				}
			}

			draw_x += SLOT_SIZE_TWO

			if draw_x == (offset_x + (INVENTORY_COLUMNS_TWO * SLOT_SIZE_TWO)) {
				draw_x = offset_x
				draw_y += SLOT_SIZE_TWO
			}
		}

		rl.ClearBackground({30, 28, 30, 255})
	}
}
