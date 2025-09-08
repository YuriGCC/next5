# Next11 Backend

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com) 
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The official backend repository for **Next11**, a SaaS platform that provides data-driven football (soccer) analysis for small to medium-sized clubs using computer vision and AI.

## 📖 About The Project

Next11 automates the process of tactical and performance analysis by processing video footage of matches. It tracks players and the ball to generate valuable statistics, heatmaps, and tactical insights, making advanced sports analytics accessible and affordable for teams at all levels.

### ✨ Core Features

* **Video Upload & Processing:** Asynchronously processes user-uploaded match videos.
* **AI-Powered Detection:** Utilizes a fine-tuned YOLOv8 model to detect and track players, referees, and the ball.
* **Performance Statistics:** Calculates key metrics for each player, such as distance covered, max speed, sprint count, and more.
* **Tactical Visualizations:** Generates heatmaps and average player positions.
* **RESTful API:** Provides endpoints for user management, video handling, and retrieving analysis data.

### 🛠️ Tech Stack

* **Backend:** Python 3.12+ with [FastAPI](https://fastapi.tiangolo.com/)
* **Database:** [PostgreSQL](https://www.postgresql.org/)
* **AI / Computer Vision:** [Ultralytics YOLOv8](https://ultralytics.com/), [OpenCV](https://opencv.org/)
* **ORM:** [SQLAlchemy](https://www.sqlalchemy.org/)
* **Testing:** [Pytest](https://pytest.org/), Pytest-Mock, HTTPX
* **Server:** [Uvicorn](https://www.uvicorn.org/)

---

## 🏛️ Database Schema

The following diagram illustrates the hybrid relational/JSONB database schema.

```mermaid
DerDiagram
    USERS {
        int id PK
        varchar email UK
        varchar hashed_password
        varchar full_name
        varchar role
        timestamp created_at
    }
    TEAMS {
        int id PK
        varchar name
        int created_by_user_id FK
        timestamp created_at
    }
    PLAYERS {
        int id PK
        varchar full_name
        int jersey_number
        varchar position
        int team_id FK
        timestamp created_at
    }
    MATCHES {
        int id PK
        varchar title
        date match_date
        int uploaded_by_user_id FK
        int home_team_id FK
        int away_team_id FK
        text original_video_path
        text processed_video_path
        analysis_status status
        timestamp upload_timestamp
        timestamp processing_completed_timestamp
    }
    MATCH_STATISTICS {
        int id PK
        int match_id FK
        int player_id FK
        int total_shots
        int shots_on_target
        int goals
        int successful_dribbles
        int total_passes
        int completed_passes
        int assists
        int interceptions
        real total_distance_meters
        real max_speed_kmh
        jsonb extra_stats
    }

    USERS ||--o{ TEAMS : "manages"
    USERS ||--|{ MATCHES : "uploads"
    TEAMS ||--|{ PLAYERS : "has"
    TEAMS }o--|| MATCHES : "is_home_team"
    TEAMS }o--|| MATCHES : "is_away_team"
    MATCHES ||--|{ MATCH_STATISTICS : "generates"
    PLAYERS ||--o{ MATCH_STATISTICS : "produces"
```

---

## 🚀 Getting Started

Follow these instructions to set up the project on your local development machine.

### Prerequisites

* Python 3.12+
* PostgreSQL Server
* Git

### Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/next11-backend.git](https://github.com/your-username/next11-backend.git)
    cd next11-backend
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    # For Windows
    python -m venv venv
    .\venv\Scripts\activate

    # For macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Install dependencies:**
    This project uses separate requirements files for production and development. For setting up a development environment, use `requirements-dev.txt`.
    ```bash
    pip install -r requirements-dev.txt
    ```

4.  **Set up environment variables:**
    Create a `.env` file in the project root by copying the example file.
    ```bash
    cp .env.example .env
    ```
    Now, edit the `.env` file with your specific configuration, especially your database URL.
    ```ini
    # .env
    DATABASE_URL="postgresql://user:password@localhost:5432/next11_db"
    SECRET_KEY="your_super_secret_key_for_jwt"
    ```

5.  **Set up the AI Model:**
    The trained YOLO model (`best.pt`) is not tracked by Git. Create a `models/` directory in the project root and place your `best.pt` file inside it.
    ```
    next11-backend/
    └── models/
        └── best.pt
    ```

6.  **Set up the database:**
    Make sure your PostgreSQL server is running. Then, execute the schema script to create all necessary tables and types.
    ```bash
    psql -U your_postgres_user -d your_database_name -f schema.sql
    ```

---

## ▶️ Usage

To run the FastAPI application locally with auto-reload enabled:

```bash
uvicorn main:app --reload
```

The API will be available at `http://127.0.0.1:8000`. You can access the auto-generated documentation at `http://127.0.0.1:8000/docs`.

## ✅ Running Tests

To run the full test suite, use `pytest` from the project root:

```bash
pytest
```

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.