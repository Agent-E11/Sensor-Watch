const std = @import("std");
const testing = std.testing;

const allocator = std.heap.page_allocator;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

const movement = @cImport({
    @cDefine("__SAML22J18A__", "1");
    @cInclude("movement.h");
});

const zig_face = @cImport({
    @cDefine("__SAML22J18A__", "1");
    @cInclude("zig_face.h");
    @cInclude("watch.h");
});

export fn zig_face_setup(settings: movement.movement_settings_t, watch_face_index: u8, context_ptr: ?*?*anyopaque) void {
    _ = settings;
    _ = watch_face_index;
    if (context_ptr.* == null) {
        //*context_ptr = malloc(sizeof(zig_state_t));
        context_ptr.* = allocator.create(zig_face.zig_state_t);
        //memset(*context_ptr, 0, sizeof(zig_state_t));
        context_ptr.*.* = std.mem.zeroes(zig_face.zig_state_t);
        // Do any one-time tasks in here; the inside of this conditional happens only at boot.
    }
    // Do any pin or peripheral setup here; this will be called whenever the watch wakes from deep sleep.
}

export fn zig_face_activate(settings: movement.movement_settings_t, context: *anyopaque) void {
    _ = settings;
    const state: zig_face.zig_state_t = @ptrCast(@alignCast(context));
    _ = state;

    // Handle any tasks related to your watch face coming on screen.
}

export fn zig_face_loop(event: movement.movement_event_t, settings: *movement.movement_settings_t, context: *anyopaque) bool {
    const state: zig_face.zig_state_t = @ptrCast(@alignCast(context));
    _ = state;

    switch (event.event_type) {
        movement.EVENT_ACTIVATE => {
            // Show your initial UI here.
        },
        movement.EVENT_TICK => {
            // If needed, update your display here.
        },
        movement.EVENT_LIGHT_BUTTON_UP => {
            // You can use the Light button for your own purposes. Note that by default, Movement will also
            // illuminate the LED in response to EVENT_LIGHT_BUTTON_DOWN; to suppress that behavior, add an
            // empty case for EVENT_LIGHT_BUTTON_DOWN.
        },
        movement.EVENT_ALARM_BUTTON_UP => {
            // Just in case you have need for another button.
        },
        movement.EVENT_TIMEOUT => {
            // Your watch face will receive this event after a period of inactivity. If it makes sense to resign,
            // you may uncomment this line to move back to the first watch face in the list:
            // movement_move_to_face(0);
        },
        movement.EVENT_LOW_ENERGY_UPDATE => {
            // If you did not resign in EVENT_TIMEOUT, you can use this event to update the display once a minute.
            // Avoid displaying fast-updating values like seconds, since the display won't update again for 60 seconds.
            // You should also consider starting the tick animation, to show the wearer that this is sleep mode:
            // watch_start_tick_animation(500);
        },
        else => {
            // Movement's default loop handler will step in for any cases you don't handle above:
            // * EVENT_LIGHT_BUTTON_DOWN lights the LED
            // * EVENT_MODE_BUTTON_UP moves to the next watch face in the list
            // * EVENT_MODE_LONG_PRESS returns to the first watch face (or skips to the secondary watch face, if configured)
            // You can override any of these behaviors by adding a case for these events to this switch statement.
            return movement.movement_default_loop_handler(event, settings);
        },
    }

    // return true if the watch can enter standby mode. Generally speaking, you should always return true.
    // Exceptions:
    //  * If you are displaying a color using the low-level watch_set_led_color function, you should return false.
    //  * If you are sounding the buzzer using the low-level watch_set_buzzer_on function, you should return false.
    // Note that if you are driving the LED or buzzer using Movement functions like movement_illuminate_led or
    // movement_play_alarm, you can still return true. This guidance only applies to the low-level watch_ functions.
    return true;
}

export fn zig_face_resign(settings: movement.movement_settings_t, context: *anyopaque) void {
    _ = settings;
    _ = context;

    // handle any cleanup before your watch face goes off-screen.
}
