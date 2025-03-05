-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database


--- new client
PREPARE `new_client` FROM
    '
    INSERT INTO `clients` (`name`, `phone`, `document`, `email`)
    VALUES (?, ?, ?, ?)
    ';
    -- example
    EXECUTE new_client USING 'John', '8399605757', '123456', 'john@gmail.com';

--- new room
PREPARE `create_room` FROM
    '
    INSERT INTO `rooms` (`name`, `hour_price`)
    VALUES(?, ?)
    ';
    --example
    EXECUTE create_room USING 'room 1', 22.00;

--- buy time
PREPARE `buy_time` FROM
    '
    UPDATE time_accounts
    SET `hours_amount` = `hours_amount` + ?
    WHERE client_id = ?
    ';
    --example
    EXECUTE buy_time USING 8, (SELECT `id`  FROM `clients` LIMIT 1);


--- reserve a room
PREPARE `reserve_room` FROM
    '
    INSERT INTO `reservations` (`client_id`, `room_id`, `datetime`, `total_hours`)
    VALUES( ?, ?, ?, ?)
    ';

    -- example
    EXECUTE reserve_room
    USING
        (SELECT `id` FROM `clients` LIMIT 1),
        (SELECT `id` FROM `rooms` LIMIT 1),
        NOW(),
        1;
