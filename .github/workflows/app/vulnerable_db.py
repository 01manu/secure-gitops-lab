import sqlite3

def get_user_data(user_input: str):
    conn = sqlite3.connect("database.db")
    cursor = conn.cursor()
    
    # Intentionally vulnerable SQL query string concatenation
    query = f"SELECT * FROM users WHERE username = '{user_input}'"
    cursor.execute(query)
    
    return cursor.fetchall()
