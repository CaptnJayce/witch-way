package game

import rl "vendor:raylib"
import "core:fmt"
import "core:encoding/json"
import "core:os"

save :: proc() {
    if data, err := json.marshal(p.position, allocator = context.temp_allocator); err == nil {
        fmt.println("saving")
        os.write_entire_file("save.json", data)
    }
}

load :: proc() {
    if data, ok := os.read_entire_file("save.json", context.temp_allocator); ok {
        if json.unmarshal(data, &p.position) != nil {}
    } else {
        p.position = {0, 0}
    }
}
