-- ==============================================
-- Library System Management - Problem Statements
-- ==============================================

-- Task 1: Create a New Book Record
-- Objective: Insert the following new book record into the books table:
-- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'

-- Task 2: Update an Existing Member's Address
-- Objective: Update the address of a specific member in the members table.

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

-- Task 6: CTAS - Create Summary Table of Books and Issue Count
-- Objective: Use CTAS to generate a new table showing each book and total book_issued_cnt.

-- Task 7: Retrieve All Books in a Specific Category
-- Objective: List all books that belong to a given category.

-- Task 8: Find Total Rental Income by Category
-- Objective: Calculate total rental income grouped by category.

-- Task 9: List Members Who Registered in the Last 180 Days
-- Objective: Retrieve members whose reg_date is within the last 180 days.

-- Task 10: List Employees with Their Branch Manager's Name and Branch Details
-- Objective: Display each employee, their branch details, and their branch manager's name.

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
-- Objective: Use CTAS to create a table containing books with rental_price above a given value.

-- Task 12: Retrieve the List of Books Not Yet Returned
-- Objective: List all books that have been issued but not returned.

-- Task 13: Identify Members with Overdue Books
-- Objective: Find members with overdue books (assume a 30-day return period).
-- Output: member_name, book_title, issue_date, and days overdue.

-- Task 14: Update Book Status on Return
-- Objective: Update the status of books in the books table to 'available' when returned (based on return_status table).

-- Task 15: Branch Performance Report
-- Objective: Show each branch's number of books issued, number returned, and total rental revenue.

-- Task 16: CTAS - Create a Table of Active Members
-- Objective: Create a table active_members containing members who have issued at least one book in the last 18 months.

-- Task 17: Find Employees with the Most Book Issues Processed
-- Objective: Retrieve the top 3 employees who processed the most book issues.
-- Output: employee name, number of books processed, and branch.

-- Task 18: Identify Members Issuing High-Risk Books
-- Objective: Find members who have issued books with the status 'damaged'.
-- Output: member_name, book_title, and count of times issued damaged books.

-- Task 19: Stored Procedure - Manage Book Status
-- Objective: Create a stored procedure to update the status of a book when issued or returned.
-- Description:
-- - If issued → status = 'no'
-- - If returned → status = 'yes'

