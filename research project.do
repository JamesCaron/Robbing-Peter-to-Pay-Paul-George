cd "C:\Users\james\Downloads\SUU Fall 2019\Econometrics\research project NEW"

* first I need to convert salary, salary_cap, & team_total_salary to 2018 dollars
import delimited "salaries_df.csv", clear
sort year
save salaries_dta, replace
import delimited "cpi.csv", clear
sort year
merge year using salaries_dta
keep if _merge ==3
gen salary_adj = salary * 251.07/cpi
gen salary_cap_adj = salary_cap * 251.07/cpi
gen tt_salary_adj = team_total_salary * 251.07/cpi

* I need to create a new variable that is a 1 for non-starting players and 0 for starting players
gen bench_player = 0
replace bench_player = 1 if starting_five == 0
 
* summary statistics for salary variation
sum salary_adj salary_cap_adj tt_salary_adj
gen salary_in_millions = salary_adj/1000000
histogram salary_in_millions, frequency normal

* simple model
gen six_perc_inc = 0
replace six_perc_inc = 1 if sal_cap_perc_inc > .06
gen top_player_int = top_player*six_perc_inc
gen ln_salary_adj = ln(salary_adj)
reg ln_salary_adj six_perc_inc top_player top_player_int
outreg2 using "Results.xls", replace se bracket

* New Variables
egen TEAM=group(team)
egen YEAR=group(season)
gen top2_player_int = top_two_player*six_perc_inc
gen top3_player_int = top_three_player*six_perc_inc
gen starting_five_int = starting_five*six_perc_inc

* proving that each of the player rank variables have significant difference in salary (not from each other, just that they aren't worthless variables)
ttest salary_adj, by (top_player top_two_player)
ttest salary_adj, by (top_two_player)
ttest salary_adj, by (top_three_player)
ttest salary_adj, by (starting_five)


* Adding More player ranks
reg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int 
outreg2 using "Results.xls", append se bracket
* Adding holdout year
reg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int holdout_dummy
outreg2 using "Results.xls", append se bracket
* Adding player year
reg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int holdout_dummy player_year
outreg2 using "Results.xls", append se bracket
* Adding CPA Controls
reg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int holdout_dummy player_year cpa_two cpa_three cpa_four cpa_five cpa_six 
outreg2 using "Results.xls", append se bracket
* Adding year
reg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int holdout_dummy player_year cpa_two cpa_three cpa_four cpa_five cpa_six i.YEAR
outreg2 using "Results.xls", append se bracket
* Final Model
areg ln_salary six_perc_inc top_player top_player_int top_two_player top2_player_int top_three_player top3_player_int starting_five starting_five_int holdout_dummy player_year cpa_two cpa_three cpa_four cpa_five cpa_six i.YEAR, absorb(TEAM)
outreg2 using "Results.xls", append se bracket

