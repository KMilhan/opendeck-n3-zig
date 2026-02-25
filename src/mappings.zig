const std = @import("std");

pub const DEVICE_NAMESPACE: []const u8 = "n3";

pub const ROW_COUNT: usize = 3;
pub const COL_COUNT: usize = 3;
pub const KEY_COUNT: usize = 9;
pub const ENCODER_COUNT: usize = 3;

pub const AJAZZ_VID: u16 = 0x0300;
pub const MIRABOX_VID: u16 = 0x6603;
pub const N3_VID: u16 = 0x6602;
pub const SOOMFON_VID: u16 = 0x1500;
pub const MARS_GAMING_VID: u16 = 0x0B00;
pub const TREASLIN_VID: u16 = 0x5548;
pub const REDRAGON_VID: u16 = 0x0200;

pub const AKP03_PID: u16 = 0x1001;
pub const AKP03E_PID: u16 = 0x1002;
pub const AKP03R_PID: u16 = 0x1003;
pub const AKP03E_REV2_PID: u16 = 0x3002;
pub const N3_PID: u16 = 0x1002;
pub const N3EN_PID: u16 = 0x1003;
pub const SOOMFON_SE_PID: u16 = 0x3001;
pub const MSD_TWO_PID: u16 = 0x1001;
pub const TREASLIN_N3_PID: u16 = 0x1001;
pub const REDRAGON_SS551_PID: u16 = 0x2000;

pub const DeviceQuery = struct {
    usage_page: u16,
    usage_id: u16,
    vendor_id: u16,
    product_id: u16,
};

pub const AKP03_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = AJAZZ_VID, .product_id = AKP03_PID };
pub const AKP03E_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = AJAZZ_VID, .product_id = AKP03E_PID };
pub const AKP03R_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = AJAZZ_VID, .product_id = AKP03R_PID };
pub const AKP03E_REV2_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = AJAZZ_VID, .product_id = AKP03E_REV2_PID };
pub const N3_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = N3_VID, .product_id = N3_PID };
pub const MIRABOX_N3_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = MIRABOX_VID, .product_id = N3_PID };
pub const N3EN_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = MIRABOX_VID, .product_id = N3EN_PID };
pub const SOOMFON_SE_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = SOOMFON_VID, .product_id = SOOMFON_SE_PID };
pub const MSD_TWO_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = MARS_GAMING_VID, .product_id = MSD_TWO_PID };
pub const TREASLIN_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = TREASLIN_VID, .product_id = TREASLIN_N3_PID };
pub const REDRAGON_SS551_QUERY = DeviceQuery{ .usage_page = 65440, .usage_id = 1, .vendor_id = REDRAGON_VID, .product_id = REDRAGON_SS551_PID };

pub const QUERIES = [_]DeviceQuery{
    AKP03_QUERY,
    AKP03E_QUERY,
    AKP03R_QUERY,
    AKP03E_REV2_QUERY,
    N3_QUERY,
    MIRABOX_N3_QUERY,
    N3EN_QUERY,
    SOOMFON_SE_QUERY,
    MSD_TWO_QUERY,
    TREASLIN_QUERY,
    REDRAGON_SS551_QUERY,
};

pub const ImageRotation = enum {
    Rot0,
    Rot90,
    Rot180,
    Rot270,
};

pub const ImageMirroring = enum {
    None,
    X,
    Y,
    Both,
};

pub const ImageMode = enum {
    None,
    BMP,
    JPEG,
};

pub const ImageFormat = struct {
    mode: ImageMode,
    size: struct { w: usize, h: usize },
    rotation: ImageRotation,
    mirror: ImageMirroring,
};

pub const Kind = enum {
    Akp03,
    Akp03E,
    Akp03R,
    Akp03Erev2,
    N3,
    MiraboxN3,
    N3EN,
    SoomfonSE,
    MSDTWO,
    TreasLinN3,
    RedragonSS551,
};

