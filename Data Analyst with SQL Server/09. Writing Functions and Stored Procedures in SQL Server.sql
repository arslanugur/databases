1. Temporal EDA, Variables & Date Manipulation
Learn how to do effective exploratory data analysis on temporal data, create scalar and table variables to store data, 
and learn how to execute date manipulation. This chapter will also cover the following SQL functions: 
DATEDIFF( ), DATENAME( ), DATEPART( ), CAST( ), CONVERT( ), GETDATE( ), and DATEADD( ).

1.1. Introduction to the course
1.2. Transactions per day
It's time for you to do some temporal EDA on the BikeShare dataset. 
Write a query to determine how many transactions exist per day.
Sometimes datasets have multiple sources and this query can help you understand if you are missing data.

Instructions
Use CONVERT() to SELECT and GROUP BY the date portion of the StartDate.
Use COUNT() to measure how many records exist for each StartDate.
Sort the results by the date portion of StartDate.

SELECT
  -- Select the date portion of StartDate
  CONVERT(DATE, StartDate) as StartDate,
  -- Measure how many records exist for each StartDate
  COUNT(ID) as CountOfRows 
FROM CapitalBikeShare 
-- Group by the date portion of StartDate
GROUP BY CONVERT(DATE, StartDate)
-- Sort the results by the date portion of StartDate
ORDER BY CONVERT(DATE, StartDate);


1.3. Seconds or no seconds?
In the video, you saw how DATEDIFF() can be used to calculate the trip time 
by finding the difference between Start and End time, but how do you know the dataset includes seconds in the transactions?

Here, you'll use DATEPART() to see how many transactions have seconds greater than zero and how many have them equal to zero. 
Then you can evaluate if this is an appropriate amount. The CASE statement will segregate the dataset into two categories.

Instructions
Complete the first CASE statement, using DATEPART() to evaluate the SECOND date part of StartDate.
Complete the second CASE statement in the GROUP BY the same way.

SELECT
	-- Count the number of IDs
	COUNT(ID) AS Count,
    -- Use DATEPART() to evaluate the SECOND part of StartDate
    "StartDate" = CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
					   WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END
FROM CapitalBikeShare
GROUP BY
    -- Use DATEPART() to Group By the CASE statement
	CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
		 WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END
     

1.4. Which day of week is busiest?
Now that we verified there are seconds consistently in our dataset we can calculate the Total Trip Time for each day of the week.

Instructions
Use DATENAME() to SELECT the weekday value for the StartDate.
Use SUM() and DATEDIFF() to calculate TotalTripHours. (beginning with seconds).
Group by the DATENAME() result and summarize TotalTripHours.
Order TotalTripHours in descending order.

SELECT
    -- Select the day of week value for StartDate
	DATENAME(weekday, StartDate) as DayOfWeek,
    -- Calculate TotalTripHours
	SUM(DATEDIFF(second, StartDate, EndDate))/ 3600 as TotalTripHours
FROM CapitalBikeShare 
-- Group by the day of week
GROUP BY DATENAME(weekday, StartDate)
-- Order TotalTripHours in descending order
ORDER BY TotalTripHours DESC


1.5. Find the outliers
The previous exercise showed us that Saturday was the busiest day of the month for BikeShare rides. 
Do you wonder if there were any individual Saturday outliers that contributed to this?

Instructions
Use SUM() and DATEDIFF() to find the Total Ride Hours per day starting from seconds.
Use CONVERT() to SELECT the date portion of StartDate.
Use DATENAME() and CONVERT() to select the WEEKDAY.
Use WHERE to only include Saturdays.

SELECT
	-- Calculate TotalRideHours using SUM() and DATEDIFF()
  	SUM(DATEDIFF(SECOND, StartDate, EndDate))/ 3600 AS TotalRideHours,
    -- Select the DATE portion of StartDate
  	CONVERT(DATE, StartDate) AS DateOnly,
    -- Select the WEEKDAY
  	DATENAME(WEEKDAY, CONVERT(DATE, StartDate)) AS DayOfWeek
FROM CapitalBikeShare
-- Only include Saturday
WHERE DATENAME(WEEKDAY, StartDate) = 'Saturday' 
GROUP BY CONVERT(DATE, StartDate);


1.6. Variables for datetime data
1.7. DECLARE & CAST
Let's use DECLARE() and CAST() to combine a date variable and a time variable into a datetime variable.

