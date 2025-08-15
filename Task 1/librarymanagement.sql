-- Create the database
CREATE DATABASE db_librarymanagement;
-- Use the newly created database
USE db_librarymanagement;

-- Table 1: Publisher details
CREATE TABLE Publisher (
    PublisherName VARCHAR(100) PRIMARY KEY,
    PublisherAddress VARCHAR(200),
    PublisherPhone VARCHAR(50)
);

-- Table 2: Book details
CREATE TABLE Book (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100),
    PublisherName VARCHAR(100),
    FOREIGN KEY (PublisherName) REFERENCES Publisher(PublisherName)
);

-- Table 3: Library branches
CREATE TABLE LibraryBranch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100),
    BranchAddress VARCHAR(200)
);

-- Table 4: Borrower details
CREATE TABLE Borrower (
    CardNo INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Address VARCHAR(200),
    Phone VARCHAR(50)
);

-- Table 5: Book loans
CREATE TABLE BookLoan (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    BranchID INT,
    CardNo INT,
    DateOut DATE,
    DueDate DATE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (BranchID) REFERENCES LibraryBranch(BranchID),
    FOREIGN KEY (CardNo) REFERENCES Borrower(CardNo)
);

-- Table 6: Book copies at each branch
CREATE TABLE BookCopy (
    CopyID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    BranchID INT,
    NoOfCopies INT,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (BranchID) REFERENCES LibraryBranch(BranchID)
);

-- Table 7: Book authors
CREATE TABLE BookAuthor (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    AuthorName VARCHAR(100),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- Insert Publishers
INSERT INTO Publisher (PublisherName, PublisherAddress, PublisherPhone) VALUES
('Tejesh', 'Chitoor', '000-000-0000'),
('Prasad', 'Anantapur', '000-000-0000'),
('Diwakar', 'Kadiri', '000-000-0000');

select * from Publisher;

-- Insert Books
INSERT INTO Book (Title, PublisherName) VALUES
('SQL Mastery', 'Tejesh'),
('Database Design', 'Prasad'),
('Normalization Explained', 'Diwakar');


-- Insert Library Branches
INSERT INTO LibraryBranch (BranchName, BranchAddress) VALUES
('Tirupati', 'AP51510'),
('Kadapa', 'AP52520'),
('Kurnool', 'AP53530');

select * from Library Branches;

-- Insert Borrowers
INSERT INTO Borrower (Name, Address, Phone) VALUES
('Jayachandra', 'Chitoor', '999-999-9999'),
('Nithish', 'Puttaparthi', '888-888-8888'),
('Karthik', 'Anantapur', '777-777-7777');

select * from Borrowers;

-- Insert Book Loans
INSERT INTO BookLoan (BookID, BranchID, CardNo, DateOut, DueDate) VALUES
(1, 1, 1, '2025-08-01', '2025-08-15'),
(2, 2, 2, '2025-08-03', '2025-08-17'),
(3, 3, 3, '2025-08-05', '2025-08-19');

select * from BookLoan;
-- Insert Book Copies
INSERT INTO BookCopy (BookID, BranchID, NoOfCopies) VALUES
(1, 1, 5),
(2, 2, 3),
(3, 3, 4);

select * from BookCopy;

-- Insert Book Authors
INSERT INTO BookAuthor (BookID, AuthorName) VALUES
(1, 'Kesavaiah'),
(2, 'Lalithamma'),
(3, 'Kesavaiah');

-- Retrieve book titles along with publisher name and address
SELECT b.Title, p.PublisherName, p.PublisherAddress
FROM Book b
JOIN Publisher p ON b.PublisherName = p.PublisherName;

-- Display branch name, book title, and number of copies available
SELECT lb.BranchName, b.Title, bc.NoOfCopies
FROM BookCopy bc
JOIN Book b ON bc.BookID = b.BookID
JOIN LibraryBranch lb ON bc.BranchID = lb.BranchID;

-- List distinct borrower names who borrowed books from publisher 'Tejesh'
SELECT DISTINCT br.Name
FROM BookLoan bl
JOIN Book b ON bl.BookID = b.BookID
JOIN Borrower br ON bl.CardNo = br.CardNo
WHERE b.PublisherName = 'Tejesh';

-- Show loan ID, book title, borrower name, and due date for overdue books
SELECT bl.LoanID, b.Title, br.Name, bl.DueDate
FROM BookLoan bl
JOIN Book b ON bl.BookID = b.BookID
JOIN Borrower br ON bl.CardNo = br.CardNo
WHERE bl.DueDate < CURDATE();  -- CURDATE() returns today's date



-- Aggregate total books borrowed by each borrower
SELECT br.Name, COUNT(*) AS BooksBorrowed
FROM BookLoan bl
JOIN Borrower br ON bl.CardNo = br.CardNo
GROUP BY br.CardNo;

-- Identify authors with more than one book contribution
SELECT AuthorName, COUNT(*) AS BookCount
FROM BookAuthor
GROUP BY AuthorName
HAVING COUNT(*) > 1;

-- Count how many books are associated with each publisher
SELECT PublisherName, COUNT(*) AS TotalBooks
FROM Book
GROUP BY PublisherName;

-- List branches and number of copies for the book titled 'SQL Mastery'
SELECT lb.BranchName, bc.NoOfCopies
FROM BookCopy bc
JOIN Book b ON bc.BookID = b.BookID
JOIN LibraryBranch lb ON bc.BranchID = lb.BranchID
WHERE b.Title = 'SQL Mastery';

