import pandas as pd
import numpy as np
import random
from datetime import timedelta

random.seed(42)
np.random.seed(42)

# -----------------------
# Load Users
# -----------------------

users = pd.read_csv("data/raw/users.csv")
users["signup_date"] = pd.to_datetime(users["signup_date"])

END_DATE = pd.to_datetime("2026-06-30")

# -----------------------
# Journal Entries
# -----------------------

journal_entries = []
entry_id = 1

for _, user in users.iterrows():

    engagement = random.choices(
        ["Low", "Medium", "High"],
        weights=[0.40, 0.40, 0.20]
    )[0]

    if engagement == "Low":
        p = 0.15
    elif engagement == "Medium":
        p = 0.35
    else:
        p = 0.65

    streak = 0
    current = user.signup_date

    while current <= END_DATE:

        if random.random() < p:

            mood_before = np.random.choice(
                [1, 2, 3, 4, 5],
                p=[0.08, 0.22, 0.40, 0.22, 0.08]
            )

            if mood_before <= 2:
                improvement = np.random.choice([1, 2], p=[0.70, 0.30])
            elif mood_before == 3:
                improvement = np.random.choice([0, 1], p=[0.40, 0.60])
            else:
                improvement = np.random.choice([-1, 0, 1], p=[0.05, 0.65, 0.30])

            mood_after = max(1, min(5, mood_before + improvement))

            if engagement == "Low":
                words = int(np.random.normal(90, 30))
            elif engagement == "Medium":
                words = int(np.random.normal(300, 80))
            else:
                words = int(np.random.normal(700, 180))

            words = max(20, min(words, 1200))

            duration = max(
                2,
                int(words / np.random.uniform(22, 35))
            )

            journal_entries.append({
                "entry_id": entry_id,
                "user_id": user.user_id,
                "entry_date": current.date(),
                "entry_time": random.choices(
                    ["Morning", "Afternoon", "Evening", "Night"],
                    weights=[30, 20, 35, 15]
                )[0],
                "word_count": words,
                "mood_before": mood_before,
                "mood_after": mood_after,
                "writing_duration_minutes": duration,
                "used_prompt": random.random() < 0.30,
                "device_type": random.choices(
                    ["Android", "iOS", "Web"],
                    weights=[55, 30, 15]
                )[0],
                "streak_at_entry": streak + 1
            })

            streak += 1
            entry_id += 1

        else:
            streak = 0

        current += timedelta(days=1)

journal_df = pd.DataFrame(journal_entries)
journal_df.to_csv("data/raw/journal_entries.csv", index=False)
print("Journal Entries:", len(journal_df))

# -----------------------
# Reminders
# -----------------------

reminders = []
rid = 1

for _, user in users.iterrows():

    n = random.randint(8, 20)

    for _ in range(n):

        reminder_date = user.signup_date + timedelta(days=random.randint(0, 365))

        opened = random.random() < 0.62
        clicked = opened and (random.random() < 0.42)
        journaled = clicked and (random.random() < 0.65)

        reminders.append({
            "reminder_id": rid,
            "user_id": user.user_id,
            "reminder_date": reminder_date.date(),
            "reminder_type": random.choices(
                ["Morning", "Evening", "Streak", "Motivation"],
                weights=[40, 30, 20, 10]
            )[0],
            "opened": opened,
            "clicked": clicked,
            "journaled_after": journaled
        })

        rid += 1

reminder_df = pd.DataFrame(reminders)
reminder_df.to_csv("data/raw/reminders.csv", index=False)
print("Reminders:", len(reminder_df))

# -----------------------
# Subscriptions
# -----------------------

subs = []
sid = 1

for _, user in users.iterrows():

    if random.random() < 0.18:

        start = user.signup_date + timedelta(days=random.randint(5, 120))

        status = random.choices(
            ["Active", "Expired", "Cancelled"],
            weights=[55, 25, 20]
        )[0]

        end = None

        if status != "Active":
            end = start + timedelta(days=random.randint(30, 180))

        subs.append({
            "subscription_id": sid,
            "user_id": user.user_id,
            "plan_type": "Premium",
            "start_date": start.date(),
            "end_date": None if end is None else end.date(),
            "status": status
        })

        sid += 1

subscription_df = pd.DataFrame(subs)
subscription_df.to_csv("data/raw/subscriptions.csv", index=False)

print("Subscriptions:", len(subscription_df))

print("\\nDone!")
print("------------------------")
print("users.csv")
print("journal_entries.csv")
print("reminders.csv")
print("subscriptions.csv")