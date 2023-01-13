const c = @cImport({
    @cInclude("metacall/metacall.h");
});

const std = @import("std");

pub fn main() !void {
    var info_lines = std.mem.split(
        u8,
        std.mem.span(@ptrCast([*:0]const u8, c.metacall_print_info())),
        "\n",
    );
    if (info_lines.next()) |first|
        if (info_lines.next()) |second|
            std.debug.print("\x1b[90m{s} - {s}\x1b[0m\n", .{ first, second });

    if (c.metacall_initialize() != 0) return error.InitializationFailed;
    defer if (c.metacall_destroy() != 0) @panic("Failed to destroy");

    var node_paths = [_][*:0]const u8{"hello/hello.js"};
    if (c.metacall_load_from_file(
        "node",
        @ptrCast([*c][*c]const u8, &node_paths),
        1,
        null,
    ) != 0) return error.LoadFromFileFailed;

    // Python didn't really work, sorry. PR this repo to fix it!

    // var py_paths = [_][*:0]const u8{"hello/hello.py"};
    // if (c.metacall_load_from_file(
    //     "py",
    //     @ptrCast([*c][*c]const u8, &py_paths),
    //     1,
    //     null,
    // ) != 0) return error.LoadFromFileFailed;
}
