#!/usr/bin/python3
import psycopg2
import os
from psycopg2 import sql

def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv("PGDATABASE"),
        user=os.getenv("PGUSER"),
        password=os.getenv("PGPASSWORD"),
        host=os.getenv("PGHOST"),
        port=os.getenv("PGPORT")
    )

def list_sessions():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT pid, usename, client_addr, application_name, state, query
        FROM pg_stat_activity
        WHERE pid <> pg_backend_pid();
    """)
    sessions = cur.fetchall()
    cur.close()
    conn.close()
    
    file_path = "/tmp/session_list.txt"
    with open(file_path, "w") as file:
        file.write("Active Sessions:\n")
        file.write("PID | User | Client Address | Application | State | Query\n")
        file.write("-" * 80 + "\n")
        for session in sessions:
            session_str = " | ".join(str(s) if s is not None else "NULL" for s in session)
            print(session_str)
            file.write(session_str + "\n")
    
    print(f"Session list saved to {file_path}")
    return sessions

def kill_session(pid, method="cancel"):
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        if method == "terminate":
            cur.execute(sql.SQL("SELECT pg_terminate_backend(%s);"), [pid])
        else:
            cur.execute(sql.SQL("SELECT pg_cancel_backend(%s);"), [pid])
        conn.commit()
        print(f"Session with PID {pid} {'terminated' if method == 'terminate' else 'canceled'}.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

def main():
    sessions = list_sessions()
    if not sessions:
        print("No active sessions found.")
        return
    
    choice = input("Do you want to kill a session? (yes/no): ").strip().lower()
    if choice != "yes":
        print("Exiting without killing any session.")
        return
    
    pid = input("Enter the PID of the session to kill: ")
    method = input("Choose method (cancel/terminate): ").strip().lower()
    if method not in ["cancel", "terminate"]:
        print("Invalid method. Choose either 'cancel' or 'terminate'.")
        return
    
    try:
        kill_session(int(pid), method)
    except ValueError:
        print("Invalid PID. Please enter a numeric value.")

if __name__ == "__main__":
    main()

