--Checking all three tables
select * from ipl_batting;
select * from ipl_deliveries;
select * from ipl_matches;


select m.match_date as Match_date, d.playing_batsman_team as Team,
sum(d.runs_total) as Total_Runs_Scored,
--distinct count is used for counting uniqe value.
count(distinct d.bowling_over) as Overs_faced,
--For calculating run rate, the formulla is total runs/total overs.
round(sum(d.runs_total)/count(distinct d.bowling_over),2) as Run_Rate
from ipl_matches m
--joining another table for extracting some information
join ipl_deliveries  d on m.match_key=d.match_key 
where year(m.match_date)=2016 --Data where match date is 2016
group by m.match_date,d.playing_batsman_team
order by m.match_date,d.playing_batsman_team;