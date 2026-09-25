-------------------------------------------------------------
-- SECTION 1 : USER OVERVIEW
-------------------------------------------------------------

-- 1. Total Users
SELECT COUNT(*) AS total_users
FROM Users;

-- 2. Users by Country
SELECT country,
       COUNT(*) AS total_users
FROM Users
GROUP BY country
ORDER BY total_users DESC;

-- 3. Users by Gender
SELECT gender,
       COUNT(*) AS total_users
FROM Users
GROUP BY gender
ORDER BY total_users DESC;

-- 4. Users by Age Group
SELECT age_group,
       COUNT(*) AS total_users
FROM Users
GROUP BY age_group
ORDER BY total_users DESC;

-- 5. Acquisition Channels
SELECT acquisition_channel,
       COUNT(*) AS users
FROM Users
GROUP BY acquisition_channel
ORDER BY users DESC;

-------------------------------------------------------------
-- SECTION 2 : JOURNAL ENGAGEMENT
-------------------------------------------------------------

-- 6. Total Journal Entries
SELECT COUNT(*) AS total_entries
FROM Journal_Entries;

-- 7. Average Entries per User
SELECT
ROUND(
    COUNT(*) * 1.0 /
    (SELECT COUNT(*) FROM Users),2
) AS avg_entries_per_user
FROM Journal_Entries;

-- 8. Average Word Count
SELECT
ROUND(AVG(word_count),2) AS avg_word_count
FROM Journal_Entries;

-- 9. Average Writing Duration
SELECT
ROUND(AVG(writing_duration_minutes),2) AS avg_duration
FROM Journal_Entries;

-- 10. Top 10 Most Active Users
SELECT user_id,
       COUNT(*) AS total_entries
FROM Journal_Entries
GROUP BY user_id
ORDER BY total_entries DESC
LIMIT 10;

-------------------------------------------------------------
-- SECTION 3 : JOURNALING HABITS
-------------------------------------------------------------

-- 11. Device Usage
SELECT device_type,
       COUNT(*) AS entries
FROM Journal_Entries
GROUP BY device_type
ORDER BY entries DESC;

-- 12. Prompt Usage
SELECT used_prompt,
       COUNT(*) AS entries
FROM Journal_Entries
GROUP BY used_prompt;

-- 13. Average Streak
SELECT
ROUND(AVG(streak_at_entry),2) AS average_streak
FROM Journal_Entries;

-- 14. Maximum Streak Achieved
SELECT
MAX(streak_at_entry) AS highest_streak
FROM Journal_Entries;

-- 15. Users with Streak > 30 Days
SELECT
COUNT(DISTINCT user_id) AS users_above_30_day_streak
FROM Journal_Entries
WHERE streak_at_entry > 30;

-------------------------------------------------------------
-- SECTION 4 : MOOD ANALYSIS
-------------------------------------------------------------

-- 16. Average Mood Before Journaling
SELECT
ROUND(AVG(mood_before),2) AS avg_before
FROM Journal_Entries;

-- 17. Average Mood After Journaling
SELECT
ROUND(AVG(mood_after),2) AS avg_after
FROM Journal_Entries;

-- 18. Average Mood Improvement
SELECT
ROUND(AVG(mood_after - mood_before),2) AS mood_improvement
FROM Journal_Entries;

-------------------------------------------------------------
-- SECTION 5 : REMINDER EFFECTIVENESS
-------------------------------------------------------------

-- 19. Total Reminders Sent
SELECT COUNT(*) AS reminders_sent
FROM Reminders;

-- 20. Reminder Open Rate
SELECT
ROUND(AVG(opened)*100,2) AS open_rate_percent
FROM Reminders;

-- 21. Reminder Click Rate
SELECT
ROUND(AVG(clicked)*100,2) AS click_rate_percent
FROM Reminders;

-- 22. Journaling After Reminder
SELECT
ROUND(AVG(journaled_after)*100,2)
AS journaling_conversion_rate
FROM Reminders;

-- 23. Reminder Type Performance
SELECT reminder_type,
       ROUND(AVG(journaled_after)*100,2)
       AS conversion_rate
FROM Reminders
GROUP BY reminder_type
ORDER BY conversion_rate DESC;

-------------------------------------------------------------
-- SECTION 6 : SUBSCRIPTIONS
-------------------------------------------------------------

-- 24. Subscription Status
SELECT status,
       COUNT(*) AS users
FROM Subscriptions
GROUP BY status;

-- 25. Plan Distribution
SELECT plan_type,
       COUNT(*) AS users
FROM Subscriptions
GROUP BY plan_type;

-- 26. Premium Conversion Rate
SELECT
ROUND(
COUNT(*)*100.0/
(SELECT COUNT(*) FROM Users),2)
AS premium_conversion_rate
FROM Subscriptions
WHERE plan_type='Premium';

-------------------------------------------------------------
-- SECTION 7 : USER ENGAGEMENT VS SUBSCRIPTION
-------------------------------------------------------------

-- 27. Average Entries by Subscription Plan
SELECT
s.plan_type,
ROUND(AVG(user_entries.total_entries),2) AS avg_entries
FROM
(
SELECT user_id,
COUNT(*) AS total_entries
FROM Journal_Entries
GROUP BY user_id
) user_entries
JOIN Subscriptions s
ON user_entries.user_id=s.user_id
GROUP BY s.plan_type;

-------------------------------------------------------------
-- SECTION 8 : RETENTION INSIGHTS
-------------------------------------------------------------

-- 28. Top Countries by Average Streak
SELECT
u.country,
ROUND(AVG(j.streak_at_entry),2)
AS avg_streak
FROM Users u
JOIN Journal_Entries j
ON u.user_id=j.user_id
GROUP BY u.country
ORDER BY avg_streak DESC;

-- 29. Average Mood Improvement by Prompt Usage
SELECT
used_prompt,
ROUND(AVG(mood_after-mood_before),2)
AS mood_gain
FROM Journal_Entries
GROUP BY used_prompt;

-- 30. Top Acquisition Channels by Engagement
SELECT
u.acquisition_channel,
ROUND(AVG(user_entries.total_entries),2)
AS avg_entries
FROM
(
SELECT user_id,
COUNT(*) AS total_entries
FROM Journal_Entries
GROUP BY user_id
) user_entries
JOIN Users u
ON user_entries.user_id=u.user_id
GROUP BY u.acquisition_channel
ORDER BY avg_entries DESC;