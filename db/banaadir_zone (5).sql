-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 07, 2023 at 02:07 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `banaadir_zone`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `academic_year_sp` (`_name` VARCHAR(100), `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM academic_year WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa lo diwan galiyay');
ELSE

UPDATE academic_year SET status=0;
INSERT INTO academic_year(name,user_id)
VALUES(_name,_user_id);

SELECT concat('succes|',_name,' waala diwan galiyay');
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `account_sp` (`_name` VARCHAR(100), `_date` DATE, `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM account WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO account(name,user_id,date)
VALUES(_name,_user_id,_date);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `charge_month_fee_sp` (`_branch_id` TEXT, `_month_id` INT, `_year_id` INT, `_user_id` INT)   BEGIN

SELECT m.name INTO @month FROM months m WHERE id=_month_id;
INSERT IGNORE INTO charge(std_id,class_id,branch_id,amount,month_id,year_id,date,user_id,fee_id)
SELECT s.std_id,s.class_id,s.branch_id,s.fee,_month_id,_year_id,now(),_user_id,1 FROM student_view s WHERE s.is_free !=1 AND s.status=1 AND find_in_set(s.branch_id,_branch_id);


if(row_count() > 0)THEN
SELECT concat('success|',row_count(),' ayaa lagu dalcay lacagta bisha ',@month);

ELSE
SELECT concat('danger|',' Horay ayaa loo dalacay lacagta bisha ',@month);


END IF;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `class_sp` (`_name` VARCHAR(100), `_level_id` INT, `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM class WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO class(name,level_id,user_id)
VALUES(_name,_level_id,_user_id);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `course_sp` (`_name` VARCHAR(100))   BEGIN
if EXISTS(SELECT id FROM course WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO course(name)
VALUES(_name);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_sp` (`_table` TEXT, `_set_col` TEXT, `_col` TEXT, `id_p` TEXT, `_value` TEXT, `_user_id` INT)   BEGIN

SET @sql = concat('update ',_table,' set ',_set_col,' =',quote(_value),' where ',_col,' =',quote(id_p));

PREPARE stm FROM @sql;
EXECUTE stm;
                  
                  
SELECT 'Updated Success';
       
                  
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `exam_sp` (`_name` VARCHAR(100))   BEGIN
if EXISTS(SELECT id FROM exam WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO exam(name)
VALUES(_name);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fee_type_sp` (`_name` VARCHAR(100))   BEGIN
if EXISTS(SELECT id FROM fee_type WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO fee_type(name)
VALUES(_name);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
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

if(_action='level')THEN
SELECT id,name FROM level;
ELSEIF(_action='class')THEN
SELECT id,name FROM class;

ELSEIF(_action='branch')THEN
SELECT id,name FROM branch;

ELSEIF(_action='shift')THEN
SELECT id,name FROM shift;

ELSEIF(_action='user')THEN
SELECT id,username FROM users;

ELSEIF(_action='category')THEN
SELECT id,name FROM category;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `level_sp` (IN `_name` VARCHAR(100), IN `_fee` DOUBLE, IN `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM level WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO level(name,fee,user_id)
VALUES(_name,_fee,_user_id);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_sp` (`_username` VARCHAR(100), `_password` TEXT)   BEGIN

if EXISTS(SELECT * FROM users WHERE username=_username AND password = md5(_password) AND status='active')THEN

SELECT id user_id,username,image,is_online,branch_id FROM users WHERE username=_username AND password = md5(_password) AND status='active';

ELSE
SELECT 'Username or password incorrect' as error;
END IF;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `receipt_sp` (`_std_id` INT, `_amount` DOUBLE, `_discount` DOUBLE, `_fee_id` INT, `_date` DATE, `_user_id` INT, `_ref_no` INT, `_account_id` INT, `_month_id` INT, `_year_id` INT)   BEGIN

SELECT s.class_id,s.branch_id INTO @class_id,@branch_id FROM student_view s WHERE s.std_id=_std_id;

if(_ref_no = 0)THEN
SELECT ref_no() INTO @ref;
SET _ref_no = @ref;
END IF;

INSERT INTO receipt(std_id,amount,discount,class_id,branch_id,date,fee_id,user_id,ref_no,account_id,month_id,year_id)
VALUES(_std_id,_amount,_discount,@class_id,@branch_id,_date,_fee_id,_user_id,_ref_no,_account_id,_month_id,_year_id);


SELECT concat('success| Waala diwan galiyay');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_balance_p` (`_branch_id` TEXT, `_level_id` TEXT, `_class_id` TEXT, `_std_id` TEXT)   BEGIN
SET @n = 0;

SELECT @n:=@n+1 No, s.std_id `Student Id`,s.name `Student Name`,s.tell Tell,s.class_name Class,balance(s.std_id)Balance FROM student_view s 
WHERE s.branch_id LIKE _branch_id AND s.level_id LIKE _level_id AND s.class_id LIKE _class_id AND s.std_id LIKE _std_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_branch_sp` (IN `_branch_id` VARCHAR(100), IN `_user_id` INT)   BEGIN

SET @n = 0;
SELECT @n:=@n+1 `No`, name 'Branch Name',tell 'Branch tell',address Address,admin 'Admin Name',admintell 'Admin Tell',date Date,del_data('branch','id',id,_user_id)`Delete` FROM branch 
WHERE id LIKE _branch_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_chart_sp` (IN `_user_id` INT)   BEGIN

SELECT *,chart_count(action)counts FROM charts ORDER BY sort ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_deleted_sp` (IN `_table` TEXT, IN `_from` DATE, IN `_to` DATE, IN `_user_id` INT)   BEGIN

SELECT 'undo_sp' `sp~req sp hide`,d.id `id~req id hide`,`backup` `Back Up~req data`,table_ `Table~req table`,d.cols `col~req hide col`,u.username,d.date,`undo`()`Undo` FROM deleted_records d JOIN users u on d.user_id=u.id
WHERE date(d.date) BETWEEN _from AND _to AND d.user_id LIKE _user_id AND d.table_ LIKE _table AND d.status=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_permission_sp` (`_user_id` INT)   BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rp_receipt_sp` (IN `_branch_id` VARCHAR(100), IN `_level_id` VARCHAR(100), IN `_class_id` VARCHAR(100), IN `_fee_id` VARCHAR(100), IN `_from` DATE, IN `_to` DATE, IN `_user_id` VARCHAR(100))   BEGIN
SET @n = 0;

if(_to='0000-00-00')THEN

SET _to = now();
END IF;

SELECT @n:=@n+1 No,edi_data('receipt','id',r.id,_user_id,'receipt')`Edite`, s.std_id `Student Id`,s.name `Student Name`,s.tell Tell,r.amount Amount,r.discount,f.name `Fee Type`,m.name Month,a.name `Year`,u.username,r.date FROM student_view s 
LEFT JOIN receipt r on s.std_id=r.std_id
JOIN fee_type f on f.id=r.fee_id
LEFT JOIN months m on m.id=r.month_id
LEFT JOIN academic_year a on a.id=r.year_id
LEFT JOIN users u on u.id=r.user_id
WHERE r.branch_id LIKE _branch_id AND r.class_id LIKE _class_id AND r.fee_id LIKE _fee_id AND r.date BETWEEN _from AND _to AND s.level_id LIKE _level_id ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_row` (IN `_action` TEXT, IN `_val` TEXT)   BEGIN
if(_action='receipt')THEN
SELECT r.amount,r.discount,r.ref_no,r.date 'Date~date' FROM receipt r WHERE id=_val;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_sp` (IN `_text` TEXT, IN `_action` TEXT)   BEGIN

if(_action='sp')THEN
SELECT ROUTINE_NAME,ROUTINE_NAME FROM information_schema.`ROUTINES` WHERE `ROUTINE_TYPE`='PROCEDURE' AND `ROUTINE_SCHEMA`=DATABASE() AND ROUTINE_NAME LIKE concat('%',_text,'%');

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shift_sp` (`_name` VARCHAR(100), `_user_id` INT)   BEGIN
if EXISTS(SELECT id FROM shift WHERE name=_name)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');

ELSE
INSERT INTO shift(name,user_id)
VALUES(_name,_user_id);

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_permission_sp` (`_user_id` INT, `_type` TEXT, `_id` INT)   BEGIN
if(_type='menu')THEN
SELECT c.id,c.name FROM category c JOIN forms f on c.id=f.category_id GROUP by c.name;
ELSEIF(_type='forms')THEN
SELECT f.id,f.name,if(u.form_id is not null,'checked','')cb,'form' `action` FROM category c JOIN forms f on c.id=f.category_id LEFT JOIN user_form u on u.form_id=f.id WHERE f.category_id=_id;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `student_sp` (`_name` VARCHAR(100), `_tell` VARCHAR(100), `_address` TEXT, `_dob` TEXT, `_pob` TEXT, `_gender` TEXT, `_age` INT, `_mother` TEXT, `_m_tell` INT, `_parent_id` INT, `_parent_type` TEXT, `_class_room_id` INT, `_date` DATE, `_month_id` TEXT, `_year_id` INT, `_user_id` INT, `_reg_fee` DOUBLE, `_amount` DOUBLE, `_description` TEXT, `_exp_date` DATE)   BEGIN

START TRANSACTION;
SELECT class_id,branch_id INTO @class_id,@branch_id FROM class_room WHERE id=_class_room_id;

if EXISTS(SELECT id FROM student WHERE name=_name AND mother=_mother AND tell=_tell)THEN
SELECT concat('danger|',_name,' Horay ayaa loo diwan galiyay');
ELSE

SELECT std_id() INTO @std_id;
INSERT INTO `student`(`std_id`, `name`, `tell`, `address`, `dop`, `bop`, `gender`, `age`, `mother`, `m_tell`, `parent_id`, `parent_type`, `class_room_id`, `date`, `year_id`, `user_id`)
VALUES(@std_id,_name,_tell,_address,_dob,_pob,_gender,year(now()) - _age,_mother,_m_tell,_parent_id,_parent_type,_class_room_id,_date,_year_id,_user_id);

#xareey lacagta diwan galinta
if(_reg_fee > 0)THEN

INSERT INTO `charge`(`std_id`, `class_id`, `branch_id`, `amount`, `month_id`, `year_id`, `date`, `user_id`, `fee_id`)
VALUES(@std_id,@class_id,@branch_id,_reg_fee,_month_id,_year_id,_date,_user_id,2);
END IF;

#lacagta bisha
SELECT c.fee INTO @amount FROM class_view c WHERE c.class_room_id=_class_room_id;

SET @day = day(_date);
SET @month_fee  = 0;
if(@day < 15)THEN
SET @month_fee = @amount;
ELSEIF(@day > 15 AND @day < 25)THEN
SET @month_fee = @amount / 2;
END IF;

if(@month_fee > 0)THEN

INSERT INTO `charge`(`std_id`, `class_id`, `branch_id`, `amount`, `month_id`, `year_id`, `date`, `user_id`, `fee_id`)
VALUES(@std_id,@class_id,@branch_id,@month_fee - _amount,_month_id,_year_id,_date,_user_id,1);
END IF;

if(_amount > 0)THEN
INSERT INTO `scholarship`( `std_id`, `amount`, `description`, `user_id`, `date`, `exp_date`) 
VALUES(@std_id,_amount,_description,_user_id,_date,_exp_date);
END IF;

SELECT concat('success|',_name,' waala diwan galiyay');
END IF;
COMMIT;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `users_sp` (`_username` VARCHAR(100), `_password` TEXT, `_image` VARCHAR(100), `_branch_id` INT, `_user_id` INT)   BEGIN
 if EXISTS(SELECT id FROM users WHERE username=_username)THEN
 
 SELECT concat('danger|',_username,' Horay ayaa loo diwan galiyay');
 
 ELSE
 
 INSERT INTO users(username,password,image,date,branch_id,user_id)
 VALUES(_username,md5(_password),_image,now(),_branch_id,_user_id);
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

CREATE DEFINER=`root`@`localhost` FUNCTION `chart_count` (`_action` TEXT) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
SET @cc = 0;
if(_action='class')THEN
SELECT count(id) INTO @cc FROM class;
ELSEIF(_action='user')THEN
SELECT count(id) INTO @cc FROM users;

END IF;

RETURN @cc;
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
-- Table structure for table `academic_year`
--

CREATE TABLE `academic_year` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT '1',
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic_year`
--

INSERT INTO `academic_year` (`id`, `name`, `status`, `user_id`) VALUES
(1, '2022/2023', '0', 1),
(2, '2023/2024', '1', 1);

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
(1, 'Salaam Bank', '2023-04-04', 2),
(2, 'Evc', '2023-04-09', 2),
(3, 's', '0000-00-00', 2);

-- --------------------------------------------------------

--
-- Table structure for table `apsent_students`
--

CREATE TABLE `apsent_students` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `attendance_type_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendance_type`
--

CREATE TABLE `attendance_type` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(9, 'bakaaro', 2147483647, 'Tanzania', '2023-04-30', 'admin', 767);

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
(2, 'Finance', 'fa fa-money'),
(3, 'Exam', 'fa fa-check'),
(4, 'Attendance', 'fa fa-clock-o'),
(5, 'Reports', 'fa fa-list'),
(6, 'Users', 'fa fa-users'),
(7, 'Developer', 'fa fa-users');

-- --------------------------------------------------------

--
-- Table structure for table `charge`
--

CREATE TABLE `charge` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fee_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `charge`
--

INSERT INTO `charge` (`id`, `std_id`, `class_id`, `branch_id`, `amount`, `month_id`, `year_id`, `date`, `user_id`, `fee_id`) VALUES
(3, 1001, 1, 1, 5, NULL, 1, '2023-03-19', 1, 2),
(4, 1001, 1, 1, 20, NULL, 1, '2023-03-19', 1, 1),
(5, 1002, 1, 1, 5, NULL, 1, '2023-03-19', 1, 2),
(6, 1002, 1, 1, 20, NULL, 1, '2023-03-19', 1, 1),
(7, 1003, 1, 1, 10, NULL, 1, '2023-03-19', 1, 2),
(8, 1003, 1, 1, 17, NULL, 1, '2023-03-19', 1, 1),
(9, 1004, 1, 1, 10, NULL, 1, '2023-03-19', 1, 2),
(10, 1004, 1, 1, 7, NULL, 1, '2023-03-19', 1, 1),
(11, 1005, 1, 1, 10, NULL, 1, '2023-03-19', 1, 2),
(12, 1005, 1, 1, 8.5, NULL, 1, '2023-03-19', 1, 1),
(13, 1006, 1, 1, 10, NULL, 1, '2023-03-14', 1, 2),
(14, 1006, 1, 1, 17, NULL, 1, '2023-03-14', 1, 1),
(15, 1007, 1, 1, 10, NULL, 1, '2023-03-26', 1, 2),
(16, 1004, 1, 1, 7, 4, 1, '2023-03-21', 1, 1),
(17, 1001, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(18, 1002, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(19, 1003, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(20, 1005, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(21, 1006, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(22, 1007, 1, 1, 17, 4, 1, '2023-03-21', 1, 1),
(24, 1004, 1, 1, 7, 5, 1, '2023-03-21', 1, 1),
(25, 1001, 1, 1, 17, 5, 1, '2023-03-21', 1, 1),
(26, 1002, 1, 1, 17, 5, 1, '2023-03-21', 1, 1),
(27, 1003, 1, 1, 17, 5, 1, '2023-03-21', 1, 1),
(28, 1005, 1, 1, 17, 5, 1, '2023-03-21', 1, 1),
(29, 1006, 1, 1, 17, 5, 1, '2023-03-21', 1, 1),
(31, 1005, 1, 2, 17, 6, 1, '2023-03-21', 1, 1),
(32, 1006, 1, 2, 17, 6, 1, '2023-03-21', 1, 1),
(34, 1004, 1, 1, 7, 6, 1, '2023-03-21', 1, 1),
(35, 1001, 1, 1, 17, 6, 1, '2023-03-21', 1, 1),
(36, 1002, 1, 1, 17, 6, 1, '2023-03-21', 1, 1),
(37, 1003, 1, 1, 17, 6, 1, '2023-03-21', 1, 1),
(41, 1004, 1, 1, 7, 7, 1, '2023-03-21', 1, 1),
(42, 1001, 1, 1, 17, 7, 1, '2023-03-21', 1, 1),
(43, 1002, 1, 1, 17, 7, 1, '2023-03-21', 1, 1),
(44, 1003, 1, 1, 17, 7, 1, '2023-03-21', 1, 1),
(45, 1005, 1, 2, 17, 7, 1, '2023-03-21', 1, 1),
(46, 1006, 1, 2, 17, 7, 1, '2023-03-21', 1, 1);

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
(1, 'class', 'bg-primary', 'fa fa-home', 'Total Classes', 1),
(2, 'user', 'bg-danger', 'fa fa-users', 'Total Users', 2);

-- --------------------------------------------------------

--
-- Table structure for table `class`
--

CREATE TABLE `class` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `orders` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `class`
--

INSERT INTO `class` (`id`, `name`, `level_id`, `orders`, `user_id`) VALUES
(1, 'Form 1', 1, NULL, 1),
(2, 'Grade 1', 2, NULL, 1),
(3, 'Grade 6', 5, NULL, 2),
(4, 'Grade 7', 5, NULL, 2),
(5, 'Grad 9', 4, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `class_room`
--

CREATE TABLE `class_room` (
  `id` int(11) NOT NULL,
  `class_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `char_` varchar(100) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `fee` double DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `class_room`
--

INSERT INTO `class_room` (`id`, `class_id`, `branch_id`, `char_`, `shift_id`, `fee`, `user_id`) VALUES
(1, 1, 1, 'A', 1, 0, 1),
(2, 1, 2, 'B', 1, 0, 1),
(3, 1, 4, 'A', 1, 0, 2),
(4, 1, 4, 'No Data to display go to get_dropdown_sp and add action', 2, 12, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `class_view`
-- (See below for the actual view)
--
CREATE TABLE `class_view` (
`class_id` int(11)
,`class` varchar(100)
,`level_id` int(11)
,`orders` varchar(100)
,`branch_id` int(11)
,`class_room_id` int(11)
,`char_` varchar(100)
,`shift_id` int(11)
,`class_room_fee` double
,`shift` varchar(100)
,`level_name` varchar(100)
,`level_fee` double
,`fee` double
);

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 9, 'branch', '9,bakaaro,2147483647,Tanzania,2023-04-30,admin,767', 'id,name,tell,address,date,admin,admintell', 2, '2023-04-30 00:00:00', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `drop_out_student`
--

CREATE TABLE `drop_out_student` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `drop_out_type_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `drop_out_type`
--

CREATE TABLE `drop_out_type` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `tell` int(11) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `title_id` int(11) DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `martial_status` varchar(100) DEFAULT NULL,
  `account_no` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `exam`
--

CREATE TABLE `exam` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exam`
--

INSERT INTO `exam` (`id`, `name`) VALUES
(1, 'asdc'),
(2, 'test'),
(3, 'yy');

-- --------------------------------------------------------

--
-- Table structure for table `fee_type`
--

CREATE TABLE `fee_type` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `default` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fee_type`
--

INSERT INTO `fee_type` (`id`, `name`, `default`) VALUES
(1, 'Lacagta Bisha', '1'),
(2, 'Diiwan galin', '2'),
(3, 'ss', NULL),
(4, 'd', NULL),
(5, 'exam Fee', NULL);

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
(14, 'Create Form', 'forms/gen_form.php', 7, 'form_sp', 'tools/insert_anny.php', 'Add'),
(15, 'Add Level', 'forms/gen_form.php', 1, 'level_sp', 'tools/insert_anny.php', 'Add'),
(16, 'Add Class', 'forms/gen_form.php', 1, 'class_sp', 'tools/insert_anny.php', 'Save'),
(17, 'Add Shift', 'forms/gen_form.php', 1, 'shift_sp', 'tools/insert_anny.php', 'Add'),
(18, 'Add Class Room', 'forms/gen_form.php', 1, 'class_room_sp', 'tools/insert_anny.php', 'Save'),
(19, 'Academic Year', 'forms/gen_form.php', 1, 'academic_year_sp', 'tools/insert_anny.php', 'Add'),
(20, 'Add Account', 'forms/gen_form.php', 2, 'account_sp', 'tools/insert_anny.php', 'Save'),
(21, 'Add Branch', 'forms/gen_form.php', 1, 'branch_sp', 'tools/insert_anny.php', 'Save'),
(22, 'Add Fee Type', 'forms/gen_form.php', 2, 'fee_type_sp', 'tools/insert_anny.php', 'Save'),
(23, 'Charge Month Fee', 'forms/gen_form.php', 2, 'charge_month_fee_sp', 'tools/insert_anny.php', 'Charge'),
(24, 'Add Exam', 'forms/gen_form.php', 3, 'exam_sp', 'tools/insert_anny.php', 'Save'),
(25, 'Branch List', 'forms/gen_report.php', 5, 'rp_branch_sp', 'tools/report.php', 'Search'),
(26, 'Student Balance', 'forms/gen_report.php', 5, 'rp_balance_p', 'tools/report.php', 'Search'),
(27, 'Receipt report', 'forms/gen_report.php', 5, 'rp_receipt_sp', 'tools/report.php', 'Search'),
(28, 'Add Exam Type', 'forms/gen_form.php', 3, 'exam_sp', 'tools/insert_anny.php', 'Add'),
(29, 'Deleted Records', 'forms/gen_report.php', 5, 'rp_deleted_sp', 'tools/report.php', 'Search'),
(30, 'Add User', 'forms/gen_form.php', 6, 'users_sp', 'tools/insert_anny.php', 'Add'),
(31, 'User Permission', 'forms/gen_report.php', 6, 'rp_permission_sp', 'tools/userpermission.php', 'Show');

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
  `required` varchar(100) DEFAULT NULL,
  `class` varchar(100) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `form_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `form_input`
--

INSERT INTO `form_input` (`id`, `type`, `label`, `name`, `placeholder`, `required`, `class`, `action`, `form_id`) VALUES
(1, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 14),
(2, 'dropdown', 'Choose Category', '_category_id', 'Enter  category id', NULL, NULL, 'category', 14),
(3, 'dropdown', ' href', '_href', 'Enter  href', NULL, NULL, 'href', 14),
(4, 'search', ' sp name', '_sp_name', 'Enter  sp name', NULL, NULL, 'sp', 14),
(5, 'dropdown', ' form action', '_form_action', 'Enter  form action', NULL, NULL, 'form_action', 14),
(6, '', ' button', '_button', 'Enter  button', NULL, NULL, NULL, 14),
(7, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 14),
(8, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 15),
(9, '', ' fee', '_fee', 'Enter  fee', NULL, NULL, NULL, 15),
(10, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 15),
(11, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 16),
(12, 'dropdown', 'Choose Level', '_level_id', 'Enter  level id', NULL, NULL, 'level', 16),
(13, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 16),
(14, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 17),
(15, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 17),
(17, 'dropdown', 'Choose Branch', '_branch_id', 'Enter  branch id', NULL, NULL, 'branch', 18),
(18, 'dropdown', 'Choose Class', '_class_id', 'Enter  class id', NULL, NULL, 'class', 18),
(19, 'dropdown', ' char', '_char', 'Enter  char', NULL, NULL, 'char', 18),
(20, 'dropdown', 'Choose Shift', '_shift_id', 'Enter  shift id', NULL, NULL, 'shift', 18),
(21, '', ' fee', '_fee', 'Enter  fee', NULL, NULL, NULL, 18),
(22, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 18),
(24, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 19),
(25, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 19),
(27, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 20),
(28, '', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 20),
(29, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 20),
(30, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 21),
(31, '', ' tell', '_tell', 'Enter  tell', NULL, NULL, NULL, 21),
(32, '', ' address', '_address', 'Enter  address', NULL, NULL, NULL, 21),
(33, '', ' admin', '_admin', 'Enter  admin', NULL, NULL, NULL, 21),
(34, '', ' admintell', '_admintell', 'Enter  admintell', NULL, NULL, NULL, 21),
(35, '', ' date', '_date', 'Enter  date', NULL, NULL, NULL, 21),
(37, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 22),
(38, '', ' branch id', '_branch_id', 'Enter  branch id', NULL, NULL, NULL, 23),
(39, '', ' month id', '_month_id', 'Enter  month id', NULL, NULL, NULL, 23),
(40, '', ' year id', '_year_id', 'Enter  year id', NULL, NULL, NULL, 23),
(41, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 23),
(45, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 24),
(46, 'dropdown', 'Choose Branch', '_branch_id', 'Enter  branch id', NULL, NULL, 'branch', 25),
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
(62, '', ' name', '_name', 'Enter  name', NULL, NULL, NULL, 28),
(63, 'dropdown', ' table', '_table', 'Enter  table', NULL, NULL, NULL, 29),
(64, 'date', ' from', '_from', 'Enter  from', NULL, NULL, NULL, 29),
(65, 'date', ' to', '_to', 'Enter  to', NULL, NULL, NULL, 29),
(66, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 29),
(70, '', ' username', '_username', 'Enter  username', NULL, NULL, NULL, 30),
(71, '', ' password', '_password', 'Enter  password', NULL, NULL, NULL, 30),
(72, 'file', ' image', '_image', 'Enter  image', NULL, NULL, NULL, 30),
(73, '', ' branch id', '_branch_id', 'Enter  branch id', NULL, NULL, NULL, 30),
(74, 'user_id', ' user id', '_user_id', 'Enter  user id', NULL, NULL, NULL, 30),
(77, 'dropdown', 'Choose User', '_user_id', 'Enter  user id', NULL, NULL, 'user', 31);

-- --------------------------------------------------------

--
-- Table structure for table `level`
--

CREATE TABLE `level` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `fee` double DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `level`
--

INSERT INTO `level` (`id`, `name`, `fee`, `user_id`) VALUES
(4, 'Sare', 12, 1),
(5, 'dhexe', 8, 1),
(7, 'Courses', 12, 2),
(8, '1', 12, 2),
(9, 'Sare6', 12, 2),
(10, 'Sare7', 12, 2),
(11, 'Sare9', 12, 2),
(12, 'Hoose1', 12, 2),
(13, 'Sare11', 12, 2),
(14, 'Sare1', 12, 2),
(15, 'saxa', 12, 2);

-- --------------------------------------------------------

--
-- Table structure for table `marks`
--

CREATE TABLE `marks` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `marks` double DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `match_class_course`
--

CREATE TABLE `match_class_course` (
  `id` int(11) NOT NULL,
  `class_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `min_marks` double DEFAULT NULL,
  `max_marks` double DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(2, 'receipt', 'edit receipt', 'edit');

-- --------------------------------------------------------

--
-- Table structure for table `parent`
--

CREATE TABLE `parent` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `tell` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Table structure for table `period`
--

CREATE TABLE `period` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT 0,
  `discount` double DEFAULT 0,
  `class_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `fee_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ref_no` int(11) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`id`, `std_id`, `amount`, `discount`, `class_id`, `branch_id`, `date`, `fee_id`, `user_id`, `ref_no`, `account_id`, `month_id`, `year_id`) VALUES
(2, 1001, 8, 6, 1, 1, '2023-03-22', 1, 1, 7, 1, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `scholarship`
--

CREATE TABLE `scholarship` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `scholarship`
--

INSERT INTO `scholarship` (`id`, `std_id`, `amount`, `description`, `user_id`, `date`, `exp_date`) VALUES
(2, 1004, 10, 'Test', 1, '2023-03-19', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `school`
--

CREATE TABLE `school` (
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
-- Dumping data for table `school`
--

INSERT INTO `school` (`id`, `name`, `tel`, `address`, `domain`, `logo`, `letter_head`, `date`) VALUES
(1, 'Banaadir Zone School', '66', 'kpp', 'locahost', 'uploads/logo.png', '', '2023-04-02 10:52:44');

-- --------------------------------------------------------

--
-- Table structure for table `shift`
--

CREATE TABLE `shift` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shift`
--

INSERT INTO `shift` (`id`, `name`, `user_id`) VALUES
(1, 'Subax', 1),
(2, 'Galab', 1),
(3, 'Subax1', 2);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `tell` int(11) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `dop` varchar(100) DEFAULT NULL,
  `bop` varchar(100) DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `age` varchar(100) DEFAULT NULL,
  `mother` varchar(100) DEFAULT NULL,
  `m_tell` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `parent_type` varchar(100) DEFAULT NULL,
  `class_room_id` int(11) DEFAULT NULL,
  `status` varchar(100) DEFAULT '1',
  `date` date DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `is_free` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `std_id`, `name`, `tell`, `address`, `dop`, `bop`, `gender`, `age`, `mother`, `m_tell`, `parent_id`, `parent_type`, `class_room_id`, `status`, `date`, `year_id`, `is_free`, `user_id`) VALUES
(3, 1001, 'Jaamac', 766576, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 1, '1', '2023-03-19', 1, '0', 1),
(4, 1002, 'Mohamed Ali', 888888, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 1, '1', '2023-03-19', 1, '0', 1),
(5, 1003, 'Hassan', 6666, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 1, '1', '2023-03-19', 1, '0', 1),
(6, 1004, 'nageeye', 6666, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 1, '1', '2023-03-19', 1, '0', 1),
(7, 1005, 'Muxsin', 6666, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 2, '1', '2023-03-19', 1, '0', 1),
(8, 1006, 'Muxsin1', 6666, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 2, '1', '2023-03-14', 1, '0', 1),
(9, 1007, 'Muxsin3', 6666, 'bakaara', '2003', 'muqdisho', 'male', '2003', '', 0, 0, '', 2, '1', '2023-03-26', 1, '1', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `student_view`
-- (See below for the actual view)
--
CREATE TABLE `student_view` (
`std_id` int(11)
,`status` varchar(100)
,`name` varchar(100)
,`tell` int(11)
,`address` varchar(100)
,`dop` varchar(100)
,`bop` varchar(100)
,`age` double
,`gender` varchar(100)
,`mother` varchar(100)
,`m_tell` int(11)
,`parent_id` int(11)
,`parent_type` varchar(100)
,`class_room_id` int(11)
,`reg_date` date
,`year_id` int(11)
,`is_free` varchar(100)
,`branch_id` int(11)
,`char_` varchar(100)
,`shift_id` int(11)
,`class_id` int(11)
,`class_fee` double
,`class_name` varchar(100)
,`level_id` int(11)
,`orders` varchar(100)
,`shift` varchar(100)
,`level_name` varchar(100)
,`level_fee` double
,`parent_name` varchar(100)
,`parent_tell` int(11)
,`amount` double
,`description` text
,`scholar_date` date
,`exp_date` date
,`username` varchar(100)
,`Name_exp_36` double
);

-- --------------------------------------------------------

--
-- Table structure for table `title`
--

CREATE TABLE `title` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transfer_student`
--

CREATE TABLE `transfer_student` (
  `id` int(11) NOT NULL,
  `std_id` int(11) DEFAULT NULL,
  `old_class_id` int(11) DEFAULT NULL,
  `new_class_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

INSERT INTO `users` (`id`, `username`, `password`, `image`, `status`, `date`, `is_online`, `branch_id`, `user_id`) VALUES
(2, 'admin', '202cb962ac59075b964b07152d234b70', NULL, 'active', '2023-04-02', NULL, 1, 1),
(3, 'ktc', '15de21c670ae7c3f6f3f1f37029303c9', 'Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 7, 2),
(4, 'j', '363b122c528f54df4a0446b6bab05515', 'uploads/Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 0, 2),
(5, 'kafiye3', 'cf79ae6addba60ad018347359bd144d2', 'uploads/Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 2, 2),
(6, 'nagey5', '0a113ef6b61820daa5611c870ed8d5ee', 'uploads/Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 8, 2),
(7, 'jkkk', 'fa7f08233358e9b466effa1328168527', 'uploads/Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 9, 2),
(8, 'kkk78', 'fa7f08233358e9b466effa1328168527', 'uploads/Daahir Poly Clinic Center.pdf', 'active', '2023-05-02', NULL, 8, 2),
(9, 'naget', 'fae0b27c451c728867a567e8c1bb4e53', 'uploads/day6.xlsx', 'active', '2023-05-02', NULL, 7, 2),
(10, 'yestt', '2fb1c5cf58867b5bbc9a1b145a86f3a0', 'uploads/n947rWL.png', 'active', '2023-05-02', NULL, 8, 2),
(11, 'yyy', '415290769594460e2e485922904f345d', 'uploads/n947rWL.png', 'active', '2023-05-02', NULL, 7, 2);

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
(33, 31, 2, 2, 'form'),
(60, 20, 2, 2, 'form'),
(61, 23, 2, 2, 'form'),
(62, 22, 2, 2, 'form'),
(63, 14, 2, 2, 'form'),
(64, 15, 2, 2, 'form'),
(65, 16, 2, 2, 'form'),
(66, 17, 2, 2, 'form'),
(67, 19, 2, 2, 'form'),
(68, 21, 2, 2, 'form'),
(69, 18, 2, 2, 'form'),
(70, 25, 2, 2, 'form'),
(71, 27, 2, 2, 'form'),
(72, 29, 2, 2, 'form'),
(73, 26, 2, 2, 'form'),
(74, 24, 2, 2, 'form'),
(75, 28, 2, 2, 'form'),
(76, 30, 2, 2, 'form');

-- --------------------------------------------------------

--
-- Structure for view `class_view`
--
DROP TABLE IF EXISTS `class_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `class_view`  AS SELECT `c`.`id` AS `class_id`, `c`.`name` AS `class`, `c`.`level_id` AS `level_id`, `c`.`orders` AS `orders`, `cr`.`branch_id` AS `branch_id`, `cr`.`id` AS `class_room_id`, `cr`.`char_` AS `char_`, `cr`.`shift_id` AS `shift_id`, `cr`.`fee` AS `class_room_fee`, `sh`.`name` AS `shift`, `l`.`name` AS `level_name`, `l`.`fee` AS `level_fee`, if(`cr`.`fee` > 0,`cr`.`fee`,`l`.`fee`) AS `fee` FROM (((`class` `c` join `class_room` `cr` on(`c`.`id` = `cr`.`class_id`)) left join `shift` `sh` on(`sh`.`id` = `cr`.`shift_id`)) left join `level` `l` on(`l`.`id` = `c`.`level_id`))  ;

-- --------------------------------------------------------

--
-- Structure for view `student_view`
--
DROP TABLE IF EXISTS `student_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `student_view`  AS SELECT `s`.`std_id` AS `std_id`, `s`.`status` AS `status`, `s`.`name` AS `name`, `s`.`tell` AS `tell`, `s`.`address` AS `address`, `s`.`dop` AS `dop`, `s`.`bop` AS `bop`, year(current_timestamp()) - `s`.`age` AS `age`, `s`.`gender` AS `gender`, `s`.`mother` AS `mother`, `s`.`m_tell` AS `m_tell`, `s`.`parent_id` AS `parent_id`, `s`.`parent_type` AS `parent_type`, `s`.`class_room_id` AS `class_room_id`, `s`.`date` AS `reg_date`, `s`.`year_id` AS `year_id`, `s`.`is_free` AS `is_free`, `cr`.`branch_id` AS `branch_id`, `cr`.`char_` AS `char_`, `cr`.`shift_id` AS `shift_id`, `cr`.`class_id` AS `class_id`, `cr`.`fee` AS `class_fee`, `c`.`name` AS `class_name`, `c`.`level_id` AS `level_id`, `c`.`orders` AS `orders`, `sh`.`name` AS `shift`, `l`.`name` AS `level_name`, `l`.`fee` AS `level_fee`, `p`.`name` AS `parent_name`, `p`.`tell` AS `parent_tell`, `sc`.`amount` AS `amount`, `sc`.`description` AS `description`, `sc`.`date` AS `scholar_date`, `sc`.`exp_date` AS `exp_date`, `u`.`username` AS `username`, CASE WHEN `cr`.`fee` > 0 THEN `cr`.`fee` WHEN `l`.`fee` > 0 THEN `l`.`fee` END AS `Name_exp_36` FROM (((((((`student` `s` left join `class_room` `cr` on(`s`.`class_room_id` = `cr`.`id`)) left join `class` `c` on(`c`.`id` = `cr`.`class_id`)) left join `shift` `sh` on(`sh`.`id` = `cr`.`shift_id`)) left join `level` `l` on(`l`.`id` = `c`.`level_id`)) left join `parent` `p` on(`p`.`id` = `s`.`parent_id`)) left join `scholarship` `sc` on(`sc`.`std_id` = `s`.`std_id`)) left join `users` `u` on(`u`.`id` = `s`.`user_id`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_year`
--
ALTER TABLE `academic_year`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `apsent_students`
--
ALTER TABLE `apsent_students`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendance_type`
--
ALTER TABLE `attendance_type`
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
-- Indexes for table `charge`
--
ALTER TABLE `charge`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `std_id` (`std_id`,`month_id`,`year_id`,`fee_id`);

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
-- Indexes for table `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `class_room`
--
ALTER TABLE `class_room`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deleted_records`
--
ALTER TABLE `deleted_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drop_out_student`
--
ALTER TABLE `drop_out_student`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drop_out_type`
--
ALTER TABLE `drop_out_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `exam`
--
ALTER TABLE `exam`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fee_type`
--
ALTER TABLE `fee_type`
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
-- Indexes for table `level`
--
ALTER TABLE `level`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marks`
--
ALTER TABLE `marks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `match_class_course`
--
ALTER TABLE `match_class_course`
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
-- Indexes for table `parent`
--
ALTER TABLE `parent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pay_salary`
--
ALTER TABLE `pay_salary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `period`
--
ALTER TABLE `period`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `scholarship`
--
ALTER TABLE `scholarship`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `school`
--
ALTER TABLE `school`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shift`
--
ALTER TABLE `shift`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `title`
--
ALTER TABLE `title`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transfer_student`
--
ALTER TABLE `transfer_student`
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
-- AUTO_INCREMENT for table `academic_year`
--
ALTER TABLE `academic_year`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `apsent_students`
--
ALTER TABLE `apsent_students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attendance_type`
--
ALTER TABLE `attendance_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `charge`
--
ALTER TABLE `charge`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `charge_salary`
--
ALTER TABLE `charge_salary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `charts`
--
ALTER TABLE `charts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `class`
--
ALTER TABLE `class`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `class_room`
--
ALTER TABLE `class_room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deleted_records`
--
ALTER TABLE `deleted_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `drop_out_student`
--
ALTER TABLE `drop_out_student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drop_out_type`
--
ALTER TABLE `drop_out_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exam`
--
ALTER TABLE `exam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `fee_type`
--
ALTER TABLE `fee_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `forms`
--
ALTER TABLE `forms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `form_input`
--
ALTER TABLE `form_input`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `level`
--
ALTER TABLE `level`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `marks`
--
ALTER TABLE `marks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `match_class_course`
--
ALTER TABLE `match_class_course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `months`
--
ALTER TABLE `months`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `other_table`
--
ALTER TABLE `other_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `parent`
--
ALTER TABLE `parent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pay_salary`
--
ALTER TABLE `pay_salary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `period`
--
ALTER TABLE `period`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `scholarship`
--
ALTER TABLE `scholarship`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `school`
--
ALTER TABLE `school`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shift`
--
ALTER TABLE `shift`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `title`
--
ALTER TABLE `title`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfer_student`
--
ALTER TABLE `transfer_student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `updated_records`
--
ALTER TABLE `updated_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_form`
--
ALTER TABLE `user_form`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
