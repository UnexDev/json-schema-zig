pub fn JSONValue(comptime T: type) type {
    return struct {
        value: T,
    };
}

pub const JSONString = JSONValue([]u8);
pub const JSONNumber = JSONValue(i64);
pub const JSONBoolean = JSONValue(bool);
pub const JSONNull = JSONValue(null);

pub fn JSONObject(comptime T: type) type {
    return JSONValue(T);
}

pub fn JSONArray(comptime T: type) type {
    return []JSONValue(T);
}

pub fn JsonField(comptime T: type) type {
    return struct { key: []u8, value: T };
}
