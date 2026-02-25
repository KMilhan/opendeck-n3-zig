pub const ACK_PREFIX = [_]u8{ 65, 67, 75 };

pub const INPUT_CODE_OFFSET: usize = 9;
pub const INPUT_STATE_OFFSET: usize = 10;

pub const PACKET_SIZE_V1: usize = 512;
pub const PACKET_SIZE_V2: usize = 1024;

pub const CRT_PREFIX = [_]u8{ 0x00, 0x43, 0x52, 0x54, 0x00, 0x00 };
pub const CMD_DIS = [_]u8{ 0x44, 0x49, 0x53 };
pub const CMD_LIG = [_]u8{ 0x4C, 0x49, 0x47 };
pub const CMD_BAT = [_]u8{ 0x42, 0x41, 0x54 };
pub const CMD_CLE = [_]u8{ 0x43, 0x4C, 0x45 };
pub const CMD_STP = [_]u8{ 0x53, 0x54, 0x50 };
pub const CMD_HAN = [_]u8{ 0x48, 0x41, 0x4E };
pub const CMD_CONNECT = [_]u8{ 0x43, 0x4F, 0x4E, 0x4E, 0x45, 0x43, 0x54 };
pub const CMD_MOD = [_]u8{ 0x4D, 0x4F, 0x44 };
