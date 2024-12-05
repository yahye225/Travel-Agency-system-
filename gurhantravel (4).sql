-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 30, 2023 at 02:02 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gurhantravel`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `account_sp` (`_name` VARCHAR(100), `_date` DATE, `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM account WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO account(name,user_id,date)
VALUES(_name,_user_id,_date);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `booking_sp` (IN `_customer_id` INT, IN `_destination_id` INT, IN `_price` DOUBLE, IN `_date` DATE, IN `_user_id` INT)   BEGIN
SELECT name INTO @Name FROM customers WHERE id=_customer_id;
IF EXISTS(SELECT customer_id FROM booking WHERE customer_id = _customer_id AND destination_id = _destination_id)THEN
SELECT concat('danger|',@Name,' Horay Ayaa Loo Diwan Galiyay');

ELSE
INSERT INTO booking(customer_id,destination_id,price,date,user_id)
VALUES(_customer_id,_destination_id,_price,_date,_user_id);
SELECT concat('success|',@Name,' Waala Diwan Galiyay');

END if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `branch_sp` (`_name` VARCHAR(100), `_tell` VARCHAR(100), `_address` VARCHAR(100), `_admin` VARCHAR(100), `_admintell` VARCHAR(100), `_date` DATE)   BEGIN

if EXISTS(SELECT * FROM branch WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');
ELSE
INSERT INTO branch(name,tell,address,admin,admintell,date)
VALUES(_name,_tell,_address,_admin,_admintell,_date);
SELECT concat('success|',_name,' waala diwan galiyay');
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_pass_sp` (IN `_oldp` TEXT, IN `_new` TEXT, IN `_confirm` TEXT, IN `_user_id` INT)   BEGIN

if(_new = _oldp)THEN
SELECT concat('danger| New Password mala mid noqon karo Old password');
ELSEIF EXISTS(SELECT id FROM users u WHERE u.id=_user_id AND u.password=md5(_oldp))THEN

update users SET PASSWORD = md5(_new) WHERE id=_user_id;
SELECT concat('success| Password Updated Success');
ELSE


SELECT concat('danger| Old Password ma saxna');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chart_detail_sp` (IN `_action` TEXT, IN `_user_id` INT)   BEGIN

IF(_action = 'customer')THEN
SELECT c.name,c.gender,c.tell,c.date FROM customers c;
ELSEIF(_action = 'user')THEN
SELECT u.username,u.image `Image~image`,u.status FROM users u ;
ELSEIF(_action = 'destination')THEN
SELECT d.name,d.date FROM destination d ;
ELSEIF(_action = 'account')THEN
SELECT a.name,a.date FROM account a ;
ELSEIF(_action = 'booking')THEN
SELECT c.name,d.name,b.price,b.date FROM booking b LEFT JOIN customers c 
ON c.id=b.customer_id LEFT JOIN destination d on d.id=b.destination_id 
;
ELSEIF(_action = 'flight')THEN
SELECT f.name,f.airplane,f.fromm 'From',f.too 'To',f.departure_airport 'Departure Airport',
f.arrival_airport 'Arrival Airport',f.price,f.date FROM flights f ;

END if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `class_room_sp` (IN `_branch_id` INT, IN `_class_id` VARCHAR(100), IN `_char` VARCHAR(100), IN `_shift_id` INT, IN `_fee` DOUBLE, IN `_user_id` INT)   BEGIN
SELECT name INTO @class FROM class WHERE id=_class_id;
SELECT name INTO @shift FROM shift WHERE id=_shift_id;
if EXISTS(SELECT id FROM class_room WHERE class_id=_class_id AND branch_id=_branch_id AND char_=_char AND shift_id=_shift_id)THEN

SELECT concat('danger|',@class,' ',_char,' ',@shift,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO class_room(class_id,branch_id,char_,shift_id,fee,user_id)
VALUES(_class_id,_branch_id,_char,_shift_id,_fee,_user_id);
SELECT concat('success|',@class,' ',_char,' ',@shift,' Waala diwan galiyay');
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customers_sp` (`_name` VARCHAR(100), `_tell` INT, `_gender` VARCHAR(100), `_date` DATE, `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM customers WHERE name = _name AND tell = _tell)THEN
SELECT concat('danger|',_name,' Horay Ayaa Loo Diwaan Galiyay');

ELSE
INSERT INTO customers(name,tell,gender,date,user_id)
VALUES(_name,_tell,_gender,_date,_user_id);
SELECT concat('success|',_name,' Waala Diwaan Galiyay');

end IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sp` (`_table` TEXT, `_col` TEXT, `_value` TEXT, `_user_id` INT)   BEGIN

SET @sq = concat('SELECT GROUP_CONCAT(COLUMN_NAME),GROUP_CONCAT(COLUMN_NAME SEPARATOR '','''','''','') into @column,@col FROM information_schema.`COLUMNS`  WHERE TABLE_SCHEMA = DATABASE() AND `TABLE_NAME` = ',quote(_table));
PREPARE s FROM @sq;
EXECUTE s;

SET @da = concat(' select group_concat(concat(',@col,') SEPARATOR '''') into @data from ',_table,' where ',_col,' = ',quote(_value));
PREPARE d FROM @da;
EXECUTE d;

INSERT INTO deleted_records(tran_id,cols,backup,table_,user_id,date)
VALUES(_value,@column,@data,_table,_user_id,now());

SET @sql = concat('delete from ',_table,' where ',_col,' =',quote(_value));
PREPARE stm FROM @sql;
EXECUTE stm;
                  
                  
SELECT 'Deleted';
       
                  
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `destination_sp` (`_name` VARCHAR(100), `_date` DATE, `_user_id` INT)   BEGIN
IF EXISTS(SELECT id FROM destination WHERE name = _name)THEN
SELECT concat('danger|',_name,' Horay Ayaa Loo Diwaan Galiyay');
ELSE
INSERT INTO destination(name,date,user_id)
VALUES(_name,_date,_user_id);
SELECT concat('success|',_name,' Waala Diwaan Galiyay');
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_sp` (`_table` TEXT, `_set_col` TEXT, `_col` TEXT, `id_p` TEXT, `_value` TEXT, `_user_id` INT)   BEGIN

SET @sql = concat('update ',_table,' set ',_set_col,' =',quote(_value),' where ',_col,' =',quote(id_p));

PREPARE stm FROM @sql;
EXECUTE stm;
                  
                  
SELECT 'Updated Success';
       
                  
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `flights_sp` (IN `_name` VARCHAR(100), IN `_airplane` VARCHAR(100), IN `_fromm` VARCHAR(100), IN `_too` VARCHAR(100), IN `_departure_airport` VARCHAR(100), IN `_arrival_airport` VARCHAR(100), IN `_price` DOUBLE, IN `_date` DATE, IN `_user_id` INT)   BEGIN
IF EXISTS(SELECT id FROM flights WHERE name=_name and airplane=_airplane AND date = _date AND fromm = _fromm and too = _too)THEN
SELECT concat('danger|',_name,' Horay Ayaa Loo Diiwan Galiyay');
ELSE
INSERT INTO flights (name,airplane,fromm,too,departure_airport,arrival_airport,price,date,user_id)
VALUES(_name,_airplane,_fromm,_too,_departure_airport,_arrival_airport,_price,_date,_user_id);
SELECT concat('success|',_name,' Waala Diiwan Galiyay');

end IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `form_input` (IN `_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
IF(_id = '')THEN
SET _id='%';
END if;
SELECT f.form_id 'Form Id',f.type 'Type',f.label Label,f.name Name,f.placeholder Placeholder,f.is_required Required,f.class Class,
f.action 'Action', edi_data('form_input','id',id,_user_id,'form_input')`Edit` FROM form_input f WHERE f.form_id like _id ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `form_sp` (`_name` VARCHAR(100), `_category_id` INT, `_href` VARCHAR(100), `_sp_name` TEXT, `_form_action` TEXT, `_button` TEXT, `_user_id` INT)   BEGIN
START TRANSACTION;
INSERT INTO forms(name,href,category_id,sp_name,form_action,button)
VALUES(_name,_href,_category_id,_sp_name,_form_action,_button);
SET @form_id = last_insert_id();

INSERT INTO `user_form`(`form_id`, `user_id`, `granted_user`) 
VALUES(@form_id,_user_id,_user_id);


INSERT INTO form_input(type,name,label,placeholder,form_id)
SELECT if(PARAMETER_NAME='_user_id','user_id',''),`PARAMETER_NAME`,REPLACE(`PARAMETER_NAME`,'_',' '),concat('Enter ',REPLACE(`PARAMETER_NAME`,'_',' ')),@form_id FROM information_schema.`PARAMETERS` WHERE `SPECIFIC_SCHEMA`=DATABASE() AND  `SPECIFIC_NAME`=_sp_name;


SELECT concat('success| Registred');

COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_dropdown_sp` (IN `_action` VARCHAR(100))   BEGIN

if(_action='branch')THEN
SELECT id,name FROM branch;

ELSEIF(_action='user')THEN
SELECT id,username FROM users;

ELSEIF(_action='category')THEN
SELECT id,name FROM category;

ELSEIF(_action='destination')THEN
SELECT id,name FROM destination;

ELSEIF(_action='account')THEN
SELECT id,name FROM account;
ELSEIF(_action='gender')THEN
SELECT g.type FROM gender g;
ELSEIF(_action='forminput')THEN
SELECT f.id,f.name from form_input f;
ELSEIF(_action='gender')THEN
SELECT g.type from gender g;

ELSEIF(_action='href')THEN
SELECT 'forms/gen_form.php','Form'
UNION
SELECT 'forms/gen_report.php','Report Form';

ELSEIF(_action='form_action')THEN
SELECT 'tools/insert_anny.php','Insert Page'
UNION
SELECT 'tools/report.php','Report Page';


END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hotels_sp` (`_name` VARCHAR(100), `_city` VARCHAR(100), `_country` VARCHAR(100), `_price` DOUBLE, `_date` DATE, `_user_id` INT)   BEGIN
IF EXISTS(SELECT id FROM hotels WHERE name=_name AND city=_city)THEN
SELECT concat('danger|',_name,' Horay Ayaa Loo Diwaan Galiyay');
ELSE
INSERT INTO hotels (name,city,country,price,date,user_id)
VALUES(_name,_city,_country,_price,_date,_user_id);
SELECT concat('success|',_name,' Waala Diwaan Galiyay');

END if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_sp` (IN `_username` VARCHAR(100), IN `_password` TEXT)   BEGIN

if EXISTS(SELECT * FROM users WHERE username=_username AND password = md5(_password) AND status='active')THEN

SELECT id user_id,name,username,image,is_online,branch_id FROM users WHERE username=_username AND password = md5(_password) AND status='active';

ELSE
SELECT 'Username or password incorrect' as error;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payment_sp` (`_account_id` INT, `_amount` DOUBLE, `_description` TEXT, `_user_id` INT, `_date` DATE)   BEGIN
IF EXISTS(SELECT id FROM payment WHERE account_id = _account_id and amount = _amount)THEN
SELECT concat('danger|',_account_id,' Horay Ayaa Loo Diwaan Galiyay');
ELSE

INSERT INTO payment(account_id,amount,description,user_id,date)
VALUES(_account_id,_amount,_description,_user_id,_date);
SELECT concat('success|',_amount,' Waala Diwaan Galiyay');

END if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `permission_sp` (`_form_id` INT, `_user_id` INT, `_granted` INT, `_action` TEXT, `_type` TEXT)   BEGIN
SELECT name INTO @name FROM forms WHERE id=_form_id;
if(_type='insert')THEN

INSERT INTO user_form(form_id,user_id,granted_user,action)
VALUES(_form_id,_user_id,_granted,_action);
SELECT concat(@name,' Has been Granted');
ELSE

DELETE FROM user_form WHERE form_id=_form_id AND user_id=_user_id;
SELECT concat(@name,' Has been Revoked');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `receipt_sp` (IN `_customer_id` INT, IN `_amount` DOUBLE, IN `_discount` DOUBLE, IN `_account_id` INT, IN `_date` DATE, IN `_user_id` INT)   BEGIN



INSERT INTO receipt(customer_id,amount,discount,date,user_id,account_id)
VALUES(_customer_id,_amount,_discount,_date,_user_id,_account_id);


SELECT concat('success| Waala diwan galiyay');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_account_sp` (IN `_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
IF(_id='')THEN
SET _id='%';
END IF;
SELECT id,name Account,date Date, del_data('account','id',id,_user_id)`Delete~ignore`,edi_data('account','id',id,_user_id,'account')`Edit~ignore` FROM account WHERE id like _id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_balance_p` (`_branch_id` TEXT, `_level_id` TEXT, `_class_id` TEXT, `_std_id` TEXT)   BEGIN
SET @n = 0;

SELECT @n:=@n+1 No, s.std_id `Student Id`,s.name `Student Name`,s.tell Tell,s.class_name Class,balance(s.std_id)Balance FROM student_view s 
WHERE s.branch_id LIKE _branch_id AND s.level_id LIKE _level_id AND s.class_id LIKE _class_id AND s.std_id LIKE _std_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_booking_sp` (IN `_customer_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
if(_customer_id = '')THEN
SET _customer_id = '%';
END IF;
SELECT b.id,c.name Customer,d.name Destination,b.price Price,b.date Date,del_data('booking','id',b.id,_user_id)`Delete~ignore`,edi_data('booking','id',b.id,_user_id,'booking')`Edit~ignore` from
booking b LEFT JOIN customers c on c.id=b.customer_id
LEFT JOIN destination d on d.id=b.destination_id 
WHERE c.id like _customer_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_branch_sp` (IN `_branch_id` VARCHAR(100), IN `_user_id` INT)   BEGIN

SET @n = 0;
SELECT @n:=@n+1 `No`, name 'Branch Name',tell 'Branch tell',address Address,admin 'Admin Name',admintell 'Admin Tell',date Date ,
del_data('branch','id',id,_user_id)`Delete~ignore`,edi_data('branch','id',id,_user_id,'branch')`Edit~ignore` FROM branch 
WHERE id LIKE _branch_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_chart_sp` (IN `_user_id` INT)   BEGIN

SELECT c.*,chart_count(c.action)counts FROM charts c 
JOIN user_form u on u.form_id=c.id AND u.action='chart'
WHERE u.user_id=_user_id
ORDER BY sort ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_customers_sp` (IN `_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
if(_id = '')THEN
SET _id='%';
END if;
SELECT id,name 'Name',tell 'Tell',gender 'Gender',date Date ,del_data('customers','id',id,_user_id)`Delete~ignore`,edi_data('customers','id',id,_user_id,'customers')`Edit~ignore` FROM customers WHERE id LIKE _id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_deleted_sp` (IN `_table` TEXT, IN `_from` DATE, IN `_to` DATE, IN `_user_id` INT)   BEGIN

SELECT 'undo_sp' `sp~req sp hide`,d.id `id~req id hide`,`backup` `Back Up~req data`,table_ `Table~req table`,d.cols `col~req hide col`,u.username,d.date,`undo`()`Undo` FROM deleted_records d JOIN users u on d.user_id=u.id
WHERE date(d.date) BETWEEN _from AND _to AND d.user_id LIKE _user_id AND d.table_ LIKE _table AND d.status=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_destination_sp` (IN `_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
if(_id = '')THEN
SET _id='%';
END if;
SELECT id,name City,date Date,del_data('destination','id',id,_user_id)`Delete~ignore`,edi_data('destination','id',id,_user_id,'destination')`Edit~ignore` FROM destination WHERE id like _id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_flights_sp` (IN `_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
IF(_id = '')THEN
SET _id = '%';
END IF;
SELECT id,name Name,airplane Airplane,fromm 'From',too 'To',departure_airport 'Departure Airport',arrival_airport 'Arrival Airport',price Price,date Date,del_data('flights','id',id,_user_id)`Delete~ignore`,edi_data('flights','id',id,_user_id,'flights')`Edit~ignore` FROM flights WHERE id like _id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_hotels_sp` (`_id` VARCHAR(100), `_user_id` INT)   BEGIN
IF(_id='')THEN
SET _id='%';
END IF;
SELECT id,name 'Hotel',city City,country Country,price Price,date Date FROM hotels WHERE id like _id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_payment_sp` (IN `_account_id` VARCHAR(100), IN `_user_id` INT)   BEGIN
IF(_account_id ='')THEN

SET _account_id = '%';
END IF;

SELECT a.name Account,p.amount Amount,p.description Description,p.date Date,del_data('payment','id',p.id,_user_id)`Delete~ignore`,
edi_data('payment','id',p.id,_user_id,'payment')`Edit~ignore`FROM account a LEFT JOIN payment p on a.id=p.account_id
WHERE a.id like _account_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_permission_sp` (`_user_id` INT)   BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_receipt_sp` (IN `_customer_id` VARCHAR(100), IN `_from` DATE, IN `_to` DATE, IN `_user_id` VARCHAR(100))   BEGIN
SET @n = 0;

if(_to='0000-00-00')THEN

SET _to = now();
END IF;

SELECT @n:=@n+1 No,
c.name,r.amount,r.discount,r.description,r.date,del_data('receipt','id',r.id,_user_id)`Delete~ignore`,edi_data('receipt','id',r.id,_user_id,'receipt')`Edite~ignore`
FROM receipt r LEFT JOIN customers c on c.id=r.customer_id
WHERE c.id like _customer_id AND r.date BETWEEN _from AND _to;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_users_sp` (IN `_user_id` TEXT)   BEGIN
SELECT u.username,u.image `Image~image`,u.status FROM users u WHERE u.id LIKE _user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_row` (IN `_action` TEXT, IN `_val` TEXT)   BEGIN
if(_action='receipt')THEN
SELECT r.amount,r.discount,r.date 'Date~date' FROM receipt r WHERE id=_val;
ELSEIF(_action = 'customers')THEN
SELECT c.name,c.tell,c.gender,c.date FROM customers c WHERE id=_val;
ELSEIF(_action = 'branch')THEN
SELECT b.name,b.tell,b.address,b.date FROM branch b WHERE b.id=_val;
ELSEIF(_action = 'destination')THEN
SELECT d.name,d.date FROM destination d WHERE d.id=_val;
ELSEIF(_action = 'account')THEN
SELECT a.name,a.date FROM account a WHERE a.id=_val;
ELSEIF(_action = 'booking')THEN
SELECT b.customer_id,b.destination_id FROM booking b WHERE b.id=_val;
ELSEIF(_action = 'flights')THEN
SELECT f.name,f.airplane,f.fromm,f.too,f.departure_airport,f.arrival_airport,f.price,f.date FROM flights f WHERE f.id=_val; 
ELSEIF(_action = 'form_input')THEN
SELECT f.form_id,f.type,f.label,f.name,f.placeholder,f.is_required,f.class,f.action FROM form_input f WHERE f.id=_val; 

ELSEIF(_action = 'user')THEN
SELECT u.name,u.username,u.image,u.status,u.date FROM users u WHERE f.id=_val;

ELSEIF(_action = 'payment')THEN
SELECT p.account_id,p.amount,p.description,p.date FROM payment p WHERE p.id=_val;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_sp` (IN `_text` TEXT, IN `_action` TEXT)   BEGIN

if(_action='sp')THEN
SELECT ROUTINE_NAME,ROUTINE_NAME FROM information_schema.`ROUTINES` WHERE `ROUTINE_TYPE`='PROCEDURE' AND `ROUTINE_SCHEMA`=DATABASE() AND ROUTINE_NAME LIKE concat('%',_text,'%');

  
ELSEIF(_action='customer')THEN
SELECT c.id,c.name,c.tell,c.gender,c.date FROM customers c 
WHERE (c.name LIKE concat('%',_text,'%') 
 OR c.tell LIKE concat('%',_text,'%') );

ELSEIF(_action='destination')THEN
SELECT d.id,d.name,d.date FROM destination d 
WHERE d.name LIKE concat('%',_text,'%');

ELSEIF(_action='booking')THEN
SELECT b.id,cu.name,de.name,b.date FROM booking b
LEFT JOIN customers cu on cu.id=b.customer_id 
LEFT JOIN destination de on de.id=b.destination_id
WHERE (b.id LIKE concat('%',_text,'%')
 or cu.name LIKE concat('%',_text,'%'));

      
ELSEIF(_action='account')THEN
SELECT a.id,a.name,a.date FROM account a 
WHERE (a.id LIKE concat('%',_text,'%')
OR a.name LIKE concat('%',_text,'%') );

ELSEIF(_action='flight')THEN
SELECT f.id,f.airplane FROM flights f 
WHERE (f.id LIKE concat('%',_text,'%')
OR f.name LIKE concat('%',_text,'%') 
OR f.airplane LIKE concat('%',_text,'%'));

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_permission_sp` (`_user_id` INT, `_type` TEXT, `_id` INT)   BEGIN
if(_type='menu')THEN
SELECT c.id,c.name,'forms' action FROM category c JOIN forms f on c.id=f.category_id GROUP by c.name
UNION
SELECT 0,'Chart Permission','chart' action

UNION
SELECT 0,'Edit Permission','edit' action

UNION
SELECT 0,'delete Permission','delete' action;

ELSEIF(_type='forms')THEN
SELECT f.id,f.name,if(u.form_id is not null,'checked','')cb,'form' `action` 
FROM forms f JOIN category c on c.id=f.category_id LEFT JOIN user_form u on u.form_id=f.id AND u.user_id=_user_id WHERE f.category_id=_id;

ELSEIF(_type='chart')THEN
SELECT c.id,c.text name,if(u.form_id is not null,'checked','')cb,'chart' `action` 
FROM charts c 
LEFT JOIN user_form u on u.form_id=c.id AND u.action='chart' AND u.user_id=_user_id;

ELSEIF(_type='edit')THEN
SELECT c.id,c.text name,if(u.form_id is not null,'checked','')cb,'edit' `action` 
FROM other_table c 
LEFT JOIN user_form u on u.form_id=c.id AND u.action='edit' AND c.action='edit' AND u.user_id=_user_id WHERE c.action='edit';


ELSEIF(_type='delete')THEN
SELECT c.id,c.text name,if(u.form_id is not null,'checked','')cb,'delete' `action` 
FROM other_table c 
LEFT JOIN user_form u on u.form_id=c.id AND u.action='delete' AND c.action='delete' AND u.user_id=_user_id WHERE c.action='delete';
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `undo_sp` (`_id` TEXT, `_backup` TEXT, `_col` TEXT, `_table` TEXT)   BEGIN
select table_,REPLACE(cols,',','`,`'),REPLACE(backup,',',quote(',')) into @t,@c,@b 
from deleted_records where id = _id;



SET @sql = concat('insert into `',@t,'` (`',@c,'`) values (''',@b,''')');

#SET @sql = concat('INSERT INTO `',@t,'` (`',@c,'`) VALUES (''',@b,''')');

PREPARE stm FROM @sql;
EXECUTE stm;


UPDATE deleted_records SET status=0 WHERE id=_id;
SELECT 'Backup restorred success';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `users_sp` (IN `_username` VARCHAR(100), IN `_password` TEXT, IN `_image` VARCHAR(100), IN `_user_id` INT)   BEGIN
 if EXISTS(SELECT id FROM users WHERE username=_username)THEN
 
 SELECT concat('danger|',_username,' Horay ayaa loo diwan galiyay');
 
 ELSE
 
 INSERT INTO users(username,password,image,date,user_id)
 VALUES(_username,md5(_password),_image,now(),_user_id);
 SELECT concat('success|',_username,' waala diwan galiyay');
 END IF;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `balance` (`_std_id` INT) RETURNS DOUBLE  BEGIN

SELECT sum(c.amount) INTO @charge FROM charge c WHERE c.std_id=_std_id;

SELECT sum(c.amount+c.discount) INTO @rec FROM receipt c WHERE c.std_id=_std_id;

RETURN ifnull(@charge,0) - ifnull(@rec,0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `chart_count` (`_action` TEXT) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_general_ci  BEGIN
SET @cc = 0;

if(_action='customer')THEN
SELECT count(id) INTO @cc FROM customers;
ELSEIF(_action='user')THEN
SELECT count(id) INTO @cc FROM users;
ELSEIF(_action='destination')THEN
SELECT count(id) INTO @cc FROM destination;
ELSEIF(_action='account')THEN
SELECT count(id) INTO @cc FROM account;
ELSEIF(_action='booking')THEN
SELECT count(id) INTO @cc FROM booking;
ELSEIF(_action='flight')THEN
SELECT count(id) INTO @cc FROM flights;
END IF;

RETURN @cc;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_gender` (`_gen` TEXT, `_year` INT) RETURNS INT(11)  BEGIN

SELECT count(id) INTO @f FROM `student` WHERE gender=_gen AND year(date)=_year;


RETURN @f;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `del_data` (`_table` TEXT, `_col` TEXT, `_value` TEXT, `_user_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN

if not EXISTS(SELECT id FROM other_table WHERE value=_table AND action='delete')THEN

INSERT INTO other_table(value,text,action)
value(_table,concat('delete ',_table),'delete');
END IF;

if EXISTS(SELECT u.id
          FROM user_form u JOIN other_table o on  o.id=u.form_id AND o.value=_table WHERE u.user_id=_user_id AND u.action='delete')THEN
RETURN concat('<button class="btn btn-danger del_data" table="',_table,'" column="',_col,'" value="',_value,'" user_id="',_user_id
              ,'">','<i class="fa fa-trash"> Delete</i>','</button>');
ELSE
 RETURN 'xx';

END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `edi_data` (`_table` TEXT, `_col` TEXT, `_value` TEXT, `_user_id` INT, `_action` TEXT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN

if not EXISTS(SELECT id FROM other_table WHERE value=_table AND action='edit')THEN

INSERT INTO other_table(value,text,action)
value(_table,concat('edit ',_table),'edit');
END IF;

if EXISTS(SELECT u.id
          FROM user_form u JOIN other_table o on  o.id=u.form_id AND o.value=_table WHERE u.user_id=_user_id AND u.action='edit')THEN
RETURN concat('<button class="btn btn-info edit_data" table="',_table,'" column="',_col,'" value="',_value,'" user_id="',_user_id,'" action="',_action,'">','<i class="fa fa-edit"> Update</i>','</button>');
ELSE
 RETURN 'xx';

END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_name` (`_std_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN

SELECT name INTO @c FROM student WHERE	 std_id=_std_id;


RETURN @c;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ref_no` () RETURNS INT(11)  BEGIN
SET @start = 1;

SELECT ref_no+1 INTO @start FROM receipt ORDER by ref_no DESC LIMIT 1;


RETURN @start;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `std_id` () RETURNS INT(11)  BEGIN

SET @start = 1001;


SELECT std_id+1 INTO @start FROM student ORDER by std_id DESC LIMIT 1;

RETURN @start;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `undo` () RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN

RETURN concat('<i class="fa fa-refresh undo"><i>');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `name`, `date`, `user_id`) VALUES
(1, 'evc', '2023-08-23', 2),
(2, 'e-dahab', '0000-00-00', 2),
(3, 'priemeir bank', '2023-09-07', 2);

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `destination_id` int(11) DEFAULT NULL,
  `price` double NOT NULL,
  `date` date DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id`, `customer_id`, `destination_id`, `price`, `date`, `user_id`) VALUES
(1, 1, 1, 200, '2023-09-02', 2),
(2, 2, 1, 100, '2023-09-02', 2);

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `tell` int(11) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `admin` varchar(100) DEFAULT NULL,
  `admintell` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `name`, `tell`, `address`, `date`, `admin`, `admintell`) VALUES
(1, 'hq', 618008736, 'holwadaag', '2023-09-07', 'mohamoud', 615555555),
(2, 'bakaaro', 555551, 'holwadaag', '2023-09-07', 'moha', 66657);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `icon`) VALUES
(1, 'Registration', 'fa fa-plus'),
(5, 'Reports', 'fa fa-list'),
(6, 'Users', 'fa fa-users'),
(7, 'Lacagaha', 'fa fa-money'),
(8, 'Developer', 'fa fa-users');

-- --------------------------------------------------------

--
-- Table structure for table `charge_salary`
--

CREATE TABLE `charge_salary` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `month` varchar(100) DEFAULT NULL,
  `year` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `charts`
--

CREATE TABLE `charts` (
  `id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `color` varchar(100) NOT NULL,
  `icon` varchar(100) NOT NULL,
  `text` varchar(200) NOT NULL,
  `sort` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `charts`
--

INSERT INTO `charts` (`id`, `action`, `color`, `icon`, `text`, `sort`) VALUES
(1, 'user', 'bg-danger', 'fa fa-users', 'Total Users', 1),
(2, 'customer', 'bg-success', 'fa fa-users', 'Total Customers', 2),
(3, 'destination', 'bg-primary', 'fa fa-globe', 'destination list', 3),
(4, 'account', 'bg-info', 'fa fa-money', 'acount list', 5),
(6, 'flight', 'bg-warning', 'fa fa-plane', 'total flights', 6);

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `tel` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `domain` text NOT NULL,
  `logo` text NOT NULL,
  `letter_head` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `name`, `tel`, `address`, `domain`, `logo`, `letter_head`, `date`) VALUES
(1, 'Gurhan Travel Agency', '66', 'kpp', 'locahost', 'uploads/logo.png', '', '2023-04-02 10:52:44');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `gender` varchar(100) NOT NULL,
  `tell` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action_date` timestamp NULL DEFAULT current_timestamp(),
  `modefied_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `gender`, `tell`, `date`, `user_id`, `action_date`, `modefied_date`) VALUES
(1, 'mohamoud', '', 618008736, '2023-08-14', 2, NULL, NULL),
(2, 'abdi', '', 3333333, '2023-08-14', NULL, NULL, NULL),
(7, 'gurhan', 'male', 61555555, '2023-09-07', 2, '2023-09-07 12:03:42', '2023-09-07 12:03:42');

-- --------------------------------------------------------

--
-- Table structure for table `deleted_records`
--

CREATE TABLE `deleted_records` (
  `id` int(11) NOT NULL,
  `tran_id` int(11) DEFAULT NULL,
  `table_` varchar(100) DEFAULT NULL,
  `backup` varchar(100) DEFAULT NULL,
  `cols` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deleted_records`
--

INSERT INTO `deleted_records` (`id`, `tran_id`, `table_`, `backup`, `cols`, `user_id`, `date`, `description`, `status`) VALUES
(2, 9, 'branch', '9,bakaaro,2147483647,Tanzania,2023-04-30,admin,767', 'id,name,tell,address,date,admin,admintell', 2, '2023-05-19 10:54:24', NULL, 0),
(3, 1, 'flights', NULL, 'id,name,airplane,departure_airport,arrival_airport,date,user_id,action_date,modefied_date', 2, '2023-08-22 17:56:52', NULL, 1),
(4, 12, 'branch', '12,,0,,0000-00-00,,0', 'id,name,tell,address,date,admin,admintell', 2, '2023-09-04 20:09:58', NULL, 0),
(5, 12, 'branch', '12,,0,,0000-00-00,,0', 'id,name,tell,address,date,admin,admintell', 2, '2023-09-04 20:10:51', NULL, 1),
(6, 6, 'customers', '6,jini,women,0,0000-00-00,2,2023-09-03 18:42:13,2023-09-03 18:42:13', 'id,name,gender,tell,date,user_id,action_date,modefied_date', 2, '2023-09-06 14:29:14', NULL, 0),
(7, 4, 'flights', '4,,,,,,,0,0000-00-00,2', 'id,name,airplane,fromm,too,departure_airport,arrival_airport,price,date,user_id', 2, '2023-09-06 14:33:00', NULL, 1),
(8, 6, 'customers', '6,jini,women,0,0000-00-00,2,2023-09-03 18:42:13,2023-09-03 18:42:13', 'id,name,gender,tell,date,user_id,action_date,modefied_date', 2, '2023-09-07 11:09:06', NULL, 0),
(9, 6, 'customers', '6,jini,women,0,0000-00-00,2,2023-09-03 18:42:13,2023-09-03 18:42:13', 'id,name,gender,tell,date,user_id,action_date,modefied_date', 2, '2023-09-07 11:09:28', NULL, 1),
(10, 1, 'branch', '1,hq,618008736,holwadaag,2023-09-07,mohamoud,615555555', 'id,name,tell,address,date,admin,admintell', 2, '2023-09-07 15:07:11', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `destination`
--

CREATE TABLE `destination` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `date` date DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL,
  `action_date` date DEFAULT NULL,
  `modefied_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `destination`
--

INSERT INTO `destination` (`id`, `name`, `date`, `user_id`, `action_date`, `modefied_date`) VALUES
(1, 'Mogadishu', NULL, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `flights`
--

CREATE TABLE `flights` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `airplane` varchar(100) DEFAULT NULL,
  `fromm` varchar(100) NOT NULL,
  `too` varchar(100) NOT NULL,
  `departure_airport` varchar(100) DEFAULT NULL,
  `arrival_airport` varchar(100) DEFAULT NULL,
  `price` double NOT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `flights`
--

INSERT INTO `flights` (`id`, `name`, `airplane`, `fromm`, `too`, `departure_airport`, `arrival_airport`, `price`, `date`, `user_id`) VALUES
(2, 'b2221', 'daalo', '', '', 'aadan adde airport', 'cigaal airport', 0, '2023-08-23', 2),
(3, 'm2321', 'daalo', 'mogadishu', 'bosaaso', 'aadan adde airport', 'mohamoud', 50, '2023-09-02', 2),
(5, '', '2', 'mogadishu', 'hargeysa', 'aadan adde', 'cigaal', 20, '2023-09-07', 2);

-- --------------------------------------------------------

--
-- Table structure for table `forms`
--

CREATE TABLE `forms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `href` varchar(100) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sp_name` varchar(100) NOT NULL,
  `form_action` varchar(100) NOT NULL,
  `button` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `forms`
--

INSERT INTO `forms` (`id`, `name`, `href`, `category_id`, `sp_name`, `form_action`, `button`) VALUES
(14, 'Create Form', 'forms/gen_form.php', 8, 'form_sp', 'tools/insert_anny.php', 'Add'),
(25, 'Branch List', 'forms/gen_report.php', 5, 'rp_branch_sp', 'tools/report.php', 'Search'),
(29, 'Deleted Records', 'forms/gen_report.php', 5, 'rp_deleted_sp', 'tools/report.php', 'Search'),
(30, 'Add User', 'forms/gen_form.php', 6, 'users_sp', 'tools/insert_anny.php', 'Add'),
(31, 'User Permission', 'forms/gen_report.php', 6, 'rp_permission_sp', 'tools/userpermission.php', 'Show'),
(40, 'Users List', 'forms/gen_report.php', 6, 'rp_users_sp', 'tools/report.php', 'Search'),
(43, 'Add Customer', 'forms/gen_form.php', 1, 'customers_sp', 'tools/insert_anny.php', 'Save'),
(44, 'Customer List', 'forms/gen_report.php', 5, 'rp_customers_sp', 'tools/report.php', 'Search'),
(45, 'Add Branch', 'forms/gen_form.php', 1, 'branch_sp', 'tools/insert_anny.php', 'Save'),
(46, 'Destination List', 'forms/gen_report.php', 5, 'rp_destination_sp', 'tools/report.php', 'Search'),
(53, 'Add Account', 'forms/gen_form.php', 1, 'account_sp', 'tools/insert_anny.php', 'Save'),
(54, 'Account List', 'forms/gen_report.php', 5, 'rp_account_sp', 'tools/report.php', 'Search'),
(55, 'Payment', 'forms/gen_form.php', 7, 'payment_sp', 'tools/insert_anny.php', 'Save'),
(59, 'Booking List', 'forms/gen_report.php', 5, 'rp_booking_sp', 'tools/report.php', 'Search'),
(61, 'Payment LIst', 'forms/gen_report.php', 7, 'rp_payment_sp', 'tools/report.php', 'Search'),
(62, 'Booking', 'forms/gen_form.php', 1, 'booking_sp', 'tools/insert_anny.php', 'Save'),
(63, 'Add Flight', 'forms/gen_form.php', 1, 'flights_sp', 'tools/insert_anny.php', 'Save'),
(64, 'Flight List', 'forms/gen_report.php', 5, 'rp_flights_sp', 'tools/report.php', 'Search'),
(65, 'Reciept', 'forms/gen_form.php', 7, 'receipt_sp', 'tools/insert_anny.php', 'Save'),
(67, 'Reciept Report', 'forms/gen_report.php', 7, 'rp_receipt_sp', 'tools/report.php', 'Search'),
(71, 'Forget Password', 'forms/gen_form.php', 6, 'change_pass_sp', 'tools/insert_anny.php', 'Change');

-- --------------------------------------------------------

--
-- Table structure for table `form_input`
--

CREATE TABLE `form_input` (
  `id` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `placeholder` text DEFAULT NULL,
  `is_required` varchar(100) DEFAULT NULL,
  `class` varchar(100) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `form_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `form_input`
--

INSERT INTO `form_input` (`id`, `type`, `label`, `name`, `placeholder`, `is_required`, `class`, `action`, `form_id`) VALUES
(1, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 14),
(2, 'dropdown', 'Choose Category', '_category_id', 'Enter  category id', NULL, NULL, 'category', 14),
(3, 'dropdown', ' href', '_href', 'Enter  href', NULL, NULL, 'href', 14),
(4, 'search', ' sp name', '_sp_name', 'Enter  sp name', 'required', NULL, 'sp', 14),
(5, 'checkbox', ' form action', '_form_action', 'Enter  form action', NULL, NULL, 'form_action', 14),
(6, '', ' button', '_button', 'Enter  button', NULL, NULL, NULL, 14),
(7, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 14),
(8, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 15),
(9, '', ' fee', '_fee', 'Enter  fee', NULL, NULL, NULL, 15),
(10, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 15),
(11, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 16),
(12, 'dropdown', 'Choose Level', '_level_id', 'Enter  level id', NULL, NULL, 'level', 16),
(13, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 16),
(14, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 17),
(15, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 17),
(17, 'dropdown', 'Choose Branch', '_branch_id', 'Enter  branch id', NULL, NULL, 'branch', 18),
(18, 'dropdown', 'Choose Class', '_class_id', 'Enter  class id', NULL, NULL, 'class', 18),
(19, 'dropdown', ' char', '_char', 'Enter  char', NULL, NULL, 'char', 18),
(20, 'dropdown', 'Choose Shift', '_shift_id', 'Enter  shift id', NULL, NULL, 'shift', 18),
(21, '', ' fee', '_fee', 'Enter  fee', NULL, NULL, NULL, 18),
(22, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 18),
(24, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 19),
(25, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 19),
(27, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 20),
(28, '', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 20),
(29, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 20),
(30, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 21),
(31, '', ' tell', '_tell', 'Enter  tell', NULL, NULL, NULL, 21),
(32, '', ' address', '_address', 'Enter  address', NULL, NULL, NULL, 21),
(33, '', ' admin', '_admin', 'Enter  admin', NULL, NULL, NULL, 21),
(34, '', ' admintell', '_admintell', 'Enter  admintell', NULL, NULL, NULL, 21),
(35, '', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 21),
(37, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 22),
(38, '', ' branch id', '_branch_id', 'Enter  branch id', NULL, NULL, NULL, 23),
(39, '', ' month id', '_month_id', 'Enter  month id', NULL, NULL, NULL, 23),
(40, '', ' year id', '_year_id', 'Enter  year id', NULL, NULL, NULL, 23),
(41, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 23),
(45, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 24),
(46, 'dropdown', 'Choose Branch', '_branch_id', 'Enter  branch Name', NULL, NULL, 'branch', 25),
(47, '', ' branch id', '_branch_id', 'Enter  branch id', NULL, NULL, NULL, 26),
(48, '', ' level id', '_level_id', 'Enter  level id', NULL, NULL, NULL, 26),
(49, '', ' class id', '_class_id', 'Enter  class id', NULL, NULL, NULL, 26),
(50, 'search', ' std id', '_std_id', 'Enter  std id', NULL, NULL, NULL, 26),
(54, 'dropdown', 'Choose Branch', '_branch_id', 'Enter  branch id', NULL, NULL, 'branch', 27),
(55, 'dropdown', 'Choose level', '_level_id', 'Enter  level id', NULL, NULL, 'level', 27),
(56, 'dropdown', 'Choose class', '_class_id', 'Enter  class id', NULL, NULL, 'class', 27),
(57, 'dropdown', 'Choose Fee', '_fee_id', 'Enter  fee id', NULL, NULL, 'fee', 27),
(58, 'date', ' from', '_from', 'Enter  from', NULL, NULL, NULL, 27),
(59, 'date', ' to', '_to', 'Enter  to', NULL, NULL, NULL, 27),
(60, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 27),
(61, 'user_id', 'Choose Branch', 'user', 'Enter  branch id', NULL, NULL, 'branch', 25),
(62, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 28),
(63, 'dropdown', ' table', '_table', 'Enter  table', NULL, NULL, NULL, 29),
(64, 'date', ' from', '_from', 'Enter  from', NULL, NULL, NULL, 29),
(65, 'date', ' to', '_to', 'Enter  to', NULL, NULL, NULL, 29),
(66, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 29),
(70, '', ' username', '_username', 'Enter  username', 'required', NULL, NULL, 30),
(71, '', ' password', '_password', 'Enter  password', NULL, NULL, NULL, 30),
(72, 'file', ' image', '_image', 'Enter  image', NULL, NULL, NULL, 30),
(74, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 30),
(77, 'dropdown', 'Choose User', '_user_id', 'Enter  user id', NULL, NULL, 'user', 31),
(78, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 32),
(79, '', ' category id', '_category_id', 'Enter  category id', NULL, NULL, NULL, 32),
(80, '', ' href', '_href', 'Enter  href', NULL, NULL, NULL, 32),
(81, '', ' sp name', '_sp_name', 'Enter  sp name', 'required', NULL, NULL, 32),
(82, '', ' form action', '_form_action', 'Enter  form action', NULL, NULL, NULL, 32),
(83, '', ' button', '_button', 'Enter  button', NULL, NULL, NULL, 32),
(84, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 32),
(85, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 33),
(86, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 33),
(88, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 34),
(89, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 34),
(91, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 35),
(92, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 35),
(94, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 36),
(95, 'checkbox', 'Class', '_class_id', 'Enter  class id', NULL, NULL, 'class', 37),
(96, 'checkbox', 'Course', '_course_id', 'Enter  course id', NULL, NULL, 'course', 37),
(97, 'dropdown', 'Choose Exam', '_exam_id', 'Enter  exam id', NULL, NULL, 'exam', 37),
(98, 'dropdown', ' year id', '_year_id', 'Enter  year id', NULL, NULL, 'year', 37),
(99, '', ' min', '_min', 'Enter  min', NULL, NULL, NULL, 37),
(100, '', ' max', '_max', 'Enter  max', NULL, NULL, NULL, 37),
(101, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 37),
(102, 'date', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 37),
(110, 'dropdown', 'Class', '_class_id', 'Enter  class id', NULL, NULL, 'class', 38),
(111, 'dropdown', 'Course', '_course_id', 'Enter  course id', NULL, NULL, 'course', 38),
(112, 'dropdown', 'Exam', '_exam_id', 'Enter  exam id', NULL, NULL, 'exam', 38),
(113, 'dropdown', 'Year', '_year_id', 'Enter  year id', NULL, NULL, 'year', 38),
(114, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 38),
(115, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 39),
(116, '', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 39),
(117, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 39),
(118, 'dropdown', 'Choose User', '_user_id', 'Enter  user id', NULL, NULL, 'user', 40),
(119, 'search', 'Student Name', '_std_id', 'Enter  std id', NULL, NULL, 'student', 41),
(120, 'date', ' from', '_from', 'Enter  from', NULL, NULL, NULL, 41),
(121, 'date', ' to', '_to', 'Enter  to', NULL, NULL, NULL, 41),
(122, '', ' class id', '_class_id', 'Enter  class id', NULL, NULL, NULL, 42),
(123, '', ' exam id', '_exam_id', 'Enter  exam id', NULL, NULL, NULL, 42),
(124, '', ' acc', '_acc', 'Enter  acc', NULL, NULL, NULL, 42),
(125, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 43),
(126, '', ' tell', '_tell', 'Enter  tell', 'required', NULL, NULL, 43),
(127, '', ' gender', '_gender', 'Enter  gender', NULL, NULL, '', 43),
(128, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 43),
(129, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 43),
(132, 'search', 'Customer Name', '_id', 'Customer Name', NULL, NULL, 'customer', 44),
(133, 'user_id', 'user id', 'user_id', 'Enter user id', NULL, NULL, NULL, 44),
(135, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 45),
(136, '', ' tell', '_tell', 'Enter  tell', NULL, NULL, NULL, 45),
(137, '', ' address', '_address', 'Enter  address', NULL, NULL, NULL, 45),
(138, '', ' admin', '_admin', 'Enter  admin Name', 'required', NULL, NULL, 45),
(139, '', ' admintell', '_admintell', 'Enter  admin tell', NULL, NULL, NULL, 45),
(140, 'date', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 45),
(142, 'search', ' City', '_id', 'Enter City Name', NULL, NULL, 'destination', 46),
(143, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 46),
(145, '', ' customer id', '_customer_id', 'Enter  customer id', NULL, NULL, NULL, 47),
(146, '', ' destination id', '_destination_id', 'Enter  destination id', NULL, NULL, NULL, 47),
(147, 'date', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 47),
(148, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 47),
(152, 'search', ' customer id', '_customer_id', 'Enter  customer id', NULL, 'customer', '', 48),
(153, 'search', ' destination id', '_destination_id', 'Enter  destination id', NULL, 'booking', '', 48),
(154, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 48),
(155, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 49),
(156, '', ' airplane', '_airplane', 'Enter  airplane', NULL, NULL, NULL, 49),
(157, '', ' departure airport', '_departure_airport', 'Enter  departure airport', NULL, NULL, NULL, 49),
(158, '', ' arrival airport', '_arrival_airport', 'Enter  arrival airport', NULL, NULL, NULL, 49),
(159, 'date', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 49),
(160, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 49),
(162, '', 'Flight', '_id', 'Enter  Flight', NULL, NULL, NULL, 50),
(163, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 50),
(175, '', ' name', '_name', 'Enter  name', 'required', NULL, NULL, 53),
(176, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 53),
(177, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 53),
(178, 'search', 'Accounnt Name', '_id', 'Enter Account Name', NULL, NULL, 'account', 54),
(179, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 54),
(181, 'dropdown', ' account ', '_account_id', 'Enter  account id', 'required', NULL, 'account', 55),
(182, '', ' amount', '_amount', 'Enter  amount', 'required', NULL, NULL, 55),
(183, '', ' description', '_description', 'Enter  description', 'required', NULL, NULL, 55),
(184, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 55),
(185, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 55),
(205, 'search', 'customer Name', '_customer_id', 'Enter  customer Name', NULL, NULL, 'booking', 59),
(207, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 59),
(216, 'dropdown', ' account', '_account_id', 'Enter  account id', '', NULL, 'account', 61),
(217, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 61),
(218, 'search', ' customer  Name', '_customer_id', 'Enter  customer NAme', 'required', NULL, 'customer', 62),
(219, 'search', ' destination ', '_destination_id', 'Enter  destination ', 'required', NULL, 'destination', 62),
(220, '', ' price', '_price', 'Enter  price', 'required', NULL, NULL, 62),
(221, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 62),
(222, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 62),
(225, 'search', ' name', '_name', 'Enter  name', 'required', NULL, 'customer', 63),
(226, 'search', ' airplane', '_airplane', 'Enter  airplane', 'required', NULL, 'flight', 63),
(227, '', ' from', '_fromm', 'Departure City', 'required', NULL, NULL, 63),
(228, '', ' to', '_too', 'Arrival City', 'required', NULL, NULL, 63),
(229, '', ' departure airport', '_departure_airport', 'Enter  departure airport', 'required', NULL, NULL, 63),
(230, '', ' arrival airport', '_arrival_airport', 'Enter  arrival airport', 'required', NULL, NULL, 63),
(231, '', ' price', '_price', 'Enter  price', 'required', NULL, NULL, 63),
(232, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 63),
(233, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 63),
(240, 'search', 'Flight', '_id', 'Enter Flight', 'required', NULL, 'flight', 64),
(241, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 64),
(243, 'search', ' customer Name', '_customer_id', 'Enter  customer id', 'required', NULL, 'customer', 65),
(244, '', ' amount', '_amount', 'Enter  amount', 'required', NULL, NULL, 65),
(245, '', ' discount', '_discount', 'Enter  discount', NULL, NULL, NULL, 65),
(246, 'dropdown', ' account ', '_account_id', 'Enter  account id', 'required', NULL, 'account', 65),
(247, 'date', ' date', '_date', 'Enter  date', 'required', NULL, NULL, 65),
(248, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 65),
(257, 'search', ' Customer Name', '_customer_id', 'Enter  customer id', NULL, NULL, 'customer', 67),
(258, 'date', ' from', '_from', 'Enter  from', NULL, NULL, NULL, 67),
(259, 'date', ' to', '_to', 'Enter  to', NULL, NULL, NULL, 67),
(260, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 67),
(265, 'dropdown', 'form input', '_id', 'Enter  id', NULL, NULL, 'forminput', 69),
(266, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 69),
(271, '', ' old Password', '_oldp', 'Enter  old Password', 'required', NULL, NULL, 71),
(272, '', ' new Password', '_new', 'Enter  new Password', 'required', 'newpass', NULL, 71),
(273, '', ' confirm Password', '_confirm', 'Enter  confirm Password', 'required', 'confirm', NULL, 71),
(274, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 71);

-- --------------------------------------------------------

--
-- Table structure for table `gender`
--

CREATE TABLE `gender` (
  `id` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `gender`
--

INSERT INTO `gender` (`id`, `type`) VALUES
(1, 'Male'),
(2, 'Female');

-- --------------------------------------------------------

--
-- Table structure for table `months`
--

CREATE TABLE `months` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `ordes` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `months`
--

INSERT INTO `months` (`id`, `name`, `date`, `ordes`) VALUES
(1, 'January', '2023-03-21', '6'),
(2, 'February', '2023-03-21', '7'),
(3, 'March', '2023-03-21', '8'),
(4, 'April', '2023-03-21', '9'),
(5, 'May', '2023-03-21', '10'),
(6, 'June', '2023-03-21', '11'),
(7, 'July', '2023-03-21', '12'),
(8, 'August', '2023-03-21', '1'),
(9, 'September', '2023-03-21', '2'),
(10, 'OctOber', '2023-03-21', '3'),
(11, 'November', '2023-03-21', '4'),
(12, 'December', '2023-03-21', '5');

-- --------------------------------------------------------

--
-- Table structure for table `other_table`
--

CREATE TABLE `other_table` (
  `id` int(11) NOT NULL,
  `value` varchar(100) NOT NULL,
  `text` varchar(100) NOT NULL,
  `action` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `other_table`
--

INSERT INTO `other_table` (`id`, `value`, `text`, `action`) VALUES
(1, 'branch', 'delete branch', 'delete'),
(2, 'receipt', 'edit receipt', 'edit'),
(3, 'flights', 'delete flights', 'delete'),
(4, 'customers', 'delete customers', 'delete'),
(5, 'destination', 'delete destination', 'delete'),
(6, 'account', 'delete account', 'delete'),
(7, 'booking', 'delete booking', 'delete'),
(8, 'payment', 'delete payment', 'delete'),
(9, 'customers', 'edit customers', 'edit'),
(10, 'receipt', 'delete receipt', 'delete'),
(11, 'branch', 'edit branch', 'edit'),
(12, 'destination', 'edit destination', 'edit'),
(13, 'account', 'edit account', 'edit'),
(14, 'booking', 'edit booking', 'edit'),
(15, 'flights', 'edit flights', 'edit'),
(16, 'payment', 'edit payment', 'edit'),
(17, 'form_input', 'edit form_input', 'edit'),
(18, 'users', 'delete users', 'delete'),
(19, 'users', 'edit users', 'edit');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `account_id`, `amount`, `description`, `user_id`, `date`) VALUES
(1, 1, 10, '', 2, '0000-00-00'),
(2, 1, 1, '', 2, '0000-00-00'),
(3, 0, 0, '', 2, '0000-00-00'),
(4, 1, 0, 'ijaar', 2, '2023-08-30'),
(5, 1, 100, 'lacagta biyaha', 2, '2023-09-01'),
(6, 1, 200, 'koronto', 2, '2023-09-07'),
(7, 2, 100, 'koronto', 2, '2023-09-07');

-- --------------------------------------------------------

--
-- Table structure for table `pay_salary`
--

CREATE TABLE `pay_salary` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `month` varchar(100) DEFAULT NULL,
  `year` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `discount` double NOT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`id`, `customer_id`, `amount`, `discount`, `description`, `date`, `user_id`) VALUES
(1, 1, 100, 9, NULL, '2023-08-30', 2);

-- --------------------------------------------------------

--
-- Table structure for table `updated_records`
--

CREATE TABLE `updated_records` (
  `id` int(11) NOT NULL,
  `table_` varchar(100) DEFAULT NULL,
  `column_` varchar(100) DEFAULT NULL,
  `old_value` varchar(100) DEFAULT NULL,
  `new_value` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` text DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT 'active',
  `date` date DEFAULT NULL,
  `is_online` varchar(100) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`, `image`, `status`, `date`, `is_online`, `branch_id`, `user_id`) VALUES
(2, 'Mohamoud Mohamed Gurhan', 'admin', '81dc9bdb52d04dc20036dbd8313ed055', NULL, 'active', '2023-04-02', NULL, 1, 1),
(15, 'abdi', 'abdi', '1f32aa4c9a1d2ea010adcf2348166a04', NULL, 'active', NULL, NULL, NULL, 15),
(16, '', 'mohamoud', '202cb962ac59075b964b07152d234b70', 'uploads/IMG_3115.JPG', 'active', '2023-09-06', NULL, NULL, 2),
(17, '', 'abdikariin', '202cb962ac59075b964b07152d234b70', 'uploads/banaadir_zone (6).sql', 'active', '2023-09-07', NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `user_form`
--

CREATE TABLE `user_form` (
  `id` int(11) NOT NULL,
  `form_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `granted_user` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL DEFAULT 'form'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_form`
--

INSERT INTO `user_form` (`id`, `form_id`, `user_id`, `granted_user`, `action`) VALUES
(1, 31, 2, 2, 'form'),
(2, 69, 2, 2, 'form'),
(5, 2, 2, 2, 'chart'),
(6, 3, 2, 2, 'chart'),
(8, 55, 2, 2, 'form'),
(9, 61, 2, 2, 'form'),
(10, 65, 2, 2, 'form'),
(11, 67, 2, 2, 'form'),
(12, 43, 2, 2, 'form'),
(13, 53, 2, 2, 'form'),
(14, 45, 2, 2, 'form'),
(15, 62, 2, 2, 'form'),
(16, 63, 2, 2, 'form'),
(18, 29, 2, 2, 'form'),
(19, 44, 2, 2, 'form'),
(20, 46, 2, 2, 'form'),
(21, 64, 2, 2, 'form'),
(22, 54, 2, 2, 'form'),
(23, 59, 2, 2, 'form'),
(24, 2, 2, 2, 'edit'),
(25, 9, 2, 2, 'edit'),
(26, 11, 2, 2, 'edit'),
(27, 12, 2, 2, 'edit'),
(28, 13, 2, 2, 'edit'),
(30, 15, 2, 2, 'edit'),
(31, 16, 2, 2, 'edit'),
(32, 17, 2, 2, 'edit'),
(34, 3, 2, 2, 'delete'),
(36, 5, 2, 2, 'delete'),
(37, 6, 2, 2, 'delete'),
(38, 7, 2, 2, 'delete'),
(39, 8, 2, 2, 'delete'),
(40, 10, 2, 2, 'delete'),
(41, 30, 2, 2, 'form'),
(42, 40, 2, 2, 'form'),
(44, 1, 2, 2, 'chart'),
(45, 5, 2, 2, 'chart'),
(46, 6, 2, 2, 'chart'),
(47, 70, 2, 2, 'form'),
(48, 14, 16, 2, 'form'),
(49, 69, 16, 2, 'form'),
(50, 55, 16, 2, 'form'),
(51, 61, 16, 2, 'form'),
(52, 65, 16, 2, 'form'),
(53, 67, 16, 2, 'form'),
(54, 43, 16, 2, 'form'),
(55, 45, 16, 2, 'form'),
(56, 53, 16, 2, 'form'),
(57, 62, 16, 2, 'form'),
(58, 63, 16, 2, 'form'),
(59, 30, 16, 2, 'form'),
(60, 31, 16, 2, 'form'),
(61, 40, 16, 2, 'form'),
(62, 70, 16, 2, 'form'),
(63, 29, 16, 2, 'form'),
(64, 44, 16, 2, 'form'),
(65, 46, 16, 2, 'form'),
(66, 64, 16, 2, 'form'),
(67, 25, 16, 2, 'form'),
(68, 59, 16, 2, 'form'),
(69, 54, 16, 2, 'form'),
(70, 1, 16, 2, 'chart'),
(71, 2, 16, 2, 'chart'),
(72, 3, 16, 2, 'chart'),
(73, 4, 16, 2, 'chart'),
(74, 5, 16, 2, 'chart'),
(75, 6, 16, 2, 'chart'),
(76, 1, 16, 2, 'delete'),
(77, 4, 16, 2, 'delete'),
(78, 5, 16, 2, 'delete'),
(79, 6, 16, 2, 'delete'),
(80, 7, 16, 2, 'delete'),
(81, 8, 16, 2, 'delete'),
(82, 10, 16, 2, 'delete'),
(83, 3, 16, 2, 'delete'),
(84, 2, 16, 2, 'edit'),
(85, 9, 16, 2, 'edit'),
(86, 11, 16, 2, 'edit'),
(87, 12, 16, 2, 'edit'),
(88, 13, 16, 2, 'edit'),
(89, 15, 16, 2, 'edit'),
(90, 16, 16, 2, 'edit'),
(91, 17, 16, 2, 'edit'),
(92, 14, 16, 2, 'edit'),
(93, 71, 2, 2, 'form'),
(94, 1, 2, 2, 'delete'),
(95, 4, 2, 2, 'chart'),
(96, 4, 2, 2, 'delete'),
(99, 40, 2, 2, 'delete'),
(100, 18, 2, 2, 'delete'),
(101, 19, 2, 2, 'edit'),
(102, 25, 2, 2, 'form'),
(103, 61, 17, 2, 'form'),
(104, 55, 17, 2, 'form'),
(105, 65, 17, 2, 'form'),
(106, 67, 17, 2, 'form'),
(107, 43, 17, 2, 'form'),
(108, 45, 17, 2, 'form'),
(109, 53, 17, 2, 'form'),
(110, 62, 17, 2, 'form'),
(111, 63, 17, 2, 'form'),
(112, 1, 17, 2, 'chart'),
(113, 3, 17, 2, 'chart'),
(114, 4, 17, 2, 'chart'),
(115, 2, 17, 2, 'chart'),
(116, 6, 17, 2, 'chart'),
(117, 30, 17, 2, 'form'),
(118, 31, 17, 2, 'form'),
(119, 71, 17, 2, 'form'),
(120, 40, 17, 2, 'form'),
(121, 25, 17, 2, 'form'),
(122, 29, 17, 2, 'form'),
(123, 44, 17, 2, 'form'),
(124, 46, 17, 2, 'form'),
(125, 64, 17, 2, 'form'),
(126, 59, 17, 2, 'form'),
(127, 54, 17, 2, 'form'),
(128, 2, 17, 2, 'edit'),
(129, 9, 17, 2, 'edit'),
(130, 11, 17, 2, 'edit'),
(131, 13, 17, 2, 'edit'),
(132, 15, 17, 2, 'edit'),
(133, 16, 17, 2, 'edit'),
(134, 17, 17, 2, 'edit'),
(135, 19, 17, 2, 'edit'),
(136, 14, 17, 2, 'edit'),
(137, 12, 17, 2, 'edit'),
(138, 1, 17, 2, 'delete'),
(139, 5, 17, 2, 'delete'),
(140, 7, 17, 2, 'delete'),
(141, 8, 17, 2, 'delete'),
(142, 3, 17, 2, 'delete'),
(143, 6, 17, 2, 'delete'),
(144, 4, 17, 2, 'delete'),
(145, 18, 17, 2, 'delete'),
(146, 10, 17, 2, 'delete'),
(147, 14, 17, 2, 'form'),
(148, 14, 2, 2, 'form');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `charge_salary`
--
ALTER TABLE `charge_salary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `charts`
--
ALTER TABLE `charts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deleted_records`
--
ALTER TABLE `deleted_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `destination`
--
ALTER TABLE `destination`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `flights`
--
ALTER TABLE `flights`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `forms`
--
ALTER TABLE `forms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `form_input`
--
ALTER TABLE `form_input`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `months`
--
ALTER TABLE `months`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `other_table`
--
ALTER TABLE `other_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pay_salary`
--
ALTER TABLE `pay_salary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `updated_records`
--
ALTER TABLE `updated_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_form`
--
ALTER TABLE `user_form`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `charge_salary`
--
ALTER TABLE `charge_salary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `charts`
--
ALTER TABLE `charts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `deleted_records`
--
ALTER TABLE `deleted_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `destination`
--
ALTER TABLE `destination`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `flights`
--
ALTER TABLE `flights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `forms`
--
ALTER TABLE `forms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `form_input`
--
ALTER TABLE `form_input`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=275;

--
-- AUTO_INCREMENT for table `gender`
--
ALTER TABLE `gender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `months`
--
ALTER TABLE `months`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `other_table`
--
ALTER TABLE `other_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pay_salary`
--
ALTER TABLE `pay_salary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `updated_records`
--
ALTER TABLE `updated_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_form`
--
ALTER TABLE `user_form`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
