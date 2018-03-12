--ruleid 40  this rule was under umbrella rule 1 and was made into a separate rule


select 
  analysis_id,
  achilles_heel_warning,
  rule_id,
  record_count
into @scratchDatabaseSchema@schemaDelim@heelPrefix_serial_hr_@hrNewId
from
(
  SELECT DISTINCT or1.analysis_id,
  	CAST(CONCAT('ERROR: Death event outside observation period, ', cast(or1.analysis_id as VARCHAR), '-', oa1.analysis_name, '; count (n=', cast(or1.count_value as VARCHAR), ') should not be > 0') AS VARCHAR(255)) AS ACHILLES_HEEL_warning,
  	40 as rule_id,
  	or1.count_value
  FROM @resultsDatabaseSchema.ACHILLES_results or1
  INNER JOIN @resultsDatabaseSchema.ACHILLES_analysis oa1
  	ON or1.analysis_id = oa1.analysis_id
  WHERE or1.analysis_id IN (510)
  	AND or1.count_value > 0
) Q
;