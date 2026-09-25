-- =====================================
-- PENFLOW DATABASE SCHEMA
-- =====================================

DROP TABLE IF EXISTS Journal_Entries;
DROP TABLE IF EXISTS Reminders;
DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS Users;

-- =====================================
-- USERS
-- =====================================

CREATE TABLE Users (

    user_id INTEGER PRIMARY KEY,

    signup_date DATE NOT NULL,

    age_group VARCHAR(20) NOT NULL,

    country VARCHAR(50) NOT NULL,

    gender VARCHAR(20) NOT NULL,

    acquisition_channel VARCHAR(30) NOT NULL

);

-- =====================================
-- JOURNAL ENTRIES
-- =====================================

CREATE TABLE Journal_Entries (

    entry_id INTEGER PRIMARY KEY,

    user_id INTEGER NOT NULL,

    entry_date DATE NOT NULL,

    entry_time VARCHAR(20),

    word_count INTEGER NOT NULL,

    mood_before INTEGER CHECK (mood_before BETWEEN 1 AND 5),

    mood_after INTEGER CHECK (mood_after BETWEEN 1 AND 5),

    writing_duration_minutes INTEGER,

    used_prompt BOOLEAN,

    device_type VARCHAR(20),

    streak_at_entry INTEGER,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)

);

-- =====================================
-- REMINDERS
-- =====================================

CREATE TABLE Reminders (

    reminder_id INTEGER PRIMARY KEY,

    user_id INTEGER NOT NULL,

    reminder_date DATE NOT NULL,

    reminder_type VARCHAR(30),

    opened BOOLEAN,

    clicked BOOLEAN,

    journaled_after BOOLEAN,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)

);

-- =====================================
-- SUBSCRIPTIONS
-- =====================================

CREATE TABLE Subscriptions (

    subscription_id INTEGER PRIMARY KEY,

    user_id INTEGER NOT NULL,

    plan_type VARCHAR(30),

    start_date DATE,

    end_date DATE,

    status VARCHAR(30),

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)

);