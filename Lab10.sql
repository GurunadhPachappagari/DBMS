create or replace event test 
on schedule every 1 second 
starts current_timestamp
ends current_timestamp+interval 1 second
do
update student set tot_cred=tot_cred+1;


create event rise_budg
	on schedule at current_timestamp + interval 1 minute
	do
	update department set budget = budget*1.05;


show create event rise_budg\G;

alter event rise_budg
	on schedule every 1 minute
	starts current_timestamp
	ends current_timestamp + interval 5 minute
	do
	update department set budget = budget + 100;



select * from department where budget > 50000

SELECT * FROM INFORMATION_SCHEMA.PROFILING WHERE QUERY_ID=34635;

select * from student where name = 'wood';


delimiter #

CREATE TRIGGER foo
BEFORE INSERT ON takes
FOR EACH ROW
BEGIN
  IF NEW.grade not in (select distinct(grade) from takes)
  THEN
   SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: This grade is not allowed to insert';
  END IF;
END;#
    

delimiter ;
