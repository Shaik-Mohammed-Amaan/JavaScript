CREATE TABLE Customers ( 
    CustomerID NUMBER PRIMARY KEY, 
    Name VARCHAR2(100), 
    DOB DATE, 
    Balance NUMBER, 
    LastModified DATE 
);

CREATE TABLE Accounts ( 
    AccountID NUMBER PRIMARY KEY, 
    CustomerID NUMBER, 
    AccountType VARCHAR2(20), 
    Balance NUMBER, 
    LastModified DATE, 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

CREATE TABLE Transactions ( 
    TransactionID NUMBER PRIMARY KEY, 
    AccountID NUMBER, 
    TransactionDate DATE, 
    Amount NUMBER, 
    TransactionType VARCHAR2(10), 
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) 
);

CREATE TABLE Loans ( 
    LoanID NUMBER PRIMARY KEY, 
    CustomerID NUMBER, 
    LoanAmount NUMBER, 
    InterestRate NUMBER, 
    StartDate DATE, 
    EndDate DATE, 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

CREATE TABLE Employees ( 
    EmployeeID NUMBER PRIMARY KEY, 
    Name VARCHAR2(100), 
    Position VARCHAR2(50), 
    Salary NUMBER, 
    Department VARCHAR2(50), 
    HireDate DATE 
);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) 
VALUES (1, 'John Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 1000, SYSDATE);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified) 
VALUES (2, 'Jane Smith', TO_DATE('1990-07-20', 'YYYY-MM-DD'), 1500, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified) 
VALUES (1, 1, 'Savings', 1000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified) 
VALUES (2, 2, 'Checking', 1500, SYSDATE);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) 
VALUES (1, 1, SYSDATE, 200, 'Deposit');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) 
VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate) 
VALUES (1, 1, 5000, 5, SYSDATE, ADD_MONTHS(SYSDATE, 60));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate) 
VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate) 
VALUES (2, 'Bob Brown', 'Developer', 60000, 'IT', TO_DATE('2017-03-20', 'YYYY-MM-DD'));

DECLARE 
    v_customer_id   Loans.CustomerID%TYPE; 
    v_interest_rate Loans.InterestRate%TYPE; 
    v_age           NUMBER; 
    CURSOR loan_cursor IS 
        SELECT CustomerID, InterestRate 
        FROM Loans 
        WHERE CustomerID IN ( 
            SELECT CustomerID 
            FROM Customers 
            WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, DOB) / 12) > 60 
        ); 
BEGIN 
    OPEN loan_cursor; 
    LOOP 
        FETCH loan_cursor INTO v_customer_id, v_interest_rate; 
        EXIT WHEN loan_cursor%NOTFOUND; 
 
        -- Apply a 1% discount to the current loan interest rate 
        UPDATE Loans 
        SET InterestRate = v_interest_rate - 1 
        WHERE CustomerID = v_customer_id; 
    END LOOP; 
    CLOSE loan_cursor; 
     
    COMMIT; 
    DBMS_OUTPUT.PUT_LINE('Interest rates updated for customers above 60 years old.'); 
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK; 
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM); 
END; 
/

ALTER TABLE Customers 
MODIFY IsVIP VARCHAR(5);

ALTER TABLE Customers 
MODIFY IsVIP DEFAULT 'FALSE';

