-- 712	Number of drug exposure records with invalid provider_id

--HINT DISTRIBUTE_ON_KEY(analysis_id)
select 712 as analysis_id,  
	null as stratum_1, null as stratum_2, null as stratum_3, null as stratum_4, null as stratum_5,
	COUNT_BIG(de1.PERSON_ID) as count_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_712
from
	@cdmDatabaseSchema.drug_exposure de1
	left join @cdmDatabaseSchema.provider p1
	on p1.provider_id = de1.provider_id
where de1.provider_id is not null
	and p1.provider_id is null
;
