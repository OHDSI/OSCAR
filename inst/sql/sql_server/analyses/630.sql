-- 630	Number of procedure_occurrence records by procedure_concept_id, procedure start month, and observation_period look back (days).
--      For each procedure_concept_id, year_month combination, stratum_4 represents the proportion of records with at least as many look back 
--      days as the current row.

--HINT DISTRIBUTE_ON_KEY(stratum_1)
with lookback as (
select po.procedure_concept_id,
       substring(replace(datefromparts(year(po.procedure_date),month(po.procedure_date),1),'-',''),1,6) as year_month,
       datediff(d,op.observation_period_start_date,po.procedure_date) as lookback_days,
       count_big(*) as count_value
  from @cdmDatabaseSchema.observation_period op
  join @cdmDatabaseSchema.procedure_occurrence po
    on po.person_id = op.person_id
 where op.observation_period_start_date <= po.procedure_date
 group by po.procedure_concept_id,
          substring(replace(datefromparts(year(po.procedure_date),month(po.procedure_date),1),'-',''),1,6),
          datediff(d,op.observation_period_start_date,po.procedure_date)
) 
select 630 as analysis_id,
       cast(procedure_concept_id as varchar(255)) as stratum_1,
       cast(year_month           as varchar(255)) as stratum_2,
       cast(lookback_days        as varchar(255)) as stratum_3,
       cast(1.0*sum(count_value)over(partition by procedure_concept_id,year_month order by lookback_days desc)/
	            sum(count_value)over(partition by procedure_concept_id,year_month) as varchar(255)) as stratum_4,
       cast(null                 as varchar(255)) as stratum_5,
       count_value
  into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_630
  from lookback; 