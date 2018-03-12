--ruleid 43 DQ rule
--looks at observation period data, if all patients have exactly one the rule alerts the user
--This rule is based on majority of real life datasets. 
--For some datasets (e.g., UK national data with single payor, one observation period is perfectly valid)


select 
  null as analysis_id,
  achilles_heel_warning,
  rule_id,
  null as record_count
into @scratchDatabaseSchema@schemaDelim@heelPrefix_serial_hr_@hrNewId
from
(
  select CAST('NOTIFICATION: 99+ percent of persons have exactly one observation period' AS VARCHAR(255))
   as achilles_heel_warning,
   43 as rule_id
  from
   (
   select 100.0*achilles_results.count_value/ct.total_pts as one_obs_per_perc
    from @resultsDatabaseSchema.achilles_results
  	join (select count_value as total_pts from @resultsDatabaseSchema.achilles_results r where analysis_id =1) as ct
  	where analysis_id = 113 and stratum_1 = '1'
    ) d
  where d.one_obs_per_perc >= 99.0
) Q
;