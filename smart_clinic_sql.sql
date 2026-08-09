CREATE DATABASE Smart_Clinic;
USE Smart_Clinic;

CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(10),
    Date_of_Birth DATE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

CREATE TABLE Doctor (
    Doctor_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Appointment (
    Appointment_ID INT PRIMARY KEY,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Status VARCHAR(50),
    Patient_ID INT,
    Doctor_ID INT,

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY,
    Amount DECIMAL(10,2),
    Payment_Date DATE,
    Payment_Method VARCHAR(50),
    Appointment_ID INT UNIQUE,

    FOREIGN KEY (Appointment_ID)
        REFERENCES Appointment(Appointment_ID)
);

CREATE TABLE Treatment (
    Treatment_ID INT PRIMARY KEY,
    Treatment_Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Appointment_ID INT,

    FOREIGN KEY (Appointment_ID)
        REFERENCES Appointment(Appointment_ID)
);

CREATE TABLE Medicine (
    Medicine_ID INT PRIMARY KEY,
    Medicine_Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Unit_Price DECIMAL(10,2)
);

CREATE TABLE Treatment_Medicine (
    Treatment_ID INT,
    Medicine_ID INT,
    Quantity INT,

    PRIMARY KEY (Treatment_ID, Medicine_ID),

    FOREIGN KEY (Treatment_ID)
        REFERENCES Treatment(Treatment_ID),

    FOREIGN KEY (Medicine_ID)
        REFERENCES Medicine(Medicine_ID)
);

INSERT INTO Patient
(Patient_ID, Full_Name, Gender, Date_of_Birth, Phone, Address)
VALUES
(1, 'Sara Ahmed', 'Female', '2001-05-14', '0501234567', 'Riyadh'),
(2, 'Noura Ali', 'Female', '1998-11-02', '0502345678', 'Jeddah'),
(3, 'Maha Salem', 'Female', '2003-03-21', '0503456789', 'Dammam'),
(4, 'Omar Khalid', 'Male', '1995-08-10', '0504567890', 'Riyadh'),
(5, 'Fahad Mohammed', 'Male', '2000-12-30', '0505678901', 'Makkah');

INSERT INTO Doctor
(Doctor_ID, Full_Name, Specialty, Phone, Email)
VALUES
(1, 'Dr. Ahmed Hassan', 'General Practitioner', '0551111111', 'ahmed@clinic.com'),
(2, 'Dr. Lina Omar', 'Dentist', '0552222222', 'lina@clinic.com'),
(3, 'Dr. Khalid Ali', 'Cardiologist', '0553333333', 'khalid@clinic.com'),
(4, 'Dr. Sara Mohammed', 'Dermatologist', '0554444444', 'sara@clinic.com'),
(5, 'Dr. Faisal Abdullah', 'Pediatrician', '0555555555', 'faisal@clinic.com');

INSERT INTO Appointment
(Appointment_ID, Appointment_Date, Appointment_Time, Status, Patient_ID, Doctor_ID)
VALUES
(1, '2025-11-01', '09:00:00', 'Completed', 1, 1),
(2, '2025-11-02', '10:30:00', 'Completed', 2, 2),
(3, '2025-11-03', '11:00:00', 'Scheduled', 3, 3),
(4, '2025-11-04', '01:00:00', 'Completed', 4, 4),
(5, '2025-11-05', '03:30:00', 'Scheduled', 5, 5);

INSERT INTO Payment
(Payment_ID, Amount, Payment_Date, Payment_Method, Appointment_ID)
VALUES
(1, 200.00, '2025-11-01', 'Cash', 1),
(2, 350.00, '2025-11-02', 'Card', 2),
(3, 500.00, '2025-11-03', 'Cash', 3),
(4, 250.00, '2025-11-04', 'Card', 4),
(5, 300.00, '2025-11-05', 'Cash', 5);

INSERT INTO Treatment
(Treatment_ID, Treatment_Name, Description, Appointment_ID)
VALUES
(1, 'General Checkup', 'Routine examination', 1),
(2, 'Teeth Cleaning', 'Dental cleaning', 2),
(3, 'Heart Check', 'ECG examination', 3),
(4, 'Skin Treatment', 'Acne treatment', 4),
(5, 'Child Consultation', 'Routine pediatric visit', 5);

INSERT INTO Medicine
(Medicine_ID, Medicine_Name, Description, Unit_Price)
VALUES
(1, 'Paracetamol', 'Pain relief', 15.00),
(2, 'Amoxicillin', 'Antibiotic', 35.00),
(3, 'Ibuprofen', 'Anti-inflammatory', 20.00),
(4, 'Vitamin C', 'Supplement', 25.00),
(5, 'Cough Syrup', 'Cough medicine', 18.00);

INSERT INTO Treatment_Medicine
(Treatment_ID, Medicine_ID, Quantity)
VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 2),
(4, 4, 1),
(5, 5, 1);

SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Payment;
SELECT * FROM Treatment;
SELECT * FROM Medicine;
SELECT * FROM Treatment_Medicine;

-- =====================================
-- Task 3 - SQL Operations
-- Done by: Raneen
-- =====================================

-- SELECT
USE Smart_Clinic;
SELECT * 
FROM Patient;


-- JOIN
SELECT
    p.Full_Name AS Patient,
    d.Full_Name AS Doctor,
    a.Appointment_Date,
    a.Status
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID;


-- Nested Query
SELECT Full_Name
FROM Patient
WHERE Patient_ID IN (
    SELECT Patient_ID
    FROM Appointment
    WHERE Status = 'Completed'
);


-- GROUP BY
SELECT Status, COUNT(*) AS Total_Appointments
FROM Appointment
GROUP BY Status;


-- UPDATE
UPDATE Appointment
SET Status = 'Completed'
WHERE Appointment_ID = 3;
SELECT *
FROM Appointment
WHERE Appointment_ID = 3;

-- DELETE
DELETE FROM Treatment_Medicine
WHERE Treatment_ID = 5;

SELECT * FROM Treatment_Medicine;

-- VIEW
CREATE VIEW Patient_Doctor_View AS
SELECT
    p.Full_Name AS Patient,
    d.Full_Name AS Doctor,
    a.Appointment_Date,
    a.Status
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID;
SELECT * FROM Patient_Doctor_View;

-- TRIGGER
DELIMITER $$

CREATE TRIGGER Check_Appointment_Status
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.Status IS NULL THEN
        SET NEW.Status = 'Scheduled';
    END IF;
END$$

DELIMITER ;
INSERT INTO Appointment
(Appointment_ID, Appointment_Date, Appointment_Time, Patient_ID, Doctor_ID, Status)
VALUES
(6, '2025-11-06', '12:00:00', 1, 1, NULL);
SELECT *
FROM Appointment
WHERE Appointment_ID = 6;