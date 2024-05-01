mod config;
mod handler;
mod jwt_auth;
mod model;
mod response;
mod route;

use config::Config;
use std::sync::Arc;

use axum::http::{
    header::{ACCEPT, AUTHORIZATION, CONTENT_TYPE},
    HeaderValue, Method,
};
use dotenv::dotenv;
use route::create_router;
use tower_http::cors::CorsLayer;

use sqlx::{postgres::PgPoolOptions, Pool, Postgres};

pub struct AppState {
    db: Pool<Postgres>,
    env: Config,
}


const PORT: &str  = "0.0.0.0:3000";

#[tokio::main]
async fn main() {
    dotenv().ok();

    let config = Config::init();

    let pool = match PgPoolOptions::new()
        .max_connections(10)
        .connect(&config.database_url)
        .await
    {
        Ok(pool) => {
            println!("\n✅ Connection to the database is successful!\n");
            pool
        }
        Err(err) => {
            println!("\n🔥 Failed to connect to the database: {:?}\n", err);
            std::process::exit(1);
        }
    };

    let cors = CorsLayer::new()
        .allow_origin("http://localhost:3000".parse::<HeaderValue>().unwrap())
        .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
        .allow_credentials(true)
        .allow_headers([AUTHORIZATION, ACCEPT, CONTENT_TYPE]);

    let app = create_router(Arc::new(AppState {
        db: pool.clone(),
        env: config.clone(),
    }))
    .layer(cors);
    let listener = tokio::net::TcpListener::bind(PORT)
            .await
            .unwrap();

    println!("🚀 Server started successfully at https://{}", PORT);
    axum::serve(listener,app.into_make_service())
        .await
        .unwrap();
}