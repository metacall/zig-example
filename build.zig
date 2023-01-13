const std = @import("std");

// You may need to edit any or all of these variables if a newer version than
// 0.6.2 gets released.
const metacall_root = "metacall-tarball-linux-amd64/gnu";
const metacall = "szllrsimcnm8r1iiampsikhnnpk3c4zd-metacall-0.6.2";
const profile = "y1qviprznny30lmnkgyinh0a3bsf5r40-profile";
const c_ares = "bxjq838xajdg3c5rhqzrq8qjkaimshw4-c-ares-1.18.1";
const icu4c = "b0xl3iqgc7fs68f2kfdyydsdxs77jqph-icu4c-71.1";
const python = "65i3nhcwmz0p8rqbg48gaavyky4g4hwk-python-3.9.9";

const metacall_store = metacall_root ++ "/store";

pub fn build(b: *std.build.Builder) void {
    var target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("test", "src/main.zig");

    exe.addIncludePath(
        metacall_store ++ "/" ++ metacall ++ "/include",
    );
    exe.addLibraryPath(metacall_root ++ "/lib");
    exe.addRPath(metacall_root ++ "/lib");
    exe.linkSystemLibrary("metacall");
    exe.linkLibC();

    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.setEnvironmentVariable(
        "LD_LIBRARY_PATH",
        metacall_root ++ "/lib" ++ ":" ++
            metacall_store ++ "/" ++ c_ares ++ "/lib" ++ ":" ++
            metacall_store ++ "/" ++ icu4c ++ "/lib",
    );
    run_cmd.setEnvironmentVariable(
        "CONFIGURATION_PATH",
        metacall_store ++ "/" ++ profile ++ "/configurations/global.json",
    );

    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
