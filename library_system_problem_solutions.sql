-- ==============================================
-- Library System Management - Problem Statements
-- ==============================================

-- Task 1: Create a New Book Record
-- Objective: Insert the following new book record into the books table:
-- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES
	('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
	

-- Task 2: Update an Existing Member's Address
-- Objective: Update the address of a specific member in the members table.

UPDATE members
SET member_address = '185 Main St'
WHERE member_id = 'C101'


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS104'


-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT 
	 b.isbn,
	 b.book_title
FROM books b
JOIN 
	issued_status ist
ON b.isbn = ist.issued_book_isbn
WHERE ist.issued_emp_id = 'E101'


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
	m.member_id,
	m.member_name,
	COUNT(*) as total_issues
FROM members m
JOIN
	issued_status ist
ON m.member_id = ist.issued_member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(*) > 1
ORDER BY 3 DESC;

-- Task 6: CTAS - Create Summary Table of Books and Issue Count
-- Objective: Use CTAS to generate a new table showing each book and total book_issued_cnt.

CREATE TABLE book_count
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as book_issued_cnt
FROM books b
JOIN 
	issued_status ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title



-- Task 7: Retrieve All Books in a Specific Category
-- Objective: List all books that belong to a given category.

SELECT * FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category
-- Objective: Calculate total rental income grouped by category.


SELECT 
    b.category,
    COUNT(*) AS total_issues,
    SUM(b.rental_price) AS total_rental_income
FROM issued_status AS ist
JOIN books AS b
    ON b.isbn = ist.issued_book_isbn
GROUP BY b.category
ORDER BY total_rental_income DESC;


-- Task 9: List Members Who Registered in the Last 180 Days
-- Objective: Retrieve members whose reg_date is within the last 180 days.

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'


-- Task 10: List Employees with Their Branch Manager's Name and Branch Details
-- Objective: Display each employee, their branch details, and their branch manager's name.

SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id


-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
-- Objective: Use CTAS to create a table containing books with rental_price above a given value.

CREATE TABLE costly_books
AS    
SELECT * FROM Books
WHERE rental_price > 7;

SELECT * FROM 
costly_books


-- Task 12: Retrieve the List of Books Not Yet Returned
-- Objective: List all books that have been issued but not returned.

SELECT * FROM issued_status
SELECT * FROM return_status

SELECT
	DISTINCT ist.issued_book_name
FROM issued_status ist
LEFT JOIN
	return_status rst
ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL;

	
-- Task 13: Identify Members with Overdue Books
-- Objective: Find members with overdue books (assume a 30-day return period).
-- Output: member_name, book_title, issue_date, and days overdue.


SELECT 
	ist.issued_member_id,
	m.member_name,
	b.book_title,
	ist.issued_date,
	CURRENT_DATE - (ist.issued_date + INTERVAL '30 days') AS days_overdue
	
FROM members m 
JOIN
	issued_status ist
ON m.member_id = ist.issued_member_id
JOIN 
	books b
ON ist.issued_book_isbn = b.isbn
LEFT JOIN
	return_status rst
ON ist.issued_id = rst.issued_id
WHERE 
	rst.return_id IS NULL
	AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;


-- Task 14: Update Book Status on Return
-- Objective: Update the status of books in the books table to 'available' when returned (based on return_status table).



CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$

DECLARE
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);

BEGIN
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES
		(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	SELECT
		issued_book_isbn,
		issued_book_name
	INTO
		v_isbn,
		v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;

	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE 'Thankyou for returning the book: %', v_book_name;
				
END;
$$

-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'


SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';


-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');


-- Task 15: Branch Performance Report
-- Objective: Show each branch's number of books issued, number returned, and total rental revenue.

CREATE TABLE branch_reports
AS
SELECT 
	br.branch_id,
	COUNT(ist.issued_id) as total_issued,
	COUNT(rst.return_id) as total_returned,
	SUM(bk.rental_price) as total_revenue
FROM branch br
JOIN
	employees emp
ON br.branch_id = emp.branch_id
JOIN 
	issued_status ist
ON emp.emp_id = ist.issued_emp_id
JOIN 
	books bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN
	return_status rst
ON ist.issued_id = rst.issued_id
GROUP BY br.branch_id
ORDER BY 4 DESC;

SELECT * FROM issued_status ist
JOIN return_status rst
ON ist.issued_id = rst.issued_id;

SELECT * FROM branch_reports


-- Task 16: CTAS - Create a Table of Active Members
-- Objective: Create a table active_members containing members who have issued at least one book in the last 18 months.



CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN
					(SELECT 
						DISTINCT issued_member_id 
					FROM issued_status
					WHERE issued_date >= CURRENT_DATE - INTERVAL '18 months'
					
					)
;

SELECT * FROM active_members

-- Task 17: Find Employees with the Most Book Issues Processed
-- Objective: Retrieve the top 3 employees who processed the most book issues.
-- Output: employee name, number of books processed, and branch.


SELECT 
	e.emp_id,
	e.emp_name,
	b.branch_id,
	b.branch_address,
	COUNT(ist.issued_id) as total_issued
FROM issued_status ist
JOIN	
	employees e
ON ist.issued_emp_id = e.emp_id
JOIN	
	branch b
ON e.branch_id = b.branch_id
GROUP BY e.emp_id, e.emp_name, b.branch_id, b.branch_address
ORDER BY total_issued DESC
LIMIT 3;


-- Task 18: Identify Members Issuing High-Risk Books
-- Objective: Find members who have issued books with the status 'damaged'.
-- Output: member_name, book_title, and count of times issued damaged books.


SELECT
	m.member_id,
	m.member_name,
	bk.book_title,
	COUNT(ist.issued_id) as damaged_issued
FROM books bk
JOIN
	issued_status ist
ON bk.isbn = ist.issued_book_isbn
JOIN
	members m
ON m.member_id = ist.issued_member_id
JOIN
	return_status rst
ON ist.issued_id = rst.issued_id
WHERE rst.book_quality = 'Damaged'
GROUP BY 	m.member_id, m.member_name, bk.book_title


-- Task 19: Stored Procedure - Manage Book Status
-- Objective: Create a stored procedure to update the status of a book when issued or returned.
-- Description:
-- - If issued → status = 'no'
-- - If returned → status = 'yes'


CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(10)
										, p_issued_book_isbn VARCHAR(50), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
	v_status VARCHAR(10);

BEGIN
	SELECT
		status
	INTO
		v_status
	FROM books
	WHERE isbn = p_issued_book_isbn;

	IF v_status = 'yes' THEN
		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES
			(p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

			UPDATE books
			SET status = 'no'
			WHERE isbn = p_issued_book_isbn;

		RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;
	ELSE
		RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn:: %', p_issued_book_isbn;
	END IF;

END;
$$

SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;


CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');



CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');


SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

-- End of Project.


