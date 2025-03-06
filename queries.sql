-- # In this SQL file, write (and comment!) the typical SQL queries users will run on your database


-- # new client
PREPARE `new_client` FROM
    '
    INSERT INTO `clients` (`name`, `phone`, `document`, `email`)
    VALUES (?, ?, ?, ?)
    ';
    
    -- # examples
    SET @name = 'John', @phone = '8399605757', @document= '123456', @email = 'john@gmail.com';
    EXECUTE new_client USING @name, @phone, @document, @email ;
    SET @name = 'Carter', @phone = '839985478', @document= '123456', @email = 'carter@gmail.com';
    EXECUTE new_client USING @name, @phone, @document, @email ;
    SET @name = 'Kyle', @phone = '8399605757', @document= '123456', @email = 'kyle@gmail.com';
    EXECUTE new_client USING @name, @phone, @document, @email ;
 

-- # new room
PREPARE `create_room` FROM
    '
    INSERT INTO `rooms` (`name`, `hour_price`)
    VALUES(?, ?)
    ';
    -- # example
    SET @name = 'room 1', @price = 22.00;
    EXECUTE `create_room` USING @name, @price;
    SET @name = 'room 2', @price = 22.00;
    EXECUTE `create_room` USING @name, @price;
    SET @name = 'room 3', @price = 22.00;
    EXECUTE `create_room` USING @name, @price;
    SET @name = 'room 4', @price = 22.00;
    EXECUTE `create_room` USING @name, @price;
    
-- # buy time
PREPARE `buy_time` FROM
    '
    UPDATE time_accounts
    SET `time_balance` = `time_balance` + ?
    WHERE client_id = ?
    ';
    -- # example
    SET @time_balance = 8,  @client_id = 1;
    EXECUTE `buy_time` USING @time_balance, @client_id;
    
    SET @time_balance = 8,  @client_id = 2;
    EXECUTE `buy_time` USING @time_balance, @client_id;
    
    SET @time_balance = 8,  @client_id = 3;
    EXECUTE `buy_time` USING @time_balance, @client_id;

-- # reserve a room
PREPARE `reserve_room` FROM
    '
    INSERT INTO `reservations` (`client_id`, `room_id`, `datetime`, `time_reserved`)
    VALUES( ?, ?, ?, ?)
    ';

    -- #  example
    SET @client_id = 1, @room_id = 1, @datetime = NOW(), @time_reserved = 2;
    EXECUTE `reserve_room` USING @client_id, @room_id, @datetime, @time_reserved;
    SET @client_id = 2, @room_id = 2, @datetime = NOW(), @time_reserved = 2;
    EXECUTE `reserve_room` USING @client_id, @room_id, @datetime, @time_reserved;
    SET @client_id = 3, @room_id = 3, @datetime = NOW(), @time_reserved = 2;
    EXECUTE `reserve_room` USING @client_id, @room_id, @datetime, @time_reserved;

-- # show all clients with time account
SELECT * FROM `clients_accounts`;

-- # show all clients reservations
SELECT * FROM `clients_reservations`;

-- # show all rooms reservations    
SELECT * FROM `rooms_reservations`;

