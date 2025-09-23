--Problem statement -Explore table called ipl_matches
--You need to create a table with below outcome -
--Team |  Matches Played  | Matches Toss Won | Matches Won | Matches where winning team also won the toss | Toss Win Rate(%) | Match Win Rate (%)

--I felt that directly putting the solution wouldn’t be a good approach, so I am breaking down the problem into smaller parts.
-- And my mentor asked me to do it using joins not union all.

--coloum 1 = Team (1. data from table_1.)
select team_1,count(match_key) as Match_played
from dbo.ipl_matches
group by team_1
order by team_1;
--2. data is taking from table_2
select team_2,count(match_key) as Match_played
from dbo.ipl_matches
group by team_2
order by team_2;
--Joining both.
select m.team_1 as team,
       count(distinct n.match_key) as Match_played
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1 
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--coloum 2 = calculating matches_won_toss from both the tables, one by one.
select team_1,
sum(case when toss_winner_code = team_1 then 1 else 0 end) as matches_toss_won
from dbo.ipl_matches
group by team_1
order by team_1;
--table_2
select team_2,
sum(case when toss_winner_code = team_2 then 1 else 0 end) as matches_toss_won
from dbo.ipl_matches
group by team_2
order by team_2;
--Joining
select m.team_1 AS team,
    count(distinct case when n.toss_winner_code = m.team_1 then n.match_key end) as matches_toss_won
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1 
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--coloum 3 = calculating match_won from both the table, one by one.
select team_1,
sum(case when winner = team_1 then 1 else 0 end) as match_won
from dbo.ipl_matches
group by team_1
order by team_1;
--table_2
select team_2,
sum(case when winner = team_2 then 1 else 0 end) as match_won
from dbo.ipl_matches
group by team_2
order by team_2;
--Joining both
select m.team_1 as team,
    count(distinct case when n.winner = m.team_1 then n.match_key end) as match_won
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1 
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--coloum 4 = calculating winner_team_who_won_toss_also
select team_1,
sum(case when winner = team_1 and toss_winner_code=team_1 then 1 else 0 end) as matches_with_toss_won
from dbo.ipl_matches
group by team_1
order by team_1;
--table_2
select team_2,
sum(case when winner = team_2 and toss_winner_code=team_2 then 1 else 0 end) as matches_with_toss_won
from dbo.ipl_matches
group by team_2
order by team_2;
--Joing both
select m.team_1 as team,
    count(distinct case when n.winner = m.team_1 and n.toss_winner_code= m.team_1  then n.match_key end) as matches_with_toss_won
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--coloum 5 = calculatign % of toss_winner
select team_1,
100.0*sum(case when toss_winner_code=team_1 then 1 else 0 end)/count(match_key) as Toss_win_per
from dbo.ipl_matches
group by team_1
order by team_1;
--table_2
select team_2,
100.0*sum(case when toss_winner_code=team_2 then 1 else 0 end)/count(match_key) as Toss_win_per
from dbo.ipl_matches
group by team_2
order by team_2;
--joining both
select m.team_1 as team,
    round(100.0*count(distinct case when n.toss_winner_code= m.team_1  then n.match_key end)/count(distinct n.match_key),2) as Toss_win_per
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--coloum 5 = calculatign % of winner
select team_1,
100.0*sum(case when winner = team_1 then 1 else 0 end)/count(match_key) as Matches_win_per
from dbo.ipl_matches
group by team_1
order by team_1;
--table_2
select team_2,
100.0*sum(case when winner=team_2 then 1 else 0 end)/count(match_key) as Matches_win_per
from dbo.ipl_matches
group by team_2
order by team_2;
--joining both
select m.team_1 AS team,
    round(100.0*count(distinct case when n.winner= m.team_1  then n.match_key end)/count(distinct n.match_key),2) as Matches_win_per
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

--This was my main output,after combining all the coloums.
select m.team_1 as team,
count(distinct n.match_key) as matches_played,
count(distinct case when n.toss_winner_code = m.team_1 then n.match_key end) as matches_toss_won,
count(distinct case when n.winner = m.team_1 then n.match_key end) as matches_won,
count(distinct case when n.winner = m.team_1 and n.toss_winner_code= m.team_1  then n.match_key end) as matches_with_toss_won,
round(100.0*count(distinct case when n.toss_winner_code= m.team_1  then n.match_key end)/count(distinct n.match_key),2) as Toss_win_per,
round(100.0*count(distinct case when n.winner= m.team_1  then n.match_key END)/count(distinct n.match_key),2) as Match_win_per
from dbo.ipl_matches m
join dbo.ipl_matches n 
     on m.team_1 = n.team_1
     or m.team_1 = n.team_2
group by m.team_1
order by m.team_1;

----------------------------------------------------------------------