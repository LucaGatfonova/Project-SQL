/*База данных обеспечивает подсчёт продаж и подключений физических и юридических лиц к разным услугам.
Решаемые задачи:
1. подсчёт количественных показателей по организации и по группам,ФИО
2. подсчёт заработной платы по ФИО
3. Анализ эффективности групп
4. Выгрузка заработной платы для начисления
*/
-- База данных Реестр
DROP DATABASE IF EXISTS registry;
CREATE DATABASE registry;
USE registry;

-- Организация
DROP TABLE IF EXISTS organization;
CREATE TABLE organization (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_org VARCHAR(50)
 );
 
-- Службы по функционалу
DROP TABLE IF EXISTS service;
CREATE TABLE service (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_service VARCHAR(50)
 );

-- Официально сформированные отделы
DROP TABLE IF EXISTS department;
CREATE TABLE department (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_department VARCHAR(50),
    service_id BIGINT UNSIGNED NOT NULL,
    organization_id BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (service_id) REFERENCES service(id),
    FOREIGN KEY (organization_id) REFERENCES organization(id)
 );

-- Направления, какую услугу подключают и продают
DROP TABLE IF EXISTS direction;
CREATE TABLE direction (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_direction VARCHAR(50)
 );
 
-- Вид проведенных работ
DROP TABLE IF EXISTS job;
CREATE TABLE job (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_job VARCHAR(50)
 );

-- Расценки за определенный вид работ по службам
DROP TABLE IF EXISTS tariff;
CREATE TABLE tariff (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    job_id BIGINT UNSIGNED NOT NULL,
    direction_id BIGINT UNSIGNED NOT NULL,
    service_id BIGINT UNSIGNED NOT NULL,
    valid DATE,
    value FLOAT,
        
    FOREIGN KEY (service_id) REFERENCES service(id),
    FOREIGN KEY (job_id) REFERENCES job(id),
    FOREIGN KEY (direction_id) REFERENCES direction(id)
 );

 -- Официально числящиеся сотрудники
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50),
    surname VARCHAR(50),
    patronymic VARCHAR(50),
    employee_number BIGINT UNSIGNED NOT NULL,
    organization_id BIGINT UNSIGNED NOT NULL,
    department_id BIGINT UNSIGNED NOT NULL,
    
    INDEX employee_name_surname_patronymic_idx(name, surname, patronymic),
    FOREIGN KEY (organization_id) REFERENCES organization(id),
    FOREIGN KEY (department_id) REFERENCES department(id)
 );

/*Подключаемое лицо:Физическое лицо, юридическое лицо*/
DROP TABLE IF EXISTS person;
CREATE TABLE person (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	title_person VARCHAR(50)
 );

-- Населенный пункт, в котором выполнена работа, относящийся к определенной организации 
DROP TABLE IF EXISTS settlement;
CREATE TABLE settlement (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title_settlement VARCHAR(50),
    organization_id BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (organization_id) REFERENCES organization(id)
 );

-- Количество выполненных работ
DROP TABLE IF EXISTS quantity_work;
CREATE TABLE quantity_work (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    employee_id BIGINT UNSIGNED NOT NULL,
    service_id BIGINT UNSIGNED NOT NULL,
    job_id BIGINT UNSIGNED NOT NULL,
    direction_id BIGINT UNSIGNED NOT NULL,
    person_id BIGINT UNSIGNED NOT NULL,
    settlement_id BIGINT UNSIGNED NOT NULL,
    quantity BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (service_id) REFERENCES service(id),
    FOREIGN KEY (job_id) REFERENCES job(id),
    FOREIGN KEY (direction_id) REFERENCES direction(id),
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (settlement_id) REFERENCES settlement(id)
 );

INSERT INTO organization VALUES
('1','Уфа'),
('2','Оренбург'),
('3','Казань');

INSERT INTO settlement VALUES
('1', 'Благовещенск', '1'),
('2', 'Иглино', '1'),
('3', 'Саракташ', '2'),
('4', 'Сорочинск', '2'),
('5', 'Пестрецы', '3'),
('6', 'Лаишево', '3');

INSERT INTO service VALUES
('1', 'Инженеры'),
('2', 'Менеджеры');

INSERT INTO department VALUES
('1', 'Группа 1', '1','1'),
('2', 'Группа 2', '1','1'),
('3', 'Район 1', '2','1'),
('4', 'Район 2', '2','1'),
('5', 'Группа Альфа', '1','2'),
('6', 'Группа Бета', '1','2'),
('7', 'Район Альфа', '2','2'),
('8', 'Район Бета', '2','2'),
('9', 'Группа Север', '1','3'),
('10', 'Группа Юг', '1','3'),
('11', 'Район Север', '2','3'),
('12', 'Район Юг', '2','3');

INSERT INTO direction VALUES
('1', 'Интернет'),
('2', 'Телевидение');

INSERT INTO job VALUES
('1', 'Подключение'),
('2', 'Продажа');

INSERT INTO tariff VALUES
('1','1','1','1','2020-01-01','300'),
('2','1','1','2','2020-01-01','300'),
('3','2','1','1','2020-01-01','500'),
('4','2','1','2','2020-01-01','150'),
('5','2','2','1','2020-01-01','600'),
('6','2','2','2','2020-01-01','200');

INSERT INTO person VALUES
('1', 'физическое лицо'),
('2', 'юридическое лицо');

INSERT INTO employee VALUES
('1','Иванов','Петр','Васильевич','453','1','1'),
('2','Сидоров','Максим','Витальевич','897','1','1'),
('3','Жуков','Афанас','Петрович','555','1','2'),
('4','Павлов','Виктор','Маратович','899','1','2'),
('5','Галкин','Велор','Улебович','285','2','5'),
('6','Хохлов','Елисей','Парфеньевич','789','2','5'),
('7','Васильев','Прохор','Валерьянович','739','2','6'),
('8','Белов','Ермак','Федосеевич','819','2','6'),
('9','Попов','Владислав','Михайлович','134','3','9'),
('10','Гаврилов','Герман','Алексеевич','171','3','9'),
('11','Ширяев','Антон','Эльдарович','303','3','10'),
('12','Фадеев','Вячеслав','Русланович','323','3','10'),
('13','Королёва','Октябрина','Геннадьевна','372','1','3'),
('14','Иванкова','Алла','Романовна','509','1','3'),
('15','Виноградова','Лилия','Наумовна','569','1','4'),
('16','Мясникова','Авигея','Данииловна','693','1','4'),
('17','Зыкова','Лилу','Валерьевна','704','2','7'),
('18','Лаврентьева','Дарина','Юлиановнач','732','2','7'),
('19','Евсеева','Юнона','Ильяовна','772','2','8'),
('20','Куликова','Амина','Ивановна','774','2','8'),
('21','Миронова','Эля','Святославовна','805','3','11'),
('22','Дементьева','Мирра','Кимовна','931','3','11'),
('23','Романова','Виолетта','Германовна','640','3','12'),
('24','Самойлова','Фаиза','Мироновна','970','3','12');

INSERT INTO quantity_work VALUES
('1','1','1','1','1','1','1','5','2020-01-15'),
('2','5','1','1','2','1','3','2','2020-01-15'),
('3','6','1','1','1','2','4','1','2020-01-15'),
('4','9','1','2','2','1','5','4','2020-01-15'),
('5','24','2','2','1','1','6','9','2020-01-15');

-- Какие сотрудники числятся в организации Уфа 
SELECT employee_number, name,surname, patronymic FROM employee
WHERE organization_id = 1;


-- Отчет по продажам
CREATE VIEW sales AS
SELECT 
	SUM(quantity) AS sales
FROM quantity_work WHERE job_id = 2;

SELECT * FROM sales;


-- Численность сотрудников в каждой организации
CREATE VIEW number_of_employees AS
SELECT COUNT(id) AS number_of_employees,(SELECT title_org FROM organization WHERE id =  organization_id)
	FROM employee
	GROUP BY organization_id;
	
SELECT * FROM number_of_employees;


-- Выполненные работы с детализацией по сотруднику
CREATE VIEW works AS
SELECT name, surname, patronymic, employee_number, title_job, quantity
FROM quantity_work
	JOIN employee ON quantity_work.employee_id = employee.id
	JOIN job ON quantity_work.job_id = job.id;

SELECT * FROM works;


DELIMITER //

CREATE TRIGGER quantity_work_created_at
BEFORE INSERT ON quantity_work
FOR EACH ROW
	SET NEW.created_at = NOW();


DELIMITER ;


DROP PROCEDURE IF EXISTS wages;

DELIMITER //

CREATE PROCEDURE wages()
	SELECT name AS "Имя", surname AS "Фамилия", patronymic AS "Отчество", employee_number AS "Табельный номер", title_service AS "Служба",
	title_job AS "Работа", title_direction AS "Направление", quantity AS "Количество", value AS "Расценка", (quantity*value) AS "Итого"
		FROM quantity_work
			JOIN employee ON quantity_work.employee_id = employee.id
			JOIN job ON quantity_work.job_id = job.id
			JOIN service ON quantity_work.service_id = service.id
			JOIN direction ON quantity_work.direction_id = direction.id
			JOIN tariff
			GROUP BY employee.id;

DELIMITER ;

CALL registry.wages()



