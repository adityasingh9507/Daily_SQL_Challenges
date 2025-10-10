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

--STEP 8 — Sorting the results
order by m.match_date,d.playing_batsman_team;
