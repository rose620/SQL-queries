/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */

#Before diving into question 1, take a look at facilites data using:
 
SELECT name, membercost FROM `Facilities` 
notice how some names have membercost 



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
#use same method above to narrow in on names with more than 0 membercost

SELECT name FROM 'Facilities' WHERE membercost > 0

Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court



/* Q2: How many facilities do not charge a fee to members? */

#In this next question we not only need the member cost to be zero, we also need the actual count of those members so we want to utilize the COUNT function

SELECT name FROM 'Facilities' WHERE membercost > 0

COUNT(*)
4



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
#need to create columns for facidname, membercost and monthly maintenance using FROM WHERE AND:

SELECT facid, name, membercost, monthlymaintenance
  FROM `Facilities`
  WHERE membercost > 0
  AND membercost / monthlymaintenance < 0.2

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

#solve problem utilizing FROM WHERE IN:

SELECT * FROM `Facilities` WHERE facid IN (1, 5)

acid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	5.0	25.0	8000	200
5	Massage Room 2	9.9	80.0	4000	3000



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
#produce specified list of facilities using CASE WHEN THEN ELSE:

SELECT name, monthlymaintenance, 
  CASE WHEN monthlymaintenance > 100 THEN 'expensive'
     ELSE 'cheap' END AS label
  FROM `Facilities`

name	  monthlymaintenance	 label	
Tennis Court 1	 200	   expensive
Tennis Court 2	 200	   expensive
Badminton Court	 50	   cheap
Table Tennis	 10	   cheap
Massage Room 1	 3000	   expensive
Massage Room 2	 3000	   expensive
Squash Court	 80	   cheap
Snooker Table	 15	   cheap
Pool Table	      15	   cheap



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
#reference the same table multiple times to get the first and last name of the last or MAX joindate member that signed up

SELECT firstname, surname
FROM Members
WHERE joindate = (
SELECT MAX(joindate) FROM `Members`)

firstname	surname	
Darren	Smith



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by the member name. */
#Use inner join of `facilities`,`members` and `bookings` to get members who have used a tennis court(specify which tennis court). Use select distinct to avoid duplicate names and order by member alphabetically. 

SELECT DISTINCT tc.facility, CONCAT( tc.firstname,  ' ', tc.surname ) AS member
FROM (
SELECT DISTINCT Facilities.name AS facility, Members.firstname AS firstname, Members.surname AS surname
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Facilities.name LIKE  'Tennis Court%'
INNER JOIN Members ON Bookings.memid = Members.memid
) tc
GROUP BY tc.facility, tc.firstname, tc.surname
ORDER BY member


facility	member	
Tennis Court 2	Anne Baker
Tennis Court 1	Anne Baker
Tennis Court 1	Burton Tracy
Tennis Court 2	Burton Tracy
Tennis Court 1	Charles Owen
Tennis Court 2	Charles Owen
Tennis Court 2	Darren Smith
Tennis Court 1	David Farrell
Tennis Court 2	David Farrell
Tennis Court 1	David Jones
Tennis Court 2	David Jones
Tennis Court 1	David Pinker
Tennis Court 1	Douglas Jones
Tennis Court 1	Erica Crumpet
Tennis Court 1	Florence Bader
Tennis Court 2	Florence Bader
Tennis Court 2	Gerald Butters
Tennis Court 1	Gerald Butters
Tennis Court 1	GUEST GUEST
Tennis Court 2	GUEST GUEST
Tennis Court 2	Henrietta Rumney
Tennis Court 2	Jack Smith
Tennis Court 1	Jack Smith
Tennis Court 2	Janice Joplette
Tennis Court 1	Janice Joplette
Tennis Court 1	Jemima Farrell
Tennis Court 2	Jemima Farrell
Tennis Court 1	Joan Coplin
Tennis Court 2	John Hunt
Tennis Court 1	John Hunt
Tennis Court 1	Matthew Genting
Tennis Court 2	Millicent Purview
Tennis Court 1	Nancy Dare
Tennis Court 2	Nancy Dare
Tennis Court 1	Ponder Stibbons
Tennis Court 2	Ponder Stibbons
Tennis Court 1	Ramnaresh Sarwin
Tennis Court 2	Ramnaresh Sarwin
Tennis Court 2	Tim Boothe
Tennis Court 1	Tim Boothe
Tennis Court 1	Tim Rownam
Tennis Court 2	Tim Rownam
Tennis Court 1	Timothy Baker
Tennis Court 2	Timothy Baker
T-ennis Court 2	Tracy Smith
Tennis Court 1	Tracy Smith



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

#in order to find bookings on 2012-09-14 that are more than 30 dollars use case when to create list of names when specific date and > 30 occurs.0

SELECT Facilities.name AS facility, CONCAT( Members.firstname,  ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS price
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Bookings.starttime LIKE  '2012-09-14%'
AND (((Bookings.memid =0) AND (Facilities.guestcost * Bookings.slots >30))
OR ((Bookings.memid !=0) AND (Facilities.membercost * Bookings.slots >30)))
INNER JOIN Members ON Bookings.memid = Members.memid
ORDER BY price DESC

facility	name	price	
Massage Room 2	GUEST GUEST	320.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Tennis Court 2	GUEST GUEST	150.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 2	GUEST GUEST	75.0
Squash Court	GUEST GUEST	70.0
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35.0
Squash Court	GUEST GUEST	35.0



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
#do the same thing as above but this time do subqery using the WHERE clause.

SELECT * 
FROM (
SELECT Facilities.name AS facility, CONCAT( Members.firstname,  ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS priceSELECT
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Bookings.starttime LIKE  '2012-09-14%'
INNER JOIN Members ON Bookings.memid = Members.memid
)tc
WHERE tc.price >30
ORDER BY tc.price DESC

facility	name	price	
Massage Room 2	GUEST GUEST	320.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Massage Room 1	GUEST GUEST	160.0
Tennis Court 2	GUEST GUEST	150.0
Tennis Court 2	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Tennis Court 1	GUEST GUEST	75.0
Squash Court	GUEST GUEST	70.0
Massage Room 1	Jemima Farrell	39.6
Squash Court	GUEST GUEST	35.0
Squash Court	GUEST GUEST	35.0



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

#in order to produce list of facilities with revenue less than 1000, use HAVING clause however WHERE clause could be used here as well 


SELECT * 
FROM (
SELECT tc.facility, SUM( tc.price ) AS total_revenue
FROM (
SELECT Facilities.name AS facility, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS price
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
)tc
GROUP BY tc.facility
)tc2
WHERE tc2.total_revenue <1000

facility	total_revenue	
Pool Table	270.0
Snooker Table	240.0
Table Tennis	180.0


