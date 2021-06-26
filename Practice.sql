-- Lab 03

-- creating a table with some attributes

create table books
	(name varchar(30) primary key,
	ssid varchar(30));


-- add attribute

alter table books add autho varchar(15);


-- delete a table or drop a table

drop table books;


-- insert into table or insert a record into a table

insert into student values ('1029', 'Gurunadh', 'Comp. Sci.', 100);

-- change a record or update a value 

update student set tot_cred = 80 where id = 1029;

-- delete a record

delete from student where id = 1029;

-- conditional query

update student set tot_cred = tot_cred + 10
	where tot_cred < 100 and dept_name = 'Comp. Sci.';

-- conditional query

select id from teaches 
	where (id in (select id from teaches where year = 2009)) and 
			(id not in (select id from teaches where year <> 2009))

-- toppers in each department

select * from student 
	where (dept_name, tot_cred) in 
	(select dept_name, max(tot_cred)
		from student 
		group by dept_name)

-- conditional

select title from course 
where course_id in (select prereq_id from prereq);

-- conditional

select * from instructor 
where id in (select i_id from advisor 
			where s_id in (select id from student where dept_name = 'Comp. Sci.')
			)

-- conditional

select count(id), dept_name, avg(salary)
from instructor 
group by dept_name

-- insert

insert into table student values ('1029', 'Gurunadh', 'Comp. Sci.', 12);

-- between ascending descending

select * from student where tot_cred between 12 and (select max(tot_cred) from student)
order by tot_cred desc;

-- delete a record from table

delete from student where id = 1029;

-- regular expression

select sum(salary) from instructor
where id in (select i_id from advisor) and name regexp '^k' 

-- string operations concatenations

select concat_ws("_", upper(substr(name, 1, 4)), substr(dept_name, 1, 4)) as name_dept
from student

-- regular expression

-- cross join 
-- cross join everything (new nulls are not possible)

-- outer join 
-- join on some condition and display records with null when they dont match
-- (nulls are possible both sides)

-- inner join 
-- join without nulls on some condition

-- left join
-- join with nulls right side or join with all records on left side

-- right join
-- join with nulls in left side or join with all records on right side


select * from course cross join section
where course.dept_name = 'Comp. Sci.' and section.building regexp 'ta|at|ka' and section.course_id regexp 'cs'


-- conditional

select name, salary 
from instructor
where dept_name = 'Biology' or dept_name = 'Finance'
order by salary desc;

-- null check
 select * from instructor where salary is not null;

 -- concatenation

 select name, concat_ws("",upper(substr(name, 1, 1)), lower(substr(name, 2)),lower(name), lower(name))
 from student;


-- 
select distinct student.name, takes.grade, length(name) as length 
from student natural join takes 
where takes.grade in ('A', 'A+', 'A-')

-- Lab 05

select count( distinct student.id )
	from student join 
		takes join 
			teaches join instructor 
			on teaches.id = instructor.id 
		on takes.course_id = teaches.course_id 
	on student.id = takes.id
	where instructor.id = 10101


select count(distinct student.id) from student 
where id in (
	select id from takes
	where course_id in (
		select course_id from teaches
			where id = 10101
		)
	)

select * from instructor where salary > any 
(select salary from instructor)
and dept_name = 'Biology'


select *
from instructor as I
where (select count(id) from instructor as J where I.salary < J.salary) = 1


select * from student
where (dept_name, tot_cred) in 
(select dept_name, max(tot_cred) from student group by dept_name having count(id) > 1)


-- constraints

-- domain constraints - 		1. inserting a string at the place of an int
-- 							2. insertinga value which disagree with check
-- entity integr. constr-		1. inserting null at the place of not null  
-- 							2. inserting null at the place of primary key

-- referential integr. constr 	1. inserting a non existing attribute

-- key constraints				1. inserting two records with same primary key


-- backup

mysqldump -u root -p --no-data university > mysql_without_data.sql


mysqldump -u root -p  university > mysql_with_data.sql


create database university_midsem
mysql -u root -p  university_midsem < mysql_with_data.sql

create database some_without_data
mysql -u root -p  some_without_data < mysql_without_data.sql


-- drop database

drop database some_with_data;
drop database some_without_data;


-- join
create view student_advisor as(
select student.name as s_name,
instructor.name as i_name
from student left join 
		(advisor join instructor on advisor.i_id = instructor.id)
	on student.id = advisor.s_id
)

-- conditional
select id, name from instructor
where id in
(select id from teaches
group by id
having count(course_id) > 1)


select host, user from mysql.user

create user 'guru'@localhost;

grant all privileges on *.* to 'guru'@localhost with grant option;



create table name6 (name varchar(10), dept_name varchar(30))

Insert into name6 (name, dept_name)
(Select name, dept_name from instructor where salary > 60000)

create view rank_stud as
(select * from student order by tot_cred)

update student set tot_cred = 20 where id = 98988


select dept_name
from instructor
group by dept_name
having (avg(salary) > (select avg(salary) from instructor) )


select title from course
where course_id in
(select course_id
from prereq
where substr(course_id, 1, 3) <> substr(prereq_id, 1, 3))

select name, dept_name
from instructor
where id in
(select i_id from advisor
group by i_id
having count(s_id) = 2)


select name
into @onlyname6
from instructor;



insert into onlyname6(name, dept_name)
	select name, dept_name from instructor

-- -------------------------------------------------------------------------------------------------

					-- End Sem

-- -------------------------------------------------------------------------------------------------

-- event scheduler

show variables where variable_name = 'event_scheduler'

set global event_scheduler = 1

-- event 

create event incr_budg
	on schedule at current_timestamp + interval 1 minute
do
	update department set budget = budget*(1.05);

-- pretty printing

show create event incr_budg \G;


-- repetitive event

alter event incr_budg
on schedule every 1 minute
starts current_timestamp 
ends current_timestamp + interval 5 minute
do
update department set budget = budget + 1000


-- profiling

set profiling = 1

-- processlist

show processlist

-- limit

select * from department where budget > 50000 limit 5;
select * from student where name regexp 'Wood'


-- create trigger 
delimiter #
create trigger foo1
	before insert on takes 
for each row 
begin 
	if new.grade not in (select distinct(grade) from takes)
	then signal sqlstate '02000' set MESSAGE_TEXT = 
				'warning: you are trying to insert an unavailable grade';
	end if;
end;#
delimiter ;

-- 
insert into takes values ('1000', '239', '1', 'Fall', 2022, 'X');
-- 

-- -----------------------------------------------------------------------------------------------

-- Assignment - 8

-- -----------------------------------------------------------------------------------------------

-- variabes 

set @avg_cred = (select avg(tot_cred) from student);

-- use variable

select * from student where tot_cred > 2*@avg_cred

-- -----------------------------------------------------------------------------------------------

select * from department
where budget > (select avg(budget) from department)

-- Functions
delimiter #
create function avg_budg()
returns float deterministic
begin
declare avg_b float;
set avg_b = (select avg(budget) from department);
return avg_b;
end; #
delimiter ;

-- call function

select * from department where budget > avg_budg();


-- Procedure
delimiter #
create procedure top_budg(in N int )
	begin
		select budget from department order by budget desc limit N;
	end;#
delimiter ;


-- Creating views and restricting access on grades to students
delimiter #
create procedure add_student(in roll_no int)
begin
	set @user_name = (select name from student where id = roll_no);
	set @view_name = concat(@user_name, "view");


	set @create_view = concat("create view ",@view_name ," as (
						select a.id, a.name, a.dept_name, b.tot_cred
						from (select * from student) as a
							left join (select * from student where id = ",roll_no,") as b
							on (a.id = b.id)
						);" );
	set @create_user = concat("create user ", @user_name, "@localhost ;");
	set @grant_permission = concat("grant select on ",@view_name ," to ", @user_name, "@localhost;");


	prepare createView from @create_view;
	prepare createUser from @create_user;
	prepare grantPermission from @grant_permission;

	execute createView;
	execute createUser;
	execute grantPermission;

	deallocate prepare createView;
	deallocate prepare createUser;
	deallocate prepare grantPermission;

end; #
delimiter ;


-- -------------------------------------------------------------------------------------------------

--  Assignment 7

-- -------------------------------------------------------------------------------------------------
set autocommit = 0;

commit;

rollback;

-- user and grants

create user temp1@localhost;

grant select on student to temp1@localhost;

mysql -u temp1

-- no semicolon in the above case -^


-- roles

create role dummy;

grant select on student to dummy;

grant update on student to dummy;

grant dummy to temp1;

mysql -u temp1

set role dummy;

-- --------------------------

create user abc

grant all on *.* to abc with grant option

create user subtemp;

grant select on student to subtemp;

show grants;




-- -------------------------------------------------------------------------------------------------

--  Assignment 6

-- -------------------------------------------------------------------------------------------------

select student.id as s_id,
	student.name as s_name,
	instructor.id as i_id,
	instructor.name as i_name,
	course.course_id as course_id,
	course.title as course
from 
student 
join takes on student.id = takes.id
join course on takes.course_id = course.course_id
join teaches on (teaches.course_id = takes.course_id and
				takes.sec_id = teaches.sec_id and
				takes.semester = teaches.semester and
				takes.year = teaches.year)
join instructor on instructor.id = teaches.id


-- -

select student.name,instructor.name
from student
join advisor on student.id = advisor.s_id
join instructor on advisor.i_id = instructor.id

-- view

create view student_advisor as
select student.name as s_name,instructor.name as i_name
from student
join advisor on student.id = advisor.s_id
join instructor on advisor.i_id = instructor.id

-- 

select student.name as s_name,
	instructor.name as i_name
