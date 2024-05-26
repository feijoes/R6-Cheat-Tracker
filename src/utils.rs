use nanoid::nanoid;
use include_dir::{include_dir, Dir};

static UPLOAD_DIR: Dir<'_> = include_dir!("$CARGO_MANIFEST_DIR/uploads");


fn validate_video_not_exists(filename: &String) -> bool {
    match UPLOAD_DIR.get_file(filename) {
        None => true,
        Some(_) => false,
    }
}

pub fn generate_video_name() -> String {
    let mut video_name: String;
    loop {
        video_name = nanoid!() + ".mp4";
        if validate_video_not_exists(&video_name) {
            break;
        }
    }
    video_name
}