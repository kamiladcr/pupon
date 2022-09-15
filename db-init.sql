drop schema public cascade;
create schema public;

create table test (
  datetime timestamp,
  observation int
);

insert into test values (
    (select now()),
    10
);
