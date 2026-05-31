import sqlite3

def update_schema():
    conn = sqlite3.connect('domus.db')
    cursor = conn.cursor()
    
    print("Checking test_groups table...")
    cursor.execute("PRAGMA table_info(test_groups)")
    columns = [column[1] for column in cursor.fetchall()]
    
    if 'description' not in columns:
        print("Adding 'description' column to test_groups...")
        cursor.execute("ALTER TABLE test_groups ADD COLUMN description TEXT")
    
    if 'price' not in columns:
        print("Adding 'price' column to test_groups...")
        cursor.execute("ALTER TABLE test_groups ADD COLUMN price NUMERIC(8,2) DEFAULT 0.0")
    
    if 'image' not in columns:
        print("Adding 'image' column to test_groups...")
        cursor.execute("ALTER TABLE test_groups ADD COLUMN image TEXT")
        
    print("Checking tests table...")
    cursor.execute("PRAGMA table_info(tests)")
    test_columns = [column[1] for column in cursor.fetchall()]
    
    if 'price' not in test_columns:
        print("Adding 'price' column to tests...")
        cursor.execute("ALTER TABLE tests ADD COLUMN price NUMERIC(8,2) DEFAULT 0.0")
        
    if 'is_paid' not in test_columns:
        print("Adding 'is_paid' column to tests...")
        cursor.execute("ALTER TABLE tests ADD COLUMN is_paid BOOLEAN DEFAULT 0")

    conn.commit()
    conn.close()
    print("Database schema updated successfully!")

if __name__ == "__main__":
    update_schema()
