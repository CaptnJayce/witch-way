package game 

import rl "vendor:raylib"
import "core:fmt"

ItemType :: enum {
    None,
    Berry,
}
ItemStack :: struct {
    item: ItemType,
    count: int,
}
Inventory :: struct {
    slots:[TOTAL_SLOTS]ItemStack, 
}

i: Inventory

init_inventory :: proc() {
    i.slots[0] = ItemStack{.Berry, 0}
}

draw_inventory :: proc(berry_sprite: rl.Texture2D, open: bool) {
    berry_source := rl.Rectangle {
            x = 0,
            y = 0,
            width = 48,
            height = 48,
    }

    total_length : i32  = INVENTORY_COLUMNS * SLOT_SIZE 
    offset_x : i32 = (SW / 2) - (total_length / 2)
    offset_y : i32 = 40 

    draw_at_x : i32 = offset_x 
    draw_at_y : i32 = offset_y

    if open {
        for idx in 0..<TOTAL_SLOTS {
            rl.DrawRectangleLines(draw_at_x, draw_at_y, SLOT_SIZE, SLOT_SIZE, rl.WHITE)

            item_stack := i.slots[idx]
            if item_stack.item != .None {
                #partial switch item_stack.item {
                case .Berry:
                    rl.DrawTextureRec(berry_sprite, berry_source, {f32(draw_at_x), f32(draw_at_y)}, rl.WHITE)

                    // rl.DrawRectangle(draw_at_x, draw_at_y, 20, 20, rl.RED)
                    rl.DrawText(rl.TextFormat("%d", item_stack.count), draw_at_x, draw_at_y, 20, rl.WHITE)
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

