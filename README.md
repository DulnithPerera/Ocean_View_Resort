# Ocean View Resort - User Management

## Project Overview
This is a Maven-based web application that manages users for the Ocean View Resort. It includes:
- **User Model**: POJO class representing a user with id, name, email, and phone
- **UserDao**: Data Access Object for database operations (CRUD)
- **DatabaseConnection**: Utility class for managing database connections
- **index.jsp**: JSP page that displays all users from the database

## Prerequisites
- Java 8+
- Maven 3.6+
- MySQL Server running on localhost
- MySQL connector-java (included in pom.xml)

## Database Setup

1. Open MySQL command line or MySQL Workbench
2. Execute the `database_setup.sql` file:
   ```sql
   source database_setup.sql;
   ```
   Or manually run the SQL commands in the file to create the database and users table.

## Configuration

The database connection parameters are located in `src/main/java/org/example/util/DatabaseConnection.java`:
- **URL**: jdbc:mysql://localhost:3306/ocean_view_resort
- **Username**: root
- **Password**: root
- **Driver**: com.mysql.cj.jdbc.Driver

**Important**: Update these credentials if your MySQL setup is different.

## Build and Run

1. Build the project:
   ```bash
   mvn clean install
   ```

2. Deploy the WAR file to your application server (Tomcat, etc.)

3. Access the application:
   - Open browser and navigate to: `http://localhost:8080/Ocean_View_Resort/`

## Project Structure
```
src/main/
├── java/
│   └── org/example/
│       ├── model/
│       │   └── User.java
│       ├── dao/
│       │   └── UserDao.java
│       └── util/
│           └── DatabaseConnection.java
└── webapp/
    ├── index.jsp
    └── WEB-INF/
        └── web.xml
```

## Features

### User Model
- Properties: id, name, email, phone
- Getters and setters for all properties
- Constructors for initialization

### UserDao
- `getUsers()`: Retrieves all users from the database
- `getUserById(int id)`: Gets a specific user by ID
- `addUser(User user)`: Adds a new user
- `updateUser(User user)`: Updates user information
- `deleteUser(int id)`: Deletes a user by ID

### Index Page
- Displays all users in a formatted HTML table
- Shows user ID, name, email, and phone
- Error handling for database connection issues
- Responsive styling with CSS

## Error Handling
If you encounter a connection error, verify:
1. MySQL server is running
2. Database and table exist (run database_setup.sql)
3. Database credentials in DatabaseConnection.java are correct
4. Firewall doesn't block MySQL port (default: 3306)

