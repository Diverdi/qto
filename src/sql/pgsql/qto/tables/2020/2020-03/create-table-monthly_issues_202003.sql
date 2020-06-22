-- DROP TABLE IF EXISTS monthly_issues_202003 ; 

SELECT 'create the "monthly_issues_202003" table'
; 
   CREATE TABLE monthly_issues_202003 (
      guid           UUID NOT NULL DEFAULT gen_random_uuid()
    , id             bigint UNIQUE NOT NULL DEFAULT cast (to_char(current_timestamp, 'YYMMDDHH12MISS') as bigint) 
    , category_guid UUID NOT NULL DEFAULT '70724562-d83c-446e-94cf-58ced84f3a0e'
    , issues_status_guid UUID NOT NULL DEFAULT 'cb989a14-d0b8-46e4-b2cc-5e2a974b5d29'
    , prio           integer NOT NULL DEFAULT 0
    , name           varchar (100) NOT NULL DEFAULT 'name...'
    , description    varchar (4000)
    , owner          varchar (20) NOT NULL DEFAULT 'unknown'
    , type           varchar (30) NOT NULL DEFAULT 'task'
    , update_time    timestamp DEFAULT DATE_TRUNC('second', NOW())
    , CONSTRAINT pk_monthly_issues_202003_guid PRIMARY KEY (guid)
    ) WITH (
      OIDS=FALSE
    );

create unique index idx_uniq_monthly_issues_202003_id on monthly_issues_202003 (id);

-- the rank search index
CREATE INDEX idx_rank_monthly_issues_202003 ON monthly_issues_202003
USING gin(to_tsvector('English', name || ' ' || description || 'owner')); 


SELECT 'Display the columns of the just created table'
; 

   SELECT attrelid::regclass, attnum, attname
   FROM   pg_attribute
   WHERE  attrelid = 'public.monthly_issues_202003'::regclass
   AND    attnum > 0
   AND    NOT attisdropped
   ORDER  BY attnum
   ; 

--The trigger:
CREATE TRIGGER trg_set_update_time_on_monthly_issues_202003 BEFORE UPDATE ON monthly_issues_202003 FOR EACH ROW EXECUTE PROCEDURE fnc_set_update_time();

SELECT tgname
FROM pg_trigger
WHERE NOT tgisinternal
AND tgrelid = 'monthly_issues_202003'::regclass;

