-- Q01

-- select student.name as student_name, 
-- 		student.dept_name, 
-- 		course.course_id, 
-- 		course.title as course_title,
-- 		teaches.id as teacher_id,
-- 		instructor.name as teacher_name
-- from (student join 
-- 	(
-- 		course join 
-- 		(
-- 			takes join 
-- 			(
-- 				teaches join instructor on teaches.id = instructor.id
-- 			)
-- 			on (takes.course_id = teaches.course_id 
-- 			and takes.year = teaches.year 
-- 			and takes.semester = teaches.semester 
-- 			and takes.sec_id = teaches.sec_id)
-- 		) 
-- 		on (takes.course_id = course.course_id)
-- 	)
-- 	on (student.id = takes.id)
-- 	)


-- Q02 
-- a

-- select student.name as student_name,
-- 		instructor.name as instructor_name
-- from (student join 
-- 	(	
-- 		advisor join instructor on (instructor.id = advisor.i_id)
-- 	) 
-- 	on (student.id = advisor.s_id))


-- b
-- create view student_advisor as 
-- (select student.name as student_name,
-- 		instructor.name as instructor_name
-- from (student join 
-- 	(	
-- 		advisor join instructor on (instructor.id = advisor.i_id)
-- 	) 
-- 	on (student.id = advisor.s_id))
-- )


-- c

-- update student_advisor
-- set student_name = "Gurunadh"
-- where instructor_name = "Singh"

-- d

-- delete from student_advisor
-- where student_name = "Gurunadh"

-- e

-- insert into student_advisor (student_name) values ("Gurunadh")
-- insert into student_advisor (instructor_name) values ("Advisor1")

-- Q3

-- select student.name as student_name,
-- 		instructor.name as instructor_name
-- from (student left join 
-- 	(	
-- 		advisor join instructor on (instructor.id = advisor.i_id)
-- 	) 
-- 	on (student.id = advisor.s_id))


-- Q4

-- a

-- create view advisor_dept_budg as
-- (select instructor.id as advisor_id,
-- 		instructor.name,
-- 		instructor.dept_name,
-- 		instructor.salary
-- from instructor join 
-- 	(select distinct(advisor.i_id) as i_id  from advisor) as virtual_table 
-- 	on virtual_table.i_id = instructor.id
-- where instructor.dept_name in (select dept_name from instructor 
-- 						group by dept_name 
-- 						having sum(instructor.salary) > 100000)
-- )


-- b

-- update instructor
-- set salary = salary + 0.1 * salary 


-- Q5

-- create view instructor_section as
-- (
-- 	select instructor.id,
-- 		instructor.name,
-- 		section.course_id,
-- 		section.sec_id,
-- 		section.semester,
-- 		section.building,
-- 		section.room_number
-- 	from section natural join 
-- 		(
-- 			teaches natural join instructor
-- 		)
-- 	where section.year = 2009
-- )




-- select distinct
-- (
-- 	select instructor.id,
-- 	instructor.name,
-- 	teaches.course_id,
-- 	teaches.sec_id,
-- 	teaches.semester,
-- 	department.building,
-- 	classroom.room_number

-- 	from teaches join 
-- 		(
-- 			instructor join 
-- 			(
-- 				department join classroom on department.building = classroom.building
-- 			)
-- 			on instructor.dept_name = department.dept_name
-- 		)
-- 		on instructor.id = teaches.id
-- 	where teaches.year = 2009
-- )


-- Q6

-- select student.id as student_id,
-- 	student.name as student_name,
-- 	student.dept_name
-- from student
-- where student.id not in (select id from takes)


-- Q7
-- create view a_grades as 
-- select takes.id as student_id,
-- 	student.name as student_name,
-- 	takes.course_id
-- from student natural join takes
-- where takes.year = 2009 and takes.grade = 'A'


-- Q08

-- select instructor.id as instructor_id,
-- 	instructor.name as instructor_name 
-- from instructor
-- where id in 
-- (
-- 	select distinct(id) from teaches
-- 	where id in (select id from teaches group by id having count(id) > 1)
-- )

-- Q09

-- create view free_faculty as 
-- (
-- select instructor.id as instructor_id,
-- 	instructor.name as instructor_name
-- from instructor join
-- ( select distinct(instructor.id) 
-- from instructor left join teaches on (instructor.id = teaches.id and teaches.year <> 2010)
-- ) as virtual_table
-- on (instructor.id = virtual_table.id)
-- )

-- select id , name as instructor_name 
-- from instructor
-- where id not in (select id from teaches where year = 2010) 

select student.id, student.name from student
where id 
group by 

-- Q10

-- select department.dept_name,
-- 	department.building 
-- from department inner join (select department.building from department group by building having count(dept_name) > 1) 
-- 				as virtual_table
-- on department.building = virtual_table.building


-- Q11


-- select student.name as student_name, instructor.name as instructor_name
-- from student,instructor
-- where (student.id, instructor.id) in
-- (
-- select student.id, instructor.id
-- from (student natural join takes), (instructor natural join teaches)
-- where student.id in (select id from takes where year = 2010) and
-- 	instructor.id in (select id from teaches where year = 2010)
-- 	and (student.id, instructor.id) in (select s_id, i_id from advisor)
-- )