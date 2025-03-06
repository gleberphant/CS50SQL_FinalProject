-- # In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

DROP DATABASE IF EXISTS `CS50SQL`;
CREATE DATABASE IF NOT EXISTS `CS50SQL`;
USE `CS50SQL`;	

-- # Create entitys tables
-- ## client entity: client reserve rooms by hour
CREATE TABLE IF NOT EXISTS `clients`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100),
    `phone` VARCHAR(20),
    `document` VARCHAR(20),
    `email` VARCHAR(100),
    PRIMARY KEY (`id`)
);

-- ## room entity : rooms area reserved by clients
CREATE TABLE IF NOT EXISTS `rooms`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10),
    `hour_price` DECIMAL(5,2) NOT NULL CHECK (hour_price >= 0),
    `description` TEXT,
    `available` BOOLEAN DEFAULT(TRUE),
    PRIMARY KEY(`id`)
);

-- ## time account of each clients:  to use a room the client need time in a account. like a bank
CREATE TABLE IF NOT EXISTS `time_accounts`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `client_id` INT NOT NULL,
    `time_balance` INT NOT NULL CHECK(`time_balance` >= 0),
    `expire_date` DATE,
    `start_date` DATE DEFAULT (NOW()),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES `clients`(`id`) ON DELETE CASCADE
);


-- # associative tables
-- ## reservation association:  to use a room the client need to reserve a room
CREATE TABLE IF NOT EXISTS `reservations`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `client_id` INT NOT NULL,
    `room_id` INT NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT(NOW()),
    `time_reserved` TINYINT NOT NULL DEFAULT(1) CHECK(`time_reserved` >= 1),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES `clients`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`room_id`) REFERENCES `rooms`(`id`) ON DELETE CASCADE
);

-- #create triggers
-- ## update_time_account: when a client reserve a room, the amount of hour will be substract from time_account of the client
DELIMITER //
CREATE TRIGGER `update_time_account` BEFORE INSERT ON `reservations`
FOR EACH ROW
BEGIN
    DECLARE balance INT;
    
    SELECT `time_balance` INTO balance
    FROM `time_accounts`
    WHERE `client_id` = NEW.`client_id`;
    
    IF balance < NEW.`time_reserved` THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient time balance';
    ELSE
        UPDATE `time_accounts`
        SET `time_balance` = `time_balance` - NEW.`time_reserved`
        WHERE `client_id` = NEW.`client_id`;
    END IF
END //
DELIMITER ;

-- ## create_time_account: when insert a new client, create a time_account associated
DELIMITER //
CREATE TRIGGER `create_time_account` AFTER INSERT ON `clients`
FOR EACH ROW
BEGIN
    INSERT INTO `time_accounts` (`client_id`, `time_balance`, `expire_date`, `start_date`)
    VALUES (NEW.id, 0, NextYear(), CURDATE());
END //
DELIMITER ;

-- #create functions
-- ## calculete next year: this functions its for measure expire date

DELIMITER //
CREATE FUNCTION IF NOT EXISTS `NextYear`() RETURNS DATE
DETERMINISTIC
BEGIN
    RETURN CURDATE() + INTERVAL 1 YEAR;
END //
DELIMITER ;

-- #create indexes
-- ## `reservation_client_id`: to search reservations by client by id
CREATE INDEX `reservation_client_id` ON `reservations`(`client_id`);

-- ## `reservation_room_id`: to search reservations by room by id
CREATE INDEX `reservation_room_id` ON `reservations`(`room_id`);

-- ## `time_account_client_id`: to search time account by client by id
CREATE INDEX `time_account_client_id` ON `time_accounts`(`client_id`);

-- ## `client_name`: to search client by name
CREATE INDEX `client_name`ON `clients`(`name`);


-- #create views
-- ## to show all clients with time account
CREATE VIEW `clients_accounts` AS
    SELECT 
        `clients`.`id` as cliente_id, 
        `clients`.`name`,
        `clients`.`phone`,
        `clients`.`document`,
        `clients`.`email`,
        `time_accounts`.`time_balance`,
        `time_accounts`.`expire_date`,
        `time_accounts`.`start_date`
    FROM `clients`  
    JOIN `time_accounts` ON `clients`.`id` = `time_accounts`.`client_id`;   

-- ## to show all clients reservations
CREATE VIEW `clients_reservations` AS
    SELECT 
        `clients`.`name` as `client_name`,
        `clients`.`phone`,
        `clients`.`document`,
        `clients`.`email`,
        `reservations`.`datetime`,
        `reservations`.`time_reserved`,
        `rooms`.`name` as `room_name`,
        `rooms`.`hour_price`,
        `rooms`.`available`,
        `rooms`.`description`,
        (`reservations`.`time_reserved` * `rooms`.`hour_price`) as `total_price`
    FROM `clients`
    JOIN `reservations` ON `clients`.`id` = `reservations`.`client_id`
    JOIN `rooms` ON `rooms`.`id` =  `reservations`.`room_id`;

-- ## to show all rooms reservations
CREATE VIEW `rooms_reservations` AS
    SELECT 
        `clients`.`name` as `client_name`,
        `clients`.`phone`,
        `clients`.`document`,
        `clients`.`email`,
        `reservations`.`datetime`,
        `reservations`.`time_reserved`,
        `rooms`.`id` as `id_room`,
        `rooms`.`name` as `room_name`,
        `rooms`.`hour_price`,
        `rooms`.`available`,
        `rooms`.`description`,
        (`reservations`.`time_reserved` * `rooms`.`hour_price`) as `total_price`
    FROM `rooms`
    JOIN `reservations` ON `rooms`.`id` = `reservations`.`room_id`
    JOIN `clients` ON `clients`.`id` = `reservations`.`client_id`;