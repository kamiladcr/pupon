drop schema public cascade;
create schema public;

create table test (
  datetime timestamp,
  observation int
);

drop view observation_per_month;
create view observation_per_month as
  select
    to_char(datetime, 'YYYY') as year,
    to_char(datetime, 'MM') as month,
    avg(observation) as value
    from test
    group by year, month
;

-- insert into test values (
--     (select now()),
--     10
-- );
