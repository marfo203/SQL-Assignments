/******************************************************************************************
 Question 10, concurrency
 This is the second of two scripts that tests that the BryanAir database can handle concurrency.
 This script sets up a valid reservation and tries to pay for it in such a way that at most 
 one such booking should be possible (or the plane will run out of seats). This script should 
 be run in both terminals, in parallel. 
**********************************************************************************************/
SELECT "Testing script for Question 10, Adds a booking, should be run in both terminals" as "Message";
SELECT "Adding a reservations and passengers" as "Message";


START TRANSACTION;
LOCK TABLES reservation WRITE, route READ, weeklyschedule READ, flight READ, ticket WRITE;
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",21,@a); 
UNLOCK TABLES;
COMMIT;

CALL addPassenger(@a,00000001,"Saruman");
CALL addPassenger(@a,00000002,"Orch1");
CALL addPassenger(@a,00000003,"Orch2");
CALL addPassenger(@a,00000004,"Orch3");
CALL addPassenger(@a,00000005,"Orch4");
CALL addPassenger(@a,00000006,"Orch5");
CALL addPassenger(@a,00000007,"Orch6");
CALL addPassenger(@a,00000008,"Orch7");
CALL addPassenger(@a,00000009,"Orch8");
CALL addPassenger(@a,00000010,"Orch9");
CALL addPassenger(@a,00000011,"Orch10");
CALL addPassenger(@a,00000012,"Orch11");
CALL addPassenger(@a,00000013,"Orch12");
CALL addPassenger(@a,00000014,"Orch13");
CALL addPassenger(@a,00000015,"Orch14");
CALL addPassenger(@a,00000016,"Orch15");
CALL addPassenger(@a,00000017,"Orch16");
CALL addPassenger(@a,00000018,"Orch17");
CALL addPassenger(@a,00000019,"Orch18");
CALL addPassenger(@a,00000020,"Orch19");
CALL addPassenger(@a,00000021,"Orch20");
CALL addContact(@a,00000001,"saruman@magic.mail",080667989); 
SELECT SLEEP(5);
SELECT "Making payment, supposed to work for one session and be denied for the 
other" as "Message";

START TRANSACTION;
LOCK TABLES ticket WRITE, reservation WRITE, contact READ, reserved_pass WRITE, booking WRITE, profitfactor READ, flight READ, route READ, weeklyschedule READ, weeklyfactor READ;
CALL addPayment (@a, "Sauron",7878787878);
UNLOCK TABLES;
COMMIT;
SELECT "Nr of free seats on the flight (should be 19 if no overbooking occured,
 otherwise -2): " as "Message", (SELECT nr_of_free_seats from allFlights where
 departure_week = 1) as "nr_of_free_seats";
 



-- Other passportnr, copy into second terminal window
START TRANSACTION;
LOCK TABLES reservation WRITE, route READ, weeklyschedule READ, flight READ, ticket WRITE;
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",19,@b); 
UNLOCK TABLES;
COMMIT;
CALL addPassenger(@b,000000031,"Saruman");
CALL addPassenger(@b,000000033,"Orch2");
CALL addPassenger(@b,000000032,"Orch1");
CALL addPassenger(@b,000000034,"Orch3");
CALL addPassenger(@b,000000035,"Orch4");
CALL addPassenger(@b,000000036,"Orch5");
CALL addPassenger(@b,000000037,"Orch6");
CALL addPassenger(@b,000000038,"Orch7");
CALL addPassenger(@b,000000039,"Orch8");
CALL addPassenger(@b,00000041,"Orch9");
CALL addPassenger(@b,00000042,"Orch10");
CALL addPassenger(@b,00000062,"Orch11");
CALL addPassenger(@b,00000063,"Orch12");
CALL addPassenger(@b,00000064,"Orch13");
CALL addPassenger(@b,00000065,"Orch14");
CALL addPassenger(@b,00000066,"Orch15");
CALL addPassenger(@b,00000067,"Orch16");
CALL addPassenger(@b,00000068,"Orch17");
CALL addPassenger(@b,00000069,"Orch18");
CALL addPassenger(@b,00000070,"Orch19");
CALL addPassenger(@b,00000071,"Orch20");
CALL addContact(@b,000000031,"saruman@magic.mail",080667989); 
SELECT SLEEP(5);


START TRANSACTION;
LOCK TABLES ticket WRITE, reservation WRITE, contact READ, reserved_pass WRITE, booking WRITE, profitfactor READ, flight READ, route READ, weeklyschedule READ, weeklyfactor READ;
CALL addPayment (@b, "Sauron",7878787878);
UNLOCK TABLES;
 COMMIT;
SELECT "Nr of free seats on the flight (should be 19 if no overbooking occured,
 otherwise -2): " as "Message", (SELECT nr_of_free_seats from allFlights where
 departure_week = 1) as "nr_of_free_seats";
 
 


