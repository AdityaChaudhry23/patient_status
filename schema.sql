------------------------------------ SCHEMA -------------------------------------


CREATE TABLE doctor (
  did INTEGER PRIMARY KEY,
  f_name VARCHAR(255),
  department VARCHAR(255),
  phone_no VARCHAR(20)
);

CREATE TABLE patient (
  pid INTEGER PRIMARY KEY,
  full_name VARCHAR(255),
  room_id INTEGER
  age INTEGER,
  address VARCHAR(255),
  phone_no VARCHAR(20),
  gender CHAR(1)
);

CREATE TABLE room (
  room_id INTEGER PRIMARY KEY,
  type VARCHAR(255)
);

CREATE TABLE bill (
  bill_no INTEGER PRIMARY KEY,
  treatment_charge INTEGER,
  consultancy_fees INTEGER
);

ALTER TABLE patient ADD room_id INTEGER;
ALTER TABLE patient ADD CONSTRAINT fk_room_id FOREIGN KEY (room_id) REFERENCES room(room_id);

CREATE TABLE doctor_patient (
  did INTEGER,
  pid INTEGER,
  PRIMARY KEY (did, pid),
  FOREIGN KEY (did) REFERENCES doctor(did),
  FOREIGN KEY (pid) REFERENCES patient(pid)
);



------------------------------------ STORED PROCEDURES -------------------------------------



CREATE OR REPLACE PROCEDURE assign_room_to_patient (
    pid IN NUMBER,
    room_id IN NUMBER
)
AS
BEGIN
    UPDATE patient
    SET room_id = room_id
    WHERE pid = pid;
END;

CREATE OR REPLACE PROCEDURE discharge_patient(
    pid IN NUMBER
)
AS
BEGIN
    UPDATE patient
    SET room_id = NULL
    WHERE pid = pid;
END;

CREATE OR REPLACE PROCEDURE getPatientListByDoctor(@did INT)
AS
BEGIN
	SELECT p.pid, p.name, p.age, p.address, p.phone_no, d.name AS doctor_name, d.department
	FROM patient p
	INNER JOIN treatment t ON t.pid = p.pid
	INNER JOIN doctor d ON d.did = t.did
	WHERE t.did = @did;
END;

-- EXEC getPatientListByDoctor 123;

CREATE OR REPLACE PROCEDURE getPatientListByRoom(@room_id INT)
AS
BEGIN
    SELECT p.pid, p.name, p.age, p.address, p.phone_no, d.name AS doctor_name, d.department
    FROM patient p
    INNER JOIN treatment t ON t.pid = p.pid
    INNER JOIN doctor d ON d.did = t.did
    WHERE p.room_id = @room_id;
END;

-- EXEC getPatientListByRoom 1;


------------------------------------ STORED FUNCTIONS -------------------------------------



CREATE OR REPLACE FUNCTION get_total_bill_amount (
    pid IN NUMBER
) RETURN NUMBER
AS
    total_bill_amount NUMBER := 0;
BEGIN
    SELECT SUM(treatment_charge + consultancy_fees)
    INTO total_bill_amount
    FROM bill
    WHERE pid = pid;
    RETURN total_bill_amount;
END;