pub fn kind_from_vid_pid(vid: u16, pid: u16) ?Kind {
    switch (vid) {
        AJAZZ_VID => return switch (pid) {
            AKP03_PID => .Akp03,
            AKP03E_PID => .Akp03E,
            AKP03R_PID => .Akp03R,
            AKP03E_REV2_PID => .Akp03Erev2,
            else => null,
        },
        N3_VID => return switch (pid) {
            N3_PID => .N3,
            else => null,
        },
        SOOMFON_VID => return switch (pid) {
            SOOMFON_SE_PID => .SoomfonSE,
            else => null,
        },
        MIRABOX_VID => return switch (pid) {
            N3_PID => .MiraboxN3,
            N3EN_PID => .N3EN,
            else => null,
        },
        MARS_GAMING_VID => return switch (pid) {
            MSD_TWO_PID => .MSDTWO,
            else => null,
        },
        TREASLIN_VID => return switch (pid) {
            TREASLIN_N3_PID => .TreasLinN3,
            else => null,
        },
        REDRAGON_VID => return switch (pid) {
            REDRAGON_SS551_PID => .RedragonSS551,
            else => null,
        },
        else => return null,
    }
}

pub fn kind_human_name(kind: Kind) []const u8 {
    return switch (kind) {
        .Akp03 => "Ajazz AKP03",
        .Akp03E => "Ajazz AKP03E",
        .Akp03R => "Ajazz AKP03R",
        .Akp03Erev2 => "Ajazz AKP03E (rev. 2)",
        .N3 => "Mirabox N3 (0x6602)",
        .MiraboxN3 => "Mirabox N3 (0x6603)",
        .N3EN => "Mirabox N3EN",
        .SoomfonSE => "Soomfon Stream Controller SE",
        .MSDTWO => "Mars Gaming MSD-TWO",
        .TreasLinN3 => "TreasLin N3",
        .RedragonSS551 => "Redragon Skyrider SS-551",
    };
}

pub fn kind_protocol_version(kind: Kind) usize {
    return switch (kind) {
        .N3EN, .MiraboxN3, .Akp03Erev2, .SoomfonSE, .TreasLinN3, .RedragonSS551 => 3,
        else => 2,
    };
}

pub fn kind_image_format(kind: Kind) ImageFormat {
    const proto = kind_protocol_version(kind);
    if (proto == 3) {
        return .{ .mode = .JPEG, .size = .{ .w = 60, .h = 60 }, .rotation = .Rot90, .mirror = .None };
    }
    if (kind == .MiraboxN3) {
        return .{ .mode = .JPEG, .size = .{ .w = 60, .h = 60 }, .rotation = .Rot90, .mirror = .None };
    }
    return .{ .mode = .JPEG, .size = .{ .w = 60, .h = 60 }, .rotation = .Rot0, .mirror = .None };
}

pub const CandidateDevice = struct {
    id: []const u8,
    dev: HidDeviceInfo,
    kind: Kind,
};

pub const HidDeviceInfo = struct {
    vendor_id: u16,
    product_id: u16,
    usage_page: u16 = 0,
    usage_id: u16 = 0,
    serial_number: ?[]const u8 = null,
    path: ?[]const u8 = null,

    pub fn clone(self: HidDeviceInfo, allocator: std.mem.Allocator) !HidDeviceInfo {
        const serial_copy = if (self.serial_number) |serial|
            try allocator.dupe(u8, serial)
        else
            null;
        const path_copy = if (self.path) |path|
            try allocator.dupe(u8, path)
        else
            null;

        return .{
            .vendor_id = self.vendor_id,
            .product_id = self.product_id,
            .usage_page = self.usage_page,
            .usage_id = self.usage_id,
            .serial_number = serial_copy,
            .path = path_copy,
        };
    }

    pub fn deinit(self: HidDeviceInfo, allocator: std.mem.Allocator) void {
        if (self.serial_number) |serial| allocator.free(serial);
        if (self.path) |path| allocator.free(path);
    }
};
