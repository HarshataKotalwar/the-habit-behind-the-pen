import pandas as pd

# -----------------------------
# Load datasets
# -----------------------------

users = pd.read_csv("data/raw/users.csv")
journal = pd.read_csv("data/raw/journal_entries.csv")
reminders = pd.read_csv("data/raw/reminders.csv")
subscriptions = pd.read_csv("data/raw/subscriptions.csv")

print("=" * 60)
print("DATA VALIDATION REPORT")
print("=" * 60)

# ---------------------------------------------------
# USERS
# ---------------------------------------------------

print("\nUSERS")

print(f"Rows: {len(users)}")

print(f"Duplicate user_id: {users['user_id'].duplicated().sum()}")

print("Missing values:")
print(users.isnull().sum())

# ---------------------------------------------------
# JOURNAL ENTRIES
# ---------------------------------------------------

print("\nJOURNAL ENTRIES")

print(f"Rows: {len(journal)}")

print(f"Duplicate entry_id: {journal['entry_id'].duplicated().sum()}")

print("Missing values:")
print(journal.isnull().sum())

print("Invalid mood_before:",
      ((journal["mood_before"] < 1) |
       (journal["mood_before"] > 5)).sum())

print("Invalid mood_after:",
      ((journal["mood_after"] < 1) |
       (journal["mood_after"] > 5)).sum())

print("Negative word counts:",
      (journal["word_count"] <= 0).sum())

print("Negative writing duration:",
      (journal["writing_duration_minutes"] <= 0).sum())

invalid_users = (
    ~journal["user_id"].isin(users["user_id"])
).sum()

print("Invalid user_id references:",
      invalid_users)

# ---------------------------------------------------
# REMINDERS
# ---------------------------------------------------

print("\nREMINDERS")

print(f"Rows: {len(reminders)}")

print(f"Duplicate reminder_id: {reminders['reminder_id'].duplicated().sum()}")

print("Missing values:")
print(reminders.isnull().sum())

invalid_clicks = (
    (reminders["clicked"] == True) &
    (reminders["opened"] == False)
).sum()

print("Clicked without opening:",
      invalid_clicks)

invalid_users = (
    ~reminders["user_id"].isin(users["user_id"])
).sum()

print("Invalid user_id references:",
      invalid_users)

# ---------------------------------------------------
# SUBSCRIPTIONS
# ---------------------------------------------------

print("\nSUBSCRIPTIONS")

print(f"Rows: {len(subscriptions)}")

print(f"Duplicate subscription_id: {subscriptions['subscription_id'].duplicated().sum()}")

print("Missing values:")
print(subscriptions.isnull().sum())

subscriptions["start_date"] = pd.to_datetime(subscriptions["start_date"])

subscriptions["end_date"] = pd.to_datetime(
    subscriptions["end_date"],
    errors="coerce"
)

users_signup = users[["user_id", "signup_date"]].copy()

users_signup["signup_date"] = pd.to_datetime(
    users_signup["signup_date"]
)

merged = subscriptions.merge(
    users_signup,
    on="user_id",
    how="left"
)

invalid_start = (
    merged["start_date"] < merged["signup_date"]
).sum()

print("Subscription before signup:",
      invalid_start)

invalid_end = (
    merged["end_date"].notna() &
    (merged["end_date"] < merged["start_date"])
).sum()

print("End date before start date:",
      invalid_end)

print("\n" + "=" * 60)
print("VALIDATION COMPLETED")
print("=" * 60)