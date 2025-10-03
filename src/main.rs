mod grid;

use macroquad::prelude::*;

use crate::grid::Grid;

#[inline]
fn display_rect() -> Rect {
    let dpi = screen_dpi_scale();
    Rect {
        x: 0.0,
        y: 0.0,
        w: screen_width() * dpi,
        h: screen_height() * dpi,
    }
}

fn app() -> Conf {
    Conf {
        window_title: "xtract".into(),
        window_resizable: true,
        high_dpi: true,

        sample_count: 2,

        ..Default::default()
    }
}

fn draw_grid() {
    let spacing = 20.0;

    for y in 0..50 {
        for x in 0..50 {
            draw_rectangle_lines(
                x as f32 * spacing,
                y as f32 * spacing,
                spacing,
                spacing, //
                2.0,
                GRAY,
            );
        }
    }
}

fn camera_move(cam: &mut Camera2D) {
    let dt = get_frame_time();
    let move_speed = 100. * dt;

    let prev_target = cam.target;

    // set viewport
    let display_rect = display_rect();
    *cam = Camera2D::from_display_rect(display_rect);

    cam.target = prev_target;
    cam.zoom.y *= -1.;
    cam.zoom *= 4.;

    let pos = &mut cam.target;

    if is_key_down(KeyCode::Up) {
        pos.y -= move_speed;
    }
    if is_key_down(KeyCode::Down) {
        pos.y += move_speed;
    }
    if is_key_down(KeyCode::Left) {
        pos.x -= move_speed;
    }
    if is_key_down(KeyCode::Right) {
        pos.x += move_speed;
    }

    if is_key_down(KeyCode::Equal) {
        cam.zoom += 0.1 * dt;
    }
    if is_key_down(KeyCode::Minus) {
        cam.zoom -= 0.1 * dt;
    }
}

#[macroquad::main(app)]
async fn main() {
    let mut camera = Camera2D {
        target: vec2(100., 100.),
        zoom: vec2(0.00, 0.00),

        ..Default::default()
    };

    let mut grid = Grid::new();

    let mut use_camera = false;

    loop {
        if is_key_pressed(KeyCode::C) {
            use_camera ^= true;
        }

        camera_move(&mut camera);

        if use_camera {
            set_camera(&camera);
        }

        grid.draw(&camera);
        draw_text("hello world", 100.0, 100.0, 20.0, RED);

        set_default_camera();
        draw_fps();

        next_frame().await;
    }
}