Instructions
Create a time variable named @ShiftStartTime and set initial value to '08:00 AM'.
Create a date variable named @StartDate and set it to the first StartDate from the BikeShare table.
Create a datetime variable named `@ShiftStartDateTime.
Change @StartDate and @ShiftStartTime to datetime data types and assign to @ShiftStartDateTime.

-- Create @ShiftStartTime 
DECLARE @ShiftStartTime AS time = '08:00 AM'

-- Create @StartDate 
DECLARE @StartDate AS date

-- Set StartDate to the first StartDate from CapitalBikeShare 
SET 
  @StartDate = ( 
            SELECT TOP 1 StartDate 
            FROM CapitalBikeShare 
            ORDER BY StartDate ASC 
           )

-- Create ShiftStartDateTime 
DECLARE @ShiftStartDateTime AS datetime

-- Cast StartDate and ShiftStartTime to datetime data types 
SET @ShiftStartDateTime = CAST(@StartDate AS datetime) + CAST(@ShiftStartTime AS datetime)

SELECT @ShiftStartDateTime



1.8. DECLARE a TABLE
Let's create a TABLE variable to store Shift data and then populate it with static values.

Instructions
Use DECLARE to create a TABLE variable named @Shifts
The @Shifts table variable should have the following columns - StartDateTime and EndDateTime - both of datetime data type.
Populate the table variable with the values '3/1/2018 8:00 AM' and '3/1/2018 4:00 PM'.

-- Declare @Shifts as a TABLE 
DECLARE @Shifts TABLE( 
    -- Create StartDateTime column 
    StartDateTime datetime, 
    -- Create EndDateTime column 
    EndDateTime datetime) 
    -- Populate @Shifts 
INSERT INTO @Shifts (StartDateTime, EndDateTime) 
  SELECT '3/1/2018 8:00 AM', '3/1/2018 4:00 PM' 
SELECT * 
FROM @Shifts


1.9. INSERT INTO @TABLE
Instead of storing static values in a table variable, let's store the result of a query.
Declare a TABLE variable named @RideDates with the following columns RideStart and RideEnd.
Both table variable columns should be date data type.
SELECT the unique values of StartDate and EndDate from the CapitalBikeShare table. CAST them from datetime to date data types.
Store the query results in @RideDates.

-- Declare @RideDates
DECLARE @RideDates TABLE(
    -- Create RideStart
	RideStart date,
    -- Create RideEnd
	RideEnd date)
-- Populate @RideDates
INSERT INTO @RideDates(RideStart, RideEnd)
-- Select the unique date values of StartDate and EndDate
SELECT DISTINCT
    -- Cast StartDate as date
	CAST(StartDate as date),
    -- Cast EndDate as date
	CAST(EndDate as date) 
FROM CapitalBikeShare 
SELECT * 
FROM @RideDates


1.10. Date manipulation - Video
1.11. Parameters matter with DATEDIFF
How many times, in terms of days, weeks, and months, are the datepart boundaries crossed between the dates 2/26/2018 and 3/3/2018?
---> 5 days, 0 weeks, 1 month.

1.12. First day of month
Here you will use the GETDATE(), DATEDIFF(), and DATEADD() functions to find the first day of the current month.

Instructions
Find the current date value.
Calculate the difference in months between today and 0 (1/1/1900 in SQL).
Add 0 months to that difference to get the first day of the month.

-- Find the first day of the current month
SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)


2. User Defined Functions
This chapter will explain how to create, update, and execute user-defined functions (UDFs). 
You will learn about the various types of UDFs: scalar, inline, and multi-statement table-valued. 

2.1. Scalar user defined functions - Video
2.2. What was yesterday?
Create a function that returns yesterday's date.

Instructions
Create a function named GetYesterday() with no input parameters that RETURNS a date data type.
Use GETDATE() and DATEADD() to calculate yesterday's date value.

-- Create GetYesterday()
CREATE FUNCTION GetYesterday()
-- Specify return data type
RETURNS date
AS
BEGIN
-- Calculate yesterday's date value
RETURN(SELECT DATEADD(day, -1, GETDATE()))
END 


2.3. One in one out
Create a function named SumRideHrsSingleDay() which returns the total ride time in hours for the @DateParm parameter passed.

Instructions
Define input parameter of type date - @DateParm and a return data type of numeric.
Use BEGIN/END keywords.
In ur SELECT statement, SUM the difference between the StartDate and EndDate of the transactions that have the same StartDate value as the parameter passed.
Use CAST to compare the date portion of StartDate to the @DateParm.

-- Create SumRideHrsSingleDay
CREATE FUNCTION SumRideHrsSingleDay (@DateParm date)
-- Specify return data type
RETURNS numeric
AS
-- Begin
BEGIN
RETURN
-- Add the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
 -- Only include transactions where StartDate = @DateParm
WHERE CAST(StartDate AS date) = @DateParm)
-- End
END


2.4. Multiple inputs one output
Often times you will need to pass more than one parameter to a function. 
Create a function that accepts @StartDateParm and @EndDateParm and returns the total ride hours for all transactions that have a StartDate within the parameter values.

Instructions
Create a function named SumRideHrsDateRange with @StartDateParm and @EndDateParm as the input parameters of datetime data type.
Specify the return data type to be numeric.
Use a select statement to sum the difference between the StartDate and EndDate of the transactions.
Only include transactions that have a StartDate greater than @StartDateParm and less than @EndDateParm.

-- Create the function
CREATE FUNCTION SumRideHrsDateRange (@StartDateParm datetime, @EndDateParm datetime)
-- Specify return data type
RETURNS numeric
AS
BEGIN
RETURN
-- Sum the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
-- Include only the relevant transactions
WHERE StartDate > @StartDateParm and StartDate < @EndDateParm)
END



2.5. Table valued UDFs - Video
2.6. Inline TVF
Create an inline table value function that 
returns the number of rides and total ride duration for each StartStation where the StartDate of the ride is equal to the input parameter.

Instructions
Create a function named SumStationStats that has one input parameter of type datetime - @StartDate - and returns a TABLE data type.
Calculate the total RideCount using COUNT() and ID.
Calculate the TotalDuration using SUM() and DURATION.
Group by StartStation.

-- Create the function
CREATE FUNCTION SumStationStats(@StartDate AS datetime)
-- Specify return data type
RETURNS TABLE
AS
RETURN
SELECT
	StartStation,
    -- Use COUNT() to select RideCount
	COUNT(ID) as RideCount,
    -- Use SUM() to calculate TotalDuration
    SUM(DURATION) as TotalDuration
FROM CapitalBikeShare
WHERE CAST(StartDate as Date) = @StartDate
-- Group by StartStation
GROUP BY StartStation;


2.7. Multi statement TVF
Create a multi statement table value function that returns the trip count 
and average ride duration for each day for the month & year parameter values passed.

Instructions
Create a function CountTripAvgDuration() that returns a table variable named @DailyTripStats.
Declare input parameters @Month and @Year.
Insert the query results into the @DailyTripStats table variable.
Use CAST to select and group by StartDate as a date data type.

-- Create the function
CREATE FUNCTION CountTripAvgDuration (@Month CHAR(2), @Year CHAR(4))
-- Specify return variable
RETURNS @DailyTripStats TABLE(
	TripDate	date,
	TripCount	int,
	AvgDuration	numeric)
AS
BEGIN
-- Insert query results into @DailyTripStats
INSERT @DailyTripStats
SELECT
    -- Cast StartDate as a date
	CAST(StartDate AS date),
    COUNT(ID),
    AVG(Duration)
FROM CapitalBikeShare
WHERE
	DATEPART(month, StartDate) = @Month AND
    DATEPART(year, StartDate) = @Year
-- Group by StartDate as a date
GROUP BY CAST(StartDate AS date)
-- Return
RETURN
END


2.8. UDFs in action -Video
2.9. Execute scalar with select
Previously, you created a scalar function named SumRideHrsDateRange(). 
Execute that function for the '3/1/2018' through '3/10/2018' date range by passing local date variables.

Instructions
Create @BeginDate and @EndDate variables of type date with values '3/1/2018' and '3/10/2018'.
Execute the SumRideHrsDateRange() function by passing @BeginDate and @EndDate variables.
Include @BeginDate and @EndDate variables in your SELECT statement with the function result.

-- Create @BeginDate
DECLARE @BeginDate AS date = '3/1/2018'
-- Create @EndDate
DECLARE @EndDate AS date = '3/10/2018' 
SELECT
  -- Select @BeginDate
  @BeginDate AS BeginDate,
  -- Select @EndDate
  @EndDate AS EndDate,
  -- Execute SumRideHrsDateRange()
  dbo.SumRideHrsDateRange(@BeginDate, @EndDate) AS TotalRideHrs
  
  
2.10. EXEC scalar
You created the SumRideHrsSingleDay function earlier in this chapter. 
Execute that function using the EXEC keyword and store the result in a local variable.

Instructions
Create a local numeric variable named @RideHrs.
Use EXEC to execute the SumRideHrsSingleDay function and pass '3/5/2018' as the input parameter.
Store the result of the function in @RideHrs variable.

-- Create @RideHrs
DECLARE @RideHrs AS numeric
-- Execute SumRideHrsSingleDay function and store the result in @RideHrs
EXEC @RideHrs = dbo.SumRideHrsSingleDay @DateParm = '3/5/2018' 
SELECT 
  'Total Ride Hours for 3/5/2018:', 
  @RideHrs
  

2.11. Execute TVF into variable
Remember the table value function you created earlier in this chapter named SumStationStats?. 
It accepts a datetime parameter and returns the ride count and total ride duration for each starting station 
where the start date matches the input parameter. 
Execute SumStationStats now and store the results in a table variable.

Instructions
Create a table variable named @StationStats with columns StartStation, RideCount, and TotalDuration.
Execute the SumStationStats function and pass '3/15/2018' as the input parameter.
Use INSERT INTO to populate the @StationStats table variable with the results of the function.
Select all the records from the table variable.

-- Create @StationStats
DECLARE @StationStats TABLE(
	StartStation nvarchar(100), 
	RideCount int, 
	TotalDuration numeric)
-- Populate @StationStats with the results of the function
INSERT INTO @StationStats
SELECT TOP 10 *
-- Execute SumStationStats with 3/15/2018
FROM dbo.SumStationStats ('3/15/2018') 
ORDER BY RideCount DESC
-- Select all the records from @StationStats
SELECT * 
FROM @StationStats


2.12. Maintaining user defined functions - Video
2.13. CREATE OR ALTER
Change the SumStationStats function to enable SCHEMABINDING. 
Also change the parameter name to @EndDate and compare to EndDate of CapitalBikeShare table.

Instructions
Use CREATE OR ALTER keywords to update the SumStationStats function.
Change the parameter name to @EndDate and data type to date.
Compare the @EndDate to EndDate of the CapitalBikeShare table.
Enable SCHEMABINDING.

-- Update SumStationStats
CREATE OR ALTER FUNCTION dbo.SumStationStats(@EndDate AS date)
-- Enable SCHEMABINDING
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
SELECT
	StartStation,
    COUNT(ID) AS RideCount,
    SUM(DURATION) AS TotalDuration
FROM dbo.CapitalBikeShare
-- Cast EndDate as date and compare to @EndDate
WHERE CAST(EndDate AS Date) = @EndDate
GROUP BY StartStation;

2.14. Best practices
What makes a function Deterministic?
---> If it returns the same result given the same parameters passed and database state.



3. Stored Procedures
Learn how to create, update, and execute stored procedures. 
Investigate the differences between stored procedures and user defined functions, including appropriate scenarios for each.

3.1. Stored procedures
3.2. CREATE PROCEDURE with OUTPUT
3.3. Output parameters vs. Return values
3.4. Oh CRUD!
3.5. Use SP to INSERT
3.6. Use SP to UPDATE
3.7. Use SP to DELETE
3.8. Let's EXEC!
3.9. EXECUTE with OUTPUT parameter
3.10. EXECUTE with return value
3.11. EXECUTE with OUTPUT & return value
3.12. TRY & CATCH those errors!
3.13. Your very own TRY..CATCH
3.14. CATCH an error


4. NYC Taxi Ride Case Study
Apply your new skills in temporal EDA, user-defined functions, and stored procedures to solve a business case problem. 
Analyze the New York City taxi ride dataset to identify average fare per distance, ride count, 
and total ride time for each borough on each day of the week. 
And which pickup locations within the borough should be scheduled for each driver shift?

4.1. Case study EDA & imputation
4.2. Use EDA to find impossible scenarios
4.3. SPs vs UDFs
4.4. Mean imputation
4.5. Hot Deck imputation
4.6. Case study UDFs
4.7. CREATE FUNCTIONs
4.8. Test FUNCTIONs
4.9. Formatting tools
4.10. Logical weekdays with Hot Deck
4.11. Format for Germany
4.12. Case study stored procedures
4.13. NYC Borough statistics SP
4.14. NYC Borough statistics results
4.15. Pickup locations by shift
4.16. Pickup locations by shift results
4.17. Congratulations!


