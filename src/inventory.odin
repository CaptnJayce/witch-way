package game

import rl "vendor:raylib"

SLOT_SIZE :: 60
INVENTORY_COLUMNS :: 5
INVENTORY_ROWS :: 10
TOTAL_SLOTS :: INVENTORY_ROWS * INVENTORY_COLUMNS

ItemType :: enum {
	None,
	Berry,
}
ItemStack :: struct {
	item:  ItemType,
	count: int,
}
Inventory :: struct {
	slots: [TOTAL_SLOTS]ItemStack,
}

i: Inventory
toggled := false

init_inventory :: proc() {
	i.slots[0] = ItemStack{.Berry, 0}
}

toggle_inventory :: proc() {
	if rl.IsKeyPressed(.E) {
		toggled = !toggled
	}
}

draw_inventory :: proc() {
	total_length: i32 = INVENTORY_COLUMNS * SLOT_SIZE
	total_height: i32 = INVENTORY_ROWS * SLOT_SIZE
	offset_x: i32 = (SW / 2) - (total_length / 2)
	offset_y: i32 = 40

	draw_at_x: i32 = offset_x
	draw_at_y: i32 = offset_y

	if toggled {
		rl.DrawRectangle(draw_at_x, draw_at_y, total_length, total_height, {100, 100, 100, 200})

		for idx in 0 ..< TOTAL_SLOTS {
			rl.DrawRectangleLines(draw_at_x, draw_at_y, SLOT_SIZE, SLOT_SIZE, rl.WHITE)

			item_stack := i.slots[idx]
			if item_stack.item != .None {
				#partial switch item_stack.item {
				case .Berry:
					if item_stack.count <= 0 {
						rl.DrawTextureRec(
							k.texture,
							berry_source,
							{f32(draw_at_x + 5), f32(draw_at_y + 5)},
							{50, 50, 50, 100},
						)
					} else {
						rl.DrawTextureRec(
							k.texture,
							berry_source,
							{f32(draw_at_x + 5), f32(draw_at_y + 5)},
							rl.WHITE,
						)
					}

					// rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.RED)
					rl.DrawText(
						rl.TextFormat("%d", item_stack.count),
						draw_at_x,
						draw_at_y,
						20,
						rl.WHITE,
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
}
