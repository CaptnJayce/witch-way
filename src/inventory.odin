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
open := false

init_inventory :: proc() {
    i.slots[0] = ItemStack{.Berry, 0}
}

draw_inventory :: proc() {
    if rl.IsKeyPressed(.E) {
        open = !open
    }

    berry_source := rl.Rectangle {
            x = 0,
            y = 0,
            width = 48,
            height = 48,
    }

    total_length : i32  = INVENTORY_COLUMNS * SLOT_SIZE 
    total_height : i32 = INVENTORY_ROWS * SLOT_SIZE
    offset_x : i32 = (SW / 2) - (total_length / 2)
    offset_y : i32 = 40 

    draw_at_x : i32 = offset_x 
    draw_at_y : i32 = offset_y

    if open {
        rl.DrawRectangle(draw_at_x, draw_at_y, total_length, total_height, {100, 100, 100, 200})

        for idx in 0..<TOTAL_SLOTS {
            rl.DrawRectangleLines(draw_at_x, draw_at_y, SLOT_SIZE, SLOT_SIZE, rl.WHITE)

            item_stack := i.slots[idx]
            if item_stack.item != .None {
                #partial switch item_stack.item {
                case .Berry:
                    if item_stack.count <= 0 {
                        rl.DrawTextureRec(k.texture, berry_source, {f32(draw_at_x + 5), f32(draw_at_y + 5)}, {50, 50, 50, 100})
                    } else {
                        rl.DrawTextureRec(k.texture, berry_source, {f32(draw_at_x + 5), f32(draw_at_y + 5)}, rl.WHITE)
                    }

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