from student 
left join advisor on student.id = advisor.s_id
left join instructor on advisor.i_id = instructor.id

-- 

select instructor.name, instructor.salary 
from advisor
join instructor on advisor.i_id = instructor.id
where instructor.dept_name in  
(select distinct(dept_name) from instructor
group by (dept_name)
having sum(salary) > 100000)

-- -----------------------------------------------------------------------------------------

-- Assignemnt 3

-- -----------------------------------------------------------------------------------------

create table book_from_library (
	id varchar(30) not null,
	name varchar(100) not null,
	primary key (id)
);

alter table book_from_library add author varchar(30);

drop table book_from_library

insert into student values ('0129', 'Gurunadh', 'Comp. Sci.', 95)

update student set tot_cred = 90 where id = 0129

delete from student where id = "0129";

insert into student values  ("00128", "Zhang","Comp. Sci.", 102)


update student set tot_cred = tot_cred + 10
where dept_name = "Comp. Sci." and tot_cred < 100

select * from teaches where (id in (select id from teaches where year = 2009))
							and id not in (select id from teaches where year <> 2009)


-- finding topper
select * from student
where (dept_name, tot_cred) in 
(select dept_name, max(tot_cred)
from student
group by dept_name)

select distinct(prereq.prereq_id) from 
prereq join course on course.course_id = prereq.prereq_id

select * from instructor
where id in (select i_id from advisor where s_id in 
				(select id from student where dept_name = "Comp. Sci.")
			)

select dept_name, count(id), sum(salary)
from instructor
group by dept_name

select dept_name from instructor
where id in (select id from teaches where year = 2010)
group by dept_name
having avg(salary) > 50000

insert into student values ("1029", "Gurunadh", "Comp. Sci.", 12)

select * from student 
where tot_cred between (select tot_cred from student where id = "1029") and (select max(tot_cred) from student)
order by tot_cred desc

select sum(salary)
from instructor
where name regexp "^k" and id in (select i_id from advisor)

select concat_ws("_", substr(upper(name), 1, 4), substr((dept_name), 1, 4)) as concatenated_string
from student


select * from section cross join course
where section.building regexp "ta|at|ka"
and section.course_id regexp "CS"
and course.dept_name = "Comp. Sci."

select * from instructor
where dept_name = 'Finance' or dept_name = 'Biology'
order by salary desc;


select name, concat(upper(substr(name, 1, 1)), substr(lower(name), 2, 3), lower(substr(name, 1, 4)), lower(substr(name, 1, 4)))
from student

select name, length(name),

select distinct(student.id), student.name, length(student.name) 
from takes 
join student on takes.id = student.id
where grade = "A" or grade = "B" or grade = "A-"

select * from course
where title regexp "comp"

create table table1 
	( name varchar(30),
		age int,
		id varchar(15),
		primary key (id),
		check age >= 13
	)

create table table2 
	( id varchar(30),
		fav_place varchar(15),
		primary key (fav_place),
		foreign key (id) references table1(id) on delete cascade
	)

mysqldump -u root -p  --no-data university > no_data_university.sql
mysqldump -u root -p  university > data_university.sql

mysql -u root -p with_data < structure_with_data.sql
mysql -u root -p without_data < structure_without_data.sql


select * from takes
where (course_id, sec_id, semester, year) in (select course_id, sec_id, semester, year from teaches where id = 10101)


select * from instructor where dept_name = "Biology" and salary > (select min(salary) from instructor )

select dept_name, count(distinct(id))
from instructor
group by dept_name


select * from instructor as A
where (select count(id) from instructor as B where B.salary > A.salary) = 1

-- --------------------------------------------------------------------------------

select instructor.name, instructor.id, instructor.dept_name, instructor.salary from 
(select distinct advisor.i_id from advisor) as v_table
join instructor on v_table.i_id = instructor.id
where dept_name in (select dept_name from instructor group by dept_name having sum(salary) > 100000)


select instructor.name, 
	instructor.id, 
	teaches.course_id, 
	section.sec_id,
	section.building,
	section.semester,
	section.room_number
from instructor 
join teaches on instructor.id = teaches.id
join section on teaches.course_id = section.course_id 
			and teaches.sec_id = section.sec_id 
			and teaches.semester = section.semester
where teaches.year = 2009


select student.id,
student.name,
takes.course_id
from student
join takes on student.id = takes.id
where takes.year = 2009 and takes.grade = "A"

select id from teaches
group by id
having count(id) > 1

select * from instructor where id not in
(select id from teaches where year = 2010)

select department.dept_name,
		department.building
from department join
(select building from department
group by building
having count(dept_name) > 1
) as v_table on v_table.building = department.building


select student.name, instructor.name
from advisor
join student on advisor.s_id = student.id
join instructor on instructor.id = advisor.i_id
where student.id in (select id from takes where year = 2010)
and instructor.id in (select id from teaches where year = 2010)
and (student.id, instructor.id) in (select s_id, i_id from advisor)
