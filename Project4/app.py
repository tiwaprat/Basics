from flask import Flask, render_template, request, redirect, url_for
import mysql.connector  # Import mysql-connector-python

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_HOST'] = 'my-custom-mysql'  # Change this if you use a different host
app.config['MYSQL_USER'] = 'root'  # Replace with your MySQL username
app.config['MYSQL_PASSWORD'] = 'secret123'  # Replace with your MySQL password
app.config['MYSQL_DB'] = 'student_db'  # The database you created

# Initialize MySQL connection
def get_db_connection():
    return mysql.connector.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        database=app.config['MYSQL_DB']
    )

# Home route
@app.route('/')
def index():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM students")
    students = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('index.html', students=students)

# Route to add student
@app.route('/add', methods=['POST'])
def add_student():
    if request.method == 'POST':
        name = request.form['name']
        marks = request.form['marks']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO students (name, marks) VALUES (%s, %s)", (name, marks))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('index'))

# Route to delete student
@app.route('/delete/<int:id>')
def delete_student(id):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("DELETE FROM students WHERE id = %s", (id,))
    connection.commit()
    cursor.close()
    connection.close()
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=80)
