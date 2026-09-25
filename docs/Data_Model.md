# Data Model

## Overview

This project uses a relational database model designed to support the analysis of user engagement, journaling behavior, reminder effectiveness, and subscription patterns within PenFlow.

The data model consists of four tables:

1. Users
2. Journal_Entries
3. Reminders
4. Subscriptions

The relationships between these tables enable efficient querying while minimizing data redundancy through normalization.

---

## Table: Users

### Description

Stores demographic and account-related information for each user.

| Column | Data Type | Key | Description |
|---------|-----------|-----|-------------|
| user_id | INT | Primary Key | Unique identifier for each user |
| signup_date | DATE | - | Date the user created an account |
| age_group | VARCHAR | - | User age category (18–24, 25–34, etc.) |
| country | VARCHAR | - | User's country |
| gender | VARCHAR | - | User gender |
| acquisition_channel | VARCHAR | - | Source through which the user joined (Organic, Social Media, Referral, etc.) |
| subscription_status | VARCHAR | - | Current subscription plan (Free/Premium) |
---

## Table: Journal_Entries

### Description

Stores every journaling activity performed by users.

| Column | Data Type | Key | Description |
|---------|-----------|-----|-------------|
| entry_id | INT | Primary Key | Unique journal entry ID |
| user_id | INT | Foreign Key | References Users.user_id |
| entry_date | DATE | - | Date of journal entry |
| word_count | INT | - | Number of words written |
| mood_before | INT | - | Mood rating before writing (1–5) |
| mood_after | INT | - | Mood rating after writing (1–5) |
| used_prompt | BOOLEAN | - | Whether a guided prompt was used |
| writing_duration_minutes | INT | - | Time spent writing |

---

## Table: Reminders

### Description

Tracks reminder notifications sent to users and their interactions.

| Column | Data Type | Key | Description |
|---------|-----------|-----|-------------|
| reminder_id | INT | Primary Key | Unique reminder ID |
| user_id | INT | Foreign Key | References Users.user_id |
| reminder_date | DATE | - | Date reminder was sent |
| opened | BOOLEAN | - | Whether the reminder was opened |
| clicked | BOOLEAN | - | Whether the reminder was clicked |
| journaled_after | BOOLEAN | - | Whether the user journaled after receiving the reminder |

---

## Table: Subscriptions

### Description

Stores subscription history for each user.

| Column | Data Type | Key | Description |
|---------|-----------|-----|-------------|
| subscription_id | INT | Primary Key | Unique subscription record |
| user_id | INT | Foreign Key | References Users.user_id |
| plan_type | VARCHAR | - | Free or Premium |
| start_date | DATE | - | Subscription start date |
| end_date | DATE | - | Subscription end date |
| status | VARCHAR | - | Active, Expired, or Cancelled |

---

# Relationships

- One User can create many Journal Entries.
- One User can receive many Reminders.
- One User can have multiple Subscription records over time.

The `user_id` column acts as the Foreign Key linking all activity tables to the Users table.

---

# Design Rationale

The database follows normalization principles by separating user information, journaling activity, reminders, and subscription history into independent tables.

This design:

- Reduces redundant data storage.
- Supports one-to-many relationships.
- Simplifies SQL queries.
- Enables scalable analytics.
- Mirrors real-world relational database design used in analytics projects.