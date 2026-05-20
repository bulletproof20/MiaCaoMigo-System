-- =========================================================
-- MANUAL VALIDATION — MODULE 2 — EXPLORATORY QUERIES
-- =========================================================
--
-- TYPE:     03_Manual (human-inspected result sets)
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RUN:      Execute sections individually in psql or GUI client
-- =========================================================

-- Animals with species and breed
select
    a.id_ani,
    a.nam_ani,
    s.nam_spc,
    b.nam_bre,
    a.sta_ani
from animal a
join species s on a.id_spc = s.id_spc
left join breed b on a.id_bre = b.id_bre
order by a.id_ani;

-- Animals available for adoption (internal status)
select id_ani, nam_ani, sta_ani
from animal
where sta_ani = 'Interno';

-- Full history for animal 3 (ownership + concessions)
select
    'Ownership' as event_type,
    o.sta_dat_own as start_date,
    o.end_dat_own as end_date,
    'Client ' || c.id_cli::text as involved,
    o.mot_own as reason
from ownership o
join client c on o.id_cli = c.id_cli
where o.id_ani = 3
union all
select
    'Concession',
    con.dat_con,
    null,
    'Entity ' || ee.nam_ext_ent,
    con.mot_con
from concession con
join external_entity ee on con.id_ext_ent = ee.id_ext_ent
where con.id_ani = 3
order by start_date desc;

-- Active ownerships
select
    o.id_own,
    a.nam_ani,
    c.id_cli,
    o.sta_dat_own
from ownership o
join animal a on o.id_ani = a.id_ani
join client c on o.id_cli = c.id_cli
where o.end_dat_own is null;

-- Deliveries with involved employees
select
    d.id_del,
    a.nam_ani,
    d.res_loc_del,
    string_agg(e.id_emp::text, ', ') as employee_ids
from delivery d
join animal a on d.id_ani = a.id_ani
join delivery_employee de on d.id_del = de.id_del
join employee e on de.id_emp = e.id_emp
group by d.id_del, a.nam_ani, d.res_loc_del
order by d.id_del;
