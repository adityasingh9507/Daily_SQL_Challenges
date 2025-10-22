--Checking all three tables
select * from ipl_batting;
select * from ipl_deliveries;
select * from ipl_matches;

--STEP 1 -In this Task we are considring two tables.(ipl_deliveries,ipl_matches)
select m.match_date as Match_date, d.playing_batsman_team as Team,

--STEP 3 — Calculating Total Runs Scored
sum(d.runs_total) as Total_Runs_Scored,

--STEP 4 — Calculating Overs Faced
round(sum(case when d.extras_type in ('WIDE', 'NO BALL', 'NO-BALL', 'NB') then 0 else 1 end) / 6.0,2) AS Overs_Faced,

--STEP 5 - Calculating Run Rate(Run Rate=Total Runs * 6 / Total Legal balls)​
round(sum(d.runs_total)*6.0/sum(case when d.extras_type in('WIDE', 'NO BALL', 'NO-BALL', 'NB') THEN 0 ELSE 1 end),2) as run_rate

from ipl_matches m
join ipl_deliveries  d on m.match_key=d.match_key 
--STEP 6 — Filtering for IPL 2016
where year(m.match_date)=2016

--STEP 7 — Grouping the data
group by m.match_date,d.playing_batsman_team

--STEP 8 — Sorting the result
order by m.match_date,d.playing_batsman_team;





--Write an SQL query to display Sachin’s monthly performance summary, including:
--1.Total runs and total balls faced per month.
--2.Batting average (runs/balls * 100).
--3.Rank months by total runs (highest first).
--4.Identify performance level using CASE WHEN:
--      "Outstanding" if total runs ≥ 300
--      "Good" if total runs between 200–299
--        "Average" otherwise
--5.Include the running total of runs month-by-month (using window function).
--6.Display only months from 1998.
----------------------------------------------------------

-- creating a common table expression (cte) to summarize sachin's monthly runs and balls
with monthly_summary as (
select
datepart(year, mtch_date) as match_year,
datepart(month, mtch_date) as match_month,
sum(runs) as total_runs,
sum(balls) as total_balls
from sachin_scores
where datepart(year, mtch_date) = 1998
group by datepart(year, mtch_date), datepart(month, mtch_date)
)
-- now calculate performance details using the summarized data
select
match_year,
match_month,
total_runs,
total_balls,
-- calculate strike rate as (runs / balls) * 100
round((total_runs * 100.0 / total_balls), 2) as strike_rate,
-- categorize performance based on total runs using case when
case when total_runs >= 300 then 'outstanding'
      when total_runs between 200 and 299 then 'good'
      else 'average' end as performance_level,
-- calculate cumulative (running) total of runs month by month
sum(total_runs) over (order by match_month) as running_total_runs,
-- rank each month based on total runs (highest first)
rank() over (order by total_runs desc) as month_rank
from monthly_summary
order by match_month;
