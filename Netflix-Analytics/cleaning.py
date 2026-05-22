import pandas as pd

# Load dataset
df = pd.read_csv("netflix_titles.csv")

# Show first 5 rows
print(df.head())

# Check missing values
print(df.isnull().sum())

# Remove duplicate rows
df.drop_duplicates(inplace=True)

# Fill missing values
df['director']=df['director'].fillna("Unknown", inplace=True)
df['cast']=df['cast'].fillna("Not Available", inplace=True)
df['country'] = df['country'].fillna("Unknown").str.strip()

# Convert date column
df['date_added'] = pd.to_datetime(df['date_added'].str.strip(), errors='coerce')

# Save cleaned file
df.to_csv("cleaned_netflix.csv", index=False)

print("Cleaning completed successfully!")