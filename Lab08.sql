set @avg_cred = (select avg(tot_cred) from student)

select * from student
where tot_cred > 2*@avg_cred


select * from department
where budget > (select avg(budget) from department)


delimiter #
create function avg_budget ()
	returns float deterministic
	begin
		declare value float;
		set value=(select avg(budget) from department);
		return value;
	end; #
delimiter ;


select * from department
where budget > avg_budget();


select dept_name from department as d
where count(select dept_name 
			from department as dd 
			where dd.budget 
			between d.budget and (select max(budget) from department)) < 3

select budget from department 
order by budget
limit 4



delimiter #
create procedure top_budg(in N int)
	begin
		select budget from department order by budget desc limit N;
	end;#
delimiter ;

create view temp as
(select a.id, a.name, a.dept_name, b.tot_cred
from ((select student.name, student.dept_name, student.id from student) as a left join
	(select student.id, student.tot_cred from student where id = 12345) as b on (a.id = b.id)))


delimiter #

create procedure add_student(in roll_no varchar(10))
begin

drop view if exists temp;
create view temp as
(select a.id, a.name, a.dept_name, b.tot_cred
from ((select student.name, student.dept_name, student.id from student) as a left join
	(select student.id, student.tot_cred from student where id = 00128) as b on (a.id = b.id)));

create user '00128'@localhost;

grant select on temp to roll_no@localhost;
end; #

delimiter ;






delimiter #
drop procedure if exists add_student #
create procedure add_student(in roll_no varchar(10))
begin

drop view if exists temp;
create view temp as
(select a.id, a.name, a.dept_name, b.tot_cred
from ((select student.name, student.dept_name, student.id from student) as a left join
	(select student.id, student.tot_cred from student where id = 00128) as b on (a.id = b.id)));

set @u_name = '11801';
create user @u_name@localhost;

grant select on temp to @u_name@localhost;
end; #

delimiter ;






delimiter #
drop procedure if exists add_student #
create procedure add_student(in roll_no varchar(10))
begin


set @s_name = (select name from student where id = roll_no);
set @user_id = concat("id", @s_name);
set @view_name = concat(@s_name, "view");

set @create_view = concat('create view ',@view_name,' as
	(select a.id, a.name, a.dept_name, b.tot_cred
		from ((select student.name, student.dept_name, student.id from student) as a 
	left join
	(select student.id, student.tot_cred from student where id = ',roll_no,') as b 
	on (a.id = b.id)));
');

set @user_addition = concat('create user ',@user_id,'@localhost;');
set @give_privilege = concat('grant select on ',@view_name,' to ',@user_id,'@localhost;');

prepare createView from @create_view;
prepare userAddition from @user_addition;
prepare givePrivilege from @give_privilege;

execute createView;
execute userAddition;
execute givePrivilege;

deallocate prepare createView;
deallocate prepare userAddition;
deallocate prepare givePrivilege;

end; #
delimiter ;
