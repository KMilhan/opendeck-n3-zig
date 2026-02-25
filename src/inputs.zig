const std = @import("std");
const mappings = @import("mappings.zig");
const mirajazz = @import("mirajazz");

pub const InputError = error{ BadData } || std.mem.Allocator.Error;

pub const KeyStates = [mappings.KEY_COUNT]bool;
pub const EncoderStates = [mappings.ENCODER_COUNT]bool;
pub const EncoderTwists = [mappings.ENCODER_COUNT]i8;

pub const DeviceInput = mirajazz.types.DeviceInput;

pub fn process_input(allocator: std.mem.Allocator, input: u8, state: u8) InputError!DeviceInput {
    return switch (input) {
        0...9, 0x25, 0x30, 0x31 => read_button_press(allocator, input, state),
        0x90, 0x91, 0x50, 0x51, 0x60, 0x61 => read_encoder_value(allocator, input),
        0x33...0x35 => read_encoder_press(allocator, input, state),
        else => DeviceInput.NoData,
    };
}

fn read_button_states(states: []const u8) KeyStates {
    var out: KeyStates = undefined;
    var i: usize = 0;
    while (i < mappings.KEY_COUNT) : (i += 1) {
        out[i] = states[i + 1] != 0;
    }
    return out;
}

fn read_button_press(allocator: std.mem.Allocator, input: u8, state: u8) InputError!DeviceInput {
    var button_states: [mappings.KEY_COUNT + 2]u8 = undefined;
    button_states[0] = 0x01;
    var i: usize = 1;
    while (i < button_states.len) : (i += 1) {
        button_states[i] = 0;
    }

    if (input == 0) {
        return alloc_button_states(allocator, read_button_states(&button_states));
    }

    const pressed_index: usize = switch (input) {
        1...9 => @as(usize, input),
        0x25 => 7,
        0x30 => 8,
        0x31 => 9,
        else => return InputError.BadData,
    };

    button_states[pressed_index] = state;
    return alloc_button_states(allocator, read_button_states(&button_states));
}

fn read_encoder_value(allocator: std.mem.Allocator, input: u8) InputError!DeviceInput {
    var encoder_values: EncoderTwists = .{ 0, 0, 0 };

    const encoder: usize = switch (input) {
        0x90, 0x91 => 0,
        0x50, 0x51 => 1,
        0x60, 0x61 => 2,
        else => return InputError.BadData,
    };

    const value: i8 = switch (input) {
        0x90, 0x50, 0x60 => -1,
        0x91, 0x51, 0x61 => 1,
        else => return InputError.BadData,
    };

    encoder_values[encoder] = value;
    const out = try allocator.alloc(i8, encoder_values.len);
    @memcpy(out, &encoder_values);
    return DeviceInput{ .EncoderTwist = out };
}

fn read_encoder_press(allocator: std.mem.Allocator, input: u8, state: u8) InputError!DeviceInput {
    var encoder_states: EncoderStates = .{ false, false, false };

    const encoder: usize = switch (input) {
        0x33 => 0,
        0x35 => 1,
        0x34 => 2,
        else => return InputError.BadData,
    };

    encoder_states[encoder] = state != 0;
    const out = try allocator.alloc(bool, encoder_states.len);
    @memcpy(out, &encoder_states);
    return DeviceInput{ .EncoderStateChange = out };
}

fn alloc_button_states(allocator: std.mem.Allocator, states: KeyStates) InputError!DeviceInput {
    const out = try allocator.alloc(bool, states.len);
    @memcpy(out, &states);
    return DeviceInput{ .ButtonStateChange = out };
}
