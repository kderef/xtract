use macroquad::prelude::*;

use crate::display_rect;

#[derive(Clone, Copy, Debug)]
pub enum Tile {
    Empty,
    Debug,
    Belt { direction: i32 },
}

impl Tile {
    pub const SIZE: f32 = 64.0;

    fn draw(&self, pos: Vec2) {
        match self {
            Self::Empty => {}
            Self::Debug => {
                draw_rectangle(
                    pos.x,
                    pos.y,
                    Self::SIZE,
                    Self::SIZE,
                    PURPLE, // test
                );
            }
            _ => {}
        }
    }
}

pub struct Grid {
    /// (x, y, tile)
    tiles: Vec<(i32, i32, Tile)>,
}

impl Grid {
    pub const CENTER: Vec2 = vec2(0.0, 0.0);

    pub fn new() -> Self {
        Self {
            tiles: vec![
                // test
                (-3, 1, Tile::Debug),
            ],
        }
    }

    fn get(&self, x: i32, y: i32) -> Option<&Tile> {
        self.tiles
            .iter()
            .find(|(x_, y_, _)| (*x_, *y_) == (x, y))
            .map(|(_, _, t)| t)
    }

    pub fn draw(&self, camera: &Camera2D) {
        // Convert screen corners to world space
        let display = display_rect();
        let cam_top_left = vec2(0.0, 0.0);
        let cam_bottom_right = vec2(display.right(), display.bottom());

        let top_left = camera.screen_to_world(cam_top_left);
        let bottom_right = camera.screen_to_world(cam_bottom_right);

        // Compute which cell indices are visible
        let start_x = (top_left.x / Tile::SIZE).floor() as i32;
        let start_y = (top_left.y / Tile::SIZE).floor() as i32;
        let end_x = (bottom_right.x / Tile::SIZE).ceil() as i32;
        let end_y = (bottom_right.y / Tile::SIZE).ceil() as i32;

        // Draw each visible cell
        for gx in start_x..end_x {
            for gy in start_y..end_y {
                let world_x = gx as f32 * Tile::SIZE;
                let world_y = gy as f32 * Tile::SIZE;

                draw_rectangle_lines(
                    world_x,
                    world_y,
                    Tile::SIZE, //
                    Tile::SIZE,
                    1.0,
                    GRAY,
                );

                if let Some(tile) = self.get(gx, gy) {
                    tile.draw(vec2(world_x, world_y));
                }
            }
        }
    }
}
