const std = @import("std");
const mem = std.mem;
const io = std.io;
const json = std.json;
const StringArrayHashMap = std.array_hash_map.StringArrayHashMap;

fn parseObject(obj: StringArrayHashMap(json.Value), alloc: mem.Allocator) ![]u8 {
    const iter = obj.iterator();
    while (iter.index < iter.len) {
        const pair = iter.next();

        const key = pair.?.key_ptr;
        const value = pair.?.value_ptr;

        println("Key: {s}", .{key.*}, alloc);
    }
}

fn fromSlice(slice: []const u8, alloc: mem.Allocator) ![]u8 {
    const parsed = try json.parseFromSlice(json.Value, alloc, slice, .{});
    return parseObject(parsed.value.object, alloc);
}

fn fromFile(path: []const u8, alloc: mem.Allocator) ![]u8 {
    const buf = blk: {
        const f = try std.fs.cwd().openFile(path, .{});
        defer f.close();

        const f_len = f.getEndPos();
        const _buf = try alloc.alloc(u8, f_len);
        errdefer alloc.free(_buf);

        f.readAll(_buf);
        break :blk _buf;
    };

    defer alloc.free(buf);

    return fromSlice(buf, alloc);
}

fn print(fmt: []const u8, args: anytype, alloc: mem.Allocator) !void {
    const buf = alloc.alloc(u8, fmt.len);
    defer alloc.free(buf);

    try std.fmt.bufPrint(buf, fmt, args);
    try io.getStdOut().write(buf);
}

fn println(fmt: []const u8, args: anytype, alloc: mem.Allocator) !void {
    try print(fmt, args, alloc);
    try io.getStdOut().write("\n");
}
