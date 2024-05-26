#!/bin/bash

# Start Docker Compose services
dev() {
    docker compose up -d
}

compose(){
    docker compose down
    docker compose build
    docker compose up -d
}

# Stop Docker Compose services
restart_db() {
    docker compose down
    docker volume rm r6_cheat_tracker_r6_cheat_tracker_db
    docker compose up -d
    sqlx migrate run
}

# Run database migrations up
migrate-up() {
    sqlx migrate run
}

# Revert database migrations
migrate-down() {
    sqlx migrate revert
}

# Start the server using cargo watch
runserver() {
    cargo watch -q -c -w src/ -x run
}

# Install required Rust dependencies
install() {
    cargo add axum
    cargo add axum-extra -F cookie
    cargo add time
    cargo add tokio -F full
    cargo add tower-http -F "cors"
    cargo add serde_json
    cargo add serde -F derive
    cargo add chrono -F serde
    cargo add dotenv
    cargo add uuid -F "serde v4"
    cargo add sqlx -F "runtime-async-std-native-tls postgres chrono uuid"
    cargo add jsonwebtoken
    cargo add argon2
    cargo add rand_core --features "std"
    # Install cargo-watch for hot reloading
    cargo install cargo-watch
    # Install SQLx CLI
    cargo install sqlx-cli
}

# Execute the specified function based on the argument provided
if [ "$1" ]; then
    "$@"
else
    echo "Usage: ./commands.sh {dev|restart_db|migrate-up|migrate-down|runserver|install}"
fi
