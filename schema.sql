-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it


-- triggers and functions
---- when a client reserve a room, the amount of hour will be substract from time_account of the client
DELIMITER //
CREATE TRIGGER update_time_account AFTER INSERT ON `reservations`
FOR EACH ROW
BEGIN
    UPDATE `time_accounts`
    SET `time_amount` = `time_amount` - NEW.`total_hours`
    WHERE `client_id` = NEW.`client_id`;
END //
DELIMITER ;

---- when insert a new client, create a time_account associated
DELIMITER //
CREATE TRIGGER create_time_account AFTER INSERT ON `clients`
FOR EACH ROW
BEGIN
    INSERT INTO `time_accounts` (`client_id`, `time_amount`, `expire_date`, `start_date`)
    VALUES (NEW.id, 0, NextYear(), CURDATE());
END //
DELIMITER ;

---- calculete next year. this functions its for measure expire date
DELIMITER //
CREATE FUNCTION IF NOT EXISTS `NextYear`() RETURNS DATE
DETERMINISTIC
BEGIN
    RETURN CURDATE() + INTERVAL 1 YEAR;
END //
DELIMITER ;


-- Create entitys tables

---- client entity
---- client reserve rooms by hour
CREATE TABLE IF NOT EXISTS `clients`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100),
    `phone` VARCHAR(20),
    `document` VARCHAR(20),
    `email` VARCHAR(100),
    PRIMARY KEY (`id`)
);


---- room entity
---- rooms area reserved by clients
CREATE TABLE IF NOT EXISTS `rooms`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10),
    `hour_price` DECIMAL(5,2) NOT NULL,
    `available` BOOLEAN DEFAULT(TRUE),
    PRIMARY KEY(`id`)
);

---- time account of each clients
---- to use a room the client need time in a account. like a bank
CREATE TABLE IF NOT EXISTS `time_accounts`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `client_id` INT NOT NULL,
    `hours_amount` INT NOT NULL,
    `expire_date` DATE DEFAULT (NextYear()),
    `start_date` DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES `clients`(`id`)
);


-- associative tables
---- reservation association
---- to use a room the client need to reserve a room

CREATE TABLE IF NOT EXISTS `reservations`(
    `id` INT NOT NULL AUTO_INCREMENT,
    `client_id` INT NOT NULL,
    `room_id` INT NOT NULL,
    `datetime` DATETIME NOT NULL DEFAULT(CURRENT_DATETIME),
    `total_hours` TINYINT, -- ammount of hours
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES `clients`(`id`),
    FOREIGN KEY(`room_id`) REFERENCES `rooms`(`id`)
);
