-- =================================================================
-- Next11 Project - Database Schema
-- Version: 1.0
-- Author: Yuri Gabriel Covalski Candido
-- =================================================================

-- This script will drop existing tables and types for a clean setup.
-- Be careful in production.
DROP TABLE IF EXISTS match_statistics CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS analysis_status;

-- =================================================================
-- ENUM Types
-- =================================================================

CREATE TYPE analysis_status AS ENUM (
    'PENDING',      -- Video uploaded, waiting in the queue to be processed.
    'PROCESSING',   -- The AI model is currently analyzing the video.
    'COMPLETED',    -- Processing finished successfully.
    'FAILED'        -- An error occurred during processing.
);

CREATE TYPE clip_status AS ENUM (
    'PENDING', -- Video uploaded, waiting in the queue to be cut.
    'PROCESSING', -- Video is being cut.
    'COMPLETED', -- Cut finished successfully.
    'FAILED' --  An error occurred during cutting.
);

-- =================================================================
-- Core Tables
-- =================================================================

-- Table for user authentication and information.
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(255) DEFAULT 'jogador'
    profile_image_url VARCHAR(512);

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Teams managed by users.
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,

    -- Foreign key to the user who created/manages the team.
    -- If a user is deleted, their teams are also deleted.
    created_by_user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Players belong to a team.
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    jersey_number INTEGER,
    position VARCHAR(50),

    team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- The central table for matches, which are uploaded by users for analysis.
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    match_date DATE,

    uploaded_by_user_id INTEGER NOT NULL REFERENCES users(id),

    -- Optional foreign keys to link the match to pre-registered teams.
    home_team_id INTEGER REFERENCES teams(id),
    away_team_id INTEGER REFERENCES teams(id),

    original_video_path TEXT NOT NULL,
    processed_video_path TEXT, -- Populated after processing is complete.

    -- The current status of the AI analysis job for this match.
    status analysis_status DEFAULT 'PENDING',

    upload_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processing_completed_timestamp TIMESTAMP WITH TIME ZONE
);

-- Statistics related to the match.
CREATE TABLE match_statistics (
    id SERIAL PRIMARY KEY,

    match_id INTEGER NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,

    -- == Relational Columns for Core, Frequently Queried Metrics ==
    -- Offensive Stats
    total_shots INTEGER DEFAULT 0,
    shots_on_target INTEGER DEFAULT 0,
    goals INTEGER DEFAULT 0,
    successful_dribbles INTEGER DEFAULT 0,

    -- Passing Stats
    total_passes INTEGER DEFAULT 0,
    completed_passes INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,

    -- Defensive Stats
    interceptions INTEGER DEFAULT 0,

    -- Physical Stats
    total_distance_meters REAL,
    max_speed_kmh REAL,

    -- == Non-Relational Column for Flexible Data ==
    extra_stats JSONB,

    UNIQUE (match_id, player_id)
);

-- Table to store information about video clips
CREATE TABLE video_clips (
    id SERIAL PRIMARY KEY,

    original_match_id INTEGER NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    clip_path TEXT,
    status clip_status DEFAULT 'PENDING',

    start_time_seconds REAL NOT NULL,
    end_time_seconds REAL NOT NULL,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
