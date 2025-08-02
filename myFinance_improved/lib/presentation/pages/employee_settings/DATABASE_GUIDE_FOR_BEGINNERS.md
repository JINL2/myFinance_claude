# Employee Settings - Database Guide for Beginners 🗄️

## What is a Database? 🤔

Think of a database like a giant, organized filing cabinet where your app stores all its information. Just like how you might have different folders for different types of documents, a database has different "tables" for different types of information.

## Understanding Your Employee Data Structure 📊

### The Main Filing Cabinets (Tables) 📁

Your app uses several "filing cabinets" to store employee information:

1. **`users` table** - The main employee file
   - Contains: Name, email, profile picture
   - Think of it as: The basic ID card for each person

2. **`user_salaries` table** - The payroll file
   - Contains: Salary amount, type (monthly/hourly), currency
   - Think of it as: The paycheck information

3. **`roles` table** - The job positions file
   - Contains: Role names (Manager, Cashier, etc.)
   - Think of it as: The list of all possible job titles

4. **`user_roles` table** - Who has which job
   - Contains: Links between employees and their roles
   - Think of it as: The assignment sheet showing who does what

5. **`companies` & `stores` tables** - The business locations
   - Contains: Company and store information
   - Think of it as: The list of all your business locations

### The Magic Views 🪄

A "view" in the database is like a pre-made report that combines information from multiple filing cabinets. Your app uses:

**`v_user_salary` view** - A combined report that shows:
- Employee name + Role + Salary + Company + Store
- All in one place! No need to look in 5 different files

## How Your App Talks to the Database 💬

### 1. Fetching Data (Reading Information) 📖

When your app needs to show employee information:

```dart
// This is like asking: "Please get me all employees from Company ABC"
final employees = await supabase
  .from('v_user_salary')  // Which filing cabinet to look in
  .select('*')            // Get all information
  .eq('company_id', 'ABC') // Only for company ABC
```

**Real-world analogy**: It's like asking your assistant to "Get me all employee files from the ABC company folder"

### 2. Updating Data (Changing Information) ✏️

When you need to change an employee's salary:

```dart
// This is like saying: "Please update John's salary to $5000"
await supabase.rpc('update_user_salary', params: {
  'p_salary_id': 'john123',     // Which employee
  'p_salary_amount': 5000,      // New salary
  'p_salary_type': 'monthly',   // Monthly or hourly
  'p_currency_id': 'USD',       // Which currency
});
```

**Real-world analogy**: It's like filling out a salary change form and submitting it to HR

### What is an RPC Function? 🤖

RPC stands for "Remote Procedure Call" - but think of it as a **smart assistant** that:
- Knows how to do complex tasks
- Makes sure everything is done correctly
- Handles multiple steps automatically

For example, `update_user_salary` RPC function:
1. Finds the right employee record
2. Updates their salary
3. Records who made the change
4. Saves the timestamp
5. Makes sure all related records are updated

All with one simple command!

## The Flow of Data 🌊

### When Loading the Employee List:

```
Your App → Database: "Show me all employees"
         ← Database: "Here are 25 employees with their info"
Your App → Screen: Shows employee cards
```

### When Editing an Employee:

```
User clicks "Edit" → Your App → Database: "Get full details for Employee #123"
                              ← Database: "Here's everything about Employee #123"
                              
User changes salary → Your App → Database: "Update salary to $5000"
                               ← Database: "Success! Salary updated"
                               
                    → Screen: Shows success message
```

## Common Database Operations Explained 🔧

### 1. SELECT (Reading Data)
**What it does**: Gets information from the database
**Like saying**: "Show me..."

Example:
```dart
.select('full_name, salary_amount, role_name')
// "Show me the name, salary, and role"
```

### 2. INSERT (Adding New Data)
**What it does**: Adds new information
**Like saying**: "Add this new..."

Example:
```dart
.insert({'name': 'John', 'role': 'Manager'})
// "Add John as a new Manager"
```

### 3. UPDATE (Changing Data)
**What it does**: Changes existing information
**Like saying**: "Change this to..."

Example:
```dart
.update({'salary_amount': 5000})
// "Change the salary to 5000"
```

### 4. DELETE (Removing Data)
**What it does**: Removes information (usually we just mark as deleted)
**Like saying**: "Remove this..."

Example:
```dart
.update({'is_deleted': true})
// "Mark this as deleted" (safer than actually deleting)
```

## Understanding Filters 🔍

Filters help you find specific information:

### Common Filters:

1. **`.eq('field', 'value')`** - Equals
   - Example: `.eq('role_name', 'Manager')` 
   - Like saying: "Only show Managers"

2. **`.neq('field', 'value')`** - Not equals
   - Example: `.neq('status', 'inactive')`
   - Like saying: "Don't show inactive employees"

3. **`.gt('field', value)`** - Greater than
   - Example: `.gt('salary_amount', 3000)`
   - Like saying: "Only show salaries above 3000"

4. **`.contains('field', 'text')`** - Contains
   - Example: `.contains('full_name', 'John')`
   - Like saying: "Show names containing 'John'"

## Real-Time Updates ⚡

Your database can notify your app when things change:

```dart
supabase
  .from('v_user_salary')
  .stream(primaryKey: ['user_id'])
  .listen((data) {
    // This runs whenever employee data changes
    updateYourScreen(data);
  });
```

**Real-world analogy**: It's like having a assistant who immediately tells you whenever someone's information changes

## Error Handling 🚨

Sometimes things go wrong. Here's what might happen:

1. **Network Error**: Can't reach the database
   - Solution: Check internet connection
   
2. **Permission Error**: Not allowed to do something
   - Solution: Check user permissions
   
3. **Data Error**: Information is invalid
   - Solution: Validate before sending

Always wrap database calls in try-catch:

```dart
try {
  // Try to update salary
  await updateSalary(...);
  showSuccessMessage("Salary updated!");
} catch (error) {
  // If something goes wrong
  showErrorMessage("Couldn't update salary. Please try again.");
}
```

## Best Practices 📝

### 1. Always Check Before Deleting
Never permanently delete data. Mark as deleted instead:
```dart
.update({'is_deleted': true, 'deleted_at': DateTime.now()})
```

### 2. Use Views for Complex Data
Instead of combining data in your app, use database views like `v_user_salary`

### 3. Handle Loading States
Always show loading indicators:
```dart
if (isLoading) {
  return CircularProgressIndicator();
}
```

### 4. Validate Data
Check data before sending to database:
```dart
if (salary <= 0) {
  showError("Salary must be greater than 0");
  return;
}
```

## Quick Reference Cheat Sheet 📋

| What You Want | Database Command | Example |
|---------------|------------------|---------|
| Get all employees | `.select('*')` | Get everything |
| Get specific fields | `.select('name, salary')` | Get only name and salary |
| Filter by company | `.eq('company_id', id)` | Only this company |
| Sort by name | `.order('full_name')` | A to Z order |
| Limit results | `.limit(20)` | Only first 20 |
| Search names | `.ilike('name', '%john%')` | Names containing "john" |
| Update salary | `.rpc('update_user_salary')` | Use the special function |

## Summary 🎯

Think of database operations like managing a well-organized office:
- **Tables** = Filing cabinets
- **Views** = Pre-made reports
- **RPC Functions** = Smart assistants
- **Queries** = Requests for information
- **Filters** = Search criteria

The database keeps everything organized and makes sure your app always has the right information at the right time!