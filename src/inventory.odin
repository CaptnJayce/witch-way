package game

import "core:fmt"
import rl "vendor:raylib"

ItemType :: enum {
	None,
	Krushem,
}
ItemStack :: struct {
	item:  ItemType,
	count: int,
}
Inventory :: struct {
	slots:     [TOTAL_SLOTS]ItemStack,
	page_zero: rl.Texture2D,
	page_one:  rl.Texture2D,
}

Page :: enum {
	Main,
	Pickups,
	Hunts,
	Spells,
}

current_page := Page.Main
i: Inventory
toggled := false

init_inventory :: proc() {
	i.page_zero = rl.LoadTexture("textures/player/sprite_inventory_page_0.png")
	i.page_one = rl.LoadTexture("textures/player/sprite_inventory_page_1.png")
	i.slots[0] = ItemStack{.Krushem, 0}
}

toggle_inventory :: proc() {
	if rl.IsKeyPressed(.E) {
		toggled = !toggled
	}
}

draw_inventory :: proc() {
	if rl.IsKeyPressed(.ONE) {
		current_page = .Main
	}
	if rl.IsKeyPressed(.TWO) {
		current_page = .Spells
	}
	if rl.IsKeyPressed(.THREE) {
		current_page = .Pickups
	}


	if toggled {
		switch current_page {
		case .Main:
			draw_main_page()
		case .Spells:
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

	draw_at_x: i32 = offset_x
	draw_at_y: i32 = offset_y

	for idx in 0 ..< TOTAL_SLOTS {
		item_stack := i.slots[idx]
		if item_stack.item != .None {
			#partial switch item_stack.item {
			case .Krushem:
				if item_stack.count <= 0 {
					rl.DrawTextureEx(
						k.texture,
						{f32(draw_at_x + 11), f32(draw_at_y + 11)},
						0,
						3,
						{100, 100, 100, 110},
					)
				} else {
					rl.DrawTextureEx(
						k.texture,
						{f32(draw_at_x + 11), f32(draw_at_y + 11)},
						0,
						3,
						rl.WHITE,
					)
				}

				rl.DrawText(
					rl.TextFormat("%d", item_stack.count),
					draw_at_x + 12,
					draw_at_y + 42,
					20,
					rl.BLACK,
				)
			}
		}

		draw_at_x += SLOT_SIZE

		if draw_at_x == (offset_x + (INVENTORY_COLUMNS * SLOT_SIZE)) {
			draw_at_x = offset_x
			draw_at_y += SLOT_SIZE
		}
	}
}
