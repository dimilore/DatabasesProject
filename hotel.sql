/* hotel.sql -- for PostgreSQL
   prepared by Lorentzos Dimitrios - Sotirios,421 */

-- Customer Table

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
CustomerID SERIAL UNIQUE NOT NULL,
FirstName CHAR(100) NOT NULL,
LastName CHAR(100) NOT NULL,
PostalCode CHAR(100) NULL,
TelePhone CHAR(100) NOT NULL,
MobilePhone CHAR(100) NULL,
Email CHAR(100) NULL,
Country CHAR(100) NULL,
City CHAR(100) NULL,
Address CHAR(100) NOT NULL,
CONSTRAINT customer_id PRIMARY KEY(CustomerID));

--Room Table

DROP TABLE IF EXISTS Room;
CREATE TABLE Room(
RoomID SERIAL UNIQUE NOT NULL,
RoomType CHAR(1) NOT NULL,
Price REAL NOT NULL CHECK (Price>=0),/*Η τιμή δωματίου πρέπει να είναι θετική */
RoomName CHAR(5) UNIQUE NOT NULL,
Booked SMALLINT NOT NULL,
CONSTRAINT room_id PRIMARY KEY(RoomID));

--Administrator Table
DROP TABLE IF EXISTS Administrator;
CREATE TABLE Administrator(
RootID SERIAL UNIQUE NOT NULL,
RootUsername CHAR(100) UNIQUE NOT NULL,
RootPassword CHAR(200) NOT NULL,
CONSTRAINT root_id PRIMARY KEY(RootID));

--SystemAdmin Table

DROP TABLE IF EXISTS SystemAdmin;
CREATE TABLE SystemAdmin(
SysAdminID SERIAL UNIQUE NOT NULL,
RootID INTEGER NOT NULL,
UserName CHAR(100) UNIQUE NOT NULL,
Pass_word CHAR(100) NOT NULL,
Name CHAR(100) NOT NULL,
Surname CHAR(100) NOT NULL,
SysAdminEmail CHAR(100) UNIQUE NOT NULL,
CONSTRAINT sys_admin_id PRIMARY KEY(SysAdminID),
CONSTRAINT fk1_SystemAdmin FOREIGN KEY (RootID)
	REFERENCES Administrator(RootID)  MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT);

--Table Reservation

DROP TABLE IF EXISTS Reservation;
CREATE TABLE Reservation(
ReservationID SERIAL UNIQUE NOT NULL,
CustomerID INTEGER NOT NULL,
RoomID INTEGER NOT NULL,
SysAdminID INTEGER NOT NULL,
Cancelled SMALLINT NOT NULL CHECK(Cancelled>=0), /* Ακριβώς 0 όταν δεν εχει ακυρωθεί και 1 όταν ακυρώθηκε*/
Arrival DATE NOT NULL,
Departure DATE NOT NULL,
Adults SMALLINT NOT NULL CHECK(Adults>0), /* Πρεπει εστω ένας ενήλικας να εχει κανει κρατησει */
Kids SMALLINT NOT NULL CHECK(Kids>=0), /* Μπορει καποιος να μην εχει παιδιά μαζί του κατά τη διαμονή του */
CONSTRAINT reservation_id PRIMARY KEY(ReservationID),
CONSTRAINT fk1_Reservation FOREIGN KEY (CustomerID)
	REFERENCES Customer(CustomerID)  MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk2_Reservation FOREIGN KEY (RoomID)
	REFERENCES Room(RoomID) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT fk3_Reservation FOREIGN KEY (SysAdminID)
	REFERENCES SystemAdmin(SysAdminID) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT);

-- Payment Table

DROP TABLE IF EXISTS Payment;
CREATE TABLE Payment(
PaymentID SERIAL UNIQUE NOT NULL,
ReservationID INTEGER NOT NULL,
Paid SMALLINT NOT NULL CHECK(Paid>=0),/* Ακριβώς 0 όταν δεν εχει πληρωθεί και 1 όταν πληρώθηκε*/
Total REAL NOT NULL CHECK(Total>=0), /*Το συνολικό ποσό πρεπει να ειναι θετικός αριθμός */
CONSTRAINT payment_id PRIMARY KEY(PaymentID),
CONSTRAINT fk1_Payment FOREIGN KEY (ReservationID)
	REFERENCES Reservation(ReservationID) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT);



