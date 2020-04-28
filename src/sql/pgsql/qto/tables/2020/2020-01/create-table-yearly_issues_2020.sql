-- DROP TABLE IF EXISTS yearly_issues_2020 ; 

SELECT 'create the "yearly_issues_2020" table'
; 
CREATE TABLE public.yearly_issues_2020 (
    guid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    id bigint DEFAULT (to_char(CURRENT_TIMESTAMP, 'YYMMDDHH12MISS'::text))::bigint NOT NULL,
    category_guid uuid DEFAULT '70724562-d83c-446e-94cf-58ced84f3a0e'::uuid NOT NULL,
    issues_status_guid uuid DEFAULT 'cb989a14-d0b8-46e4-b2cc-5e2a974b5d29'::uuid NOT NULL,
    prio integer DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT 'name ...'::character varying NOT NULL,
    description character varying(4000),
    app_users_guid uuid DEFAULT public.gen_random_uuid(),
    type character varying(30) DEFAULT 'task'::character varying NOT NULL,
    update_time timestamp without time zone DEFAULT date_trunc('second'::text, now())
);

create unique index idx_uniq_yearly_issues_2020_id on yearly_issues_2020 (id);



SELECT 'show the columns of the just created table'
; 

   SELECT attrelid::regclass, attnum, attname
   FROM   pg_attribute
   WHERE  attrelid = 'public.yearly_issues_2020'::regclass
   AND    attnum > 0
   AND    NOT attisdropped
   ORDER  BY attnum
   ; 

--The trigger:
CREATE TRIGGER trg_set_update_time_on_yearly_issues_2020 
   BEFORE UPDATE ON yearly_issues_2020 
   FOR EACH ROW EXECUTE PROCEDURE fnc_set_update_time();

select tgname
from pg_trigger
where not tgisinternal
and tgrelid = 'yearly_issues_2020'::regclass;

