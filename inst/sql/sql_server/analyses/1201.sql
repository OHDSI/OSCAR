-- 1201	Number of visits by place of service

--HINT DISTRIBUTE_ON_KEY(analysis_id)
select 1201 as analysis_id,  
	CAST(cs1.place_of_service_concept_id AS VARCHAR(255)) as stratum_1, 
	null as stratum_2, null as stratum_3, null as stratum_4, null as stratum_5,
	COUNT_BIG(visit_occurrence_id) as count_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_1201
from @cdmDatabaseSchema.visit_occurrence vo1
	inner join @cdmDatabaseSchema.care_site cs1
	on vo1.care_site_id = cs1.care_site_id
where vo1.care_site_id is not null
	and cs1.place_of_service_concept_id is not null
group by cs1.place_of_service_concept_id;
