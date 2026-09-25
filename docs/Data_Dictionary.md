# Data Dictionary

## Overview

This document defines every field used in the PenFlow synthetic dataset. It specifies the purpose, data type, allowed values, example values, and business rules for each column. The data dictionary serves as a reference for data generation, SQL analysis, and dashboard development.

---

# Table: Users

### Description
Stores demographic and account-related information for each PenFlow user.

| Column | Data Type | Description | Allowed Values / Format | Example | Business Rule |
|---------|-----------|-------------|-------------------------|---------|---------------|
| user_id | Integer | Unique identifier for each user | Positive Integer | 1001 | Must be unique |
| signup_date | Date | Date the user registered | YYYY-MM-DD | 2025-03-14 | Between 2025-01-01 and 2025-12-31 |
| age_group | Text | User age category | 18–24, 25–34, 35–44, 45+ | 25–34 | Selected randomly using realistic age distribution |
| country | Text | User's country | India, USA, UK, Canada, Australia | India | Selected from predefined countries |
| gender | Text | User gender | Male, Female, Non-binary, Prefer not to say | Female | Randomly assigned |
| acquisition_channel | Text | How the user discovered PenFlow | Organic Search, Social Media, Referral, Paid Ads | Organic Search | Determines user acquisition source |

---

# Table: Journal_Entries

### Description
Stores every journal entry created by users.

| Column | Data Type | Description | Allowed Values / Format | Example | Business Rule |
|---------|-----------|-------------|-------------------------|---------|---------------|
| entry_id | Integer | Unique journal entry ID | Positive Integer | 50125 | Must be unique |
| user_id | Integer | User who created the journal entry | Existing user_id | 1001 | Foreign Key referencing Users |
| entry_date | Date | Date of journal entry | YYYY-MM-DD | 2025-04-10 | Cannot occur before signup_date |
| entry_time | Text | Time of day when entry was written | Morning, Afternoon, Evening, Night | Evening | Simulated based on user behavior |
| word_count | Integer | Number of words written | 20–1500 | 342 | Longer entries are more common among engaged users |
| mood_before | Integer | Mood before journaling | 1–5 | 2 | 1 = Very Low, 5 = Very High |
| mood_after | Integer | Mood after journaling | 1–5 | 4 | Usually equal to or slightly higher than mood_before |
| writing_duration_minutes | Integer | Time spent writing | 2–60 | 15 | Positively related to word_count |
| used_prompt | Boolean | Whether a writing prompt was used | TRUE/FALSE | TRUE | More common among newer users |
| device_type | Text | Device used for journaling | Android, iOS, Web | Android | Randomly assigned |
| streak_at_entry | Integer | User's journaling streak on that day | 1+ | 12 | Increases with consecutive journaling days |

---

# Table: Reminders

### Description
Stores reminder notifications sent to users and their interactions.

| Column | Data Type | Description | Allowed Values / Format | Example | Business Rule |
|---------|-----------|-------------|-------------------------|---------|---------------|
| reminder_id | Integer | Unique reminder ID | Positive Integer | 7001 | Must be unique |
| user_id | Integer | User receiving reminder | Existing user_id | 1001 | Foreign Key referencing Users |
| reminder_date | Date | Date reminder was sent | YYYY-MM-DD | 2025-04-09 | Before or on journal date |
| reminder_type | Text | Type of reminder | Morning, Evening, Streak, Motivation | Streak | Chosen randomly |
| opened | Boolean | Whether reminder was opened | TRUE/FALSE | TRUE | More likely for engaged users |
| clicked | Boolean | Whether reminder was clicked | TRUE/FALSE | TRUE | Can only be TRUE if opened = TRUE |
| journaled_after | Boolean | Whether the user journaled after the reminder | TRUE/FALSE | TRUE | More likely if reminder was clicked |

---

# Table: Subscriptions

### Description
Stores subscription history for each user.

| Column | Data Type | Description | Allowed Values / Format | Example | Business Rule |
|---------|-----------|-------------|-------------------------|---------|---------------|
| subscription_id | Integer | Unique subscription record | Positive Integer | 3001 | Must be unique |
| user_id | Integer | User associated with subscription | Existing user_id | 1001 | Foreign Key referencing Users |
| plan_type | Text | Subscription plan | Free, Premium | Premium | Most users start on Free |
| start_date | Date | Subscription start date | YYYY-MM-DD | 2025-05-01 | On or after signup_date |
| end_date | Date | Subscription end date | YYYY-MM-DD or NULL | NULL | NULL if subscription is active |
| status | Text | Current subscription status | Active, Expired, Cancelled | Active | Must match subscription timeline |