// disable console window on windows
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

pub type Key = KeyboardKey;
pub type Vec2 = Vector2;
pub type Vec3 = Vector3;
pub type Rect = Rectangle;

use raylib::prelude::*;

#[inline]
const fn vec2(x: f32, y: f32) -> Vector2 {
    Vector2 { x, y }
}

pub struct Viewport {
    pub camera: Camera2D,
}

impl Viewport {
    pub fn new() -> Self {
        Self {
            camera: Camera2D {
                zoom: 1.0,
                rotation: 0.0,
                offset: Vector2::zero(),
                target: vec2(100., 100.),
            },
        }
    }

    pub fn debug_info(&self, dr: &mut impl RaylibDraw) {
        dr.draw_fps(0, 0);

        let camera_text = format!("{:#?}", self.camera);
        dr.draw_text(&camera_text, 0, 30, 20, Color::CYAN);
    }

    pub fn update(&mut self, rl: &mut RaylibHandle) {
        let dt = rl.get_frame_time();
        let move_speed = 10. * dt;

        let mut movement = vec2(0., 0.);

        if rl.is_key_down(Key::KEY_LEFT) {
            movement.x = -move_speed;
        }
        if rl.is_key_down(Key::KEY_RIGHT) {
            movement.x = move_speed;
        }
        if rl.is_key_down(Key::KEY_UP) {
            movement.y = -move_speed;
        }
        if rl.is_key_down(Key::KEY_DOWN) {
            movement.y = move_speed;
        }

        if rl.is_key_down(Key::KEY_EQUAL) {
            self.camera.zoom += dt;
        }
        if rl.is_key_down(Key::KEY_MINUS) {
            self.camera.zoom -= dt;
        }

        self.camera.target += movement;
    }
}

fn main() {
    let (mut rl, thread) = raylib::init()
        .title("xtract")
        .width(800)
        .height(600)
        .resizable()
        .msaa_4x()
        .build();

    rl.set_target_fps(120);

    let mut running = true;

    let mut viewport = Viewport::new();

    while running {
        running ^= rl.window_should_close();

        viewport.update(&mut rl);

        let mut dr = rl.begin_drawing(&thread);

        dr.clear_background(Color::BLACK);

        {
            let mut world = dr.begin_mode2D(viewport.camera);
            world.draw_rectangle(10, 20, 100, 30, Color::GRAY);
        }

        viewport.debug_info(&mut dr);
    }
}
