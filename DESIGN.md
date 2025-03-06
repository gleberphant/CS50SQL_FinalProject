# Design Document

By HANDERSON GLEBER DE LIMA CAVALCANTI

Video overview: <URL HERE>

## Scope

### What is the purpose of your database?

 The purpose of the database is to manage room reservations in a cowork and track client time balances,.

### Which people, places, things, etc. are you including in the scope of your database?

- **Clients**: their identification, contact details, and time balances.
- **Rooms**: their availability, hourly rates, and reservation status.
- **Reservations**: linking clients to specific rooms for designated time periods.

### Which people, places, things, etc. are *outside* the scope of your database?

- Detailed financial transactions (e.g., payment methods, invoices)
- Room maintenance and inventory (e.g., cleaning schedules, equipment tracking)
- Advanced client interactions (e.g., communication logs, support tickets)

## Functional Requirements

### What should a user be able to do with your database?

- **Manage Clients:** Add new clients with their information, Update existing client details, View client lists and individual client information.
- **Manage Rooms:** Add new rooms with pricing and availability, Update room details, View room lists and individual room information.
- **Manage Reservations:** Make new reservations for clients, assigning rooms and durations,View and update existing reservations, Cancel reservations.
- **Manage Time Accounts:** View client time balances, Add time to client accounts.


### What's beyond the scope of what a user should be able to do with your database?

- **Financial Operations:** Processing payments or generating invoices. Accessing detailed financial reports.
- **Employee Management:** Managing staff schedules or payroll. Accessing employee performance data.
- **Room Maintenance:** Scheduling cleaning or repairs. Managing room inventory or equipment.

## Representation

### Entities

#### Which entities will you choose to represent in your database?**
- Clients
- Rooms
- Time Accounts
- Reservations

#### What attributes will those entities have?
- **Clients**: id, name, phone, document, email
- **Rooms**: id, name,description hour_price, available
- **Time Accounts**: id, client_id, time_balance, expire_date, start_date
- **Reservations**: id, client_id, room_id, datetime, total_hours

#### Why did you choose the types you did?
The types were chosen to accurately represent the data:

- **VARCHAR** for names, phone numbers, etc.
- **INT** for IDs and time amounts.
- **DECIMAL** for the hourly price.
- **BOOLEAN** for room availability.
- **DATETIME** for reservation time.

#### Why did you choose the constraints you did?
- **NOT NULL** enforces required fields.
- **AUTO_INCREMENT** for automatic ID generation.
- **PRIMARY KEY** uniquely identifies each record.
- **FOREIGN KEY** establishes relationships between tables.
- **DEFAULT** provides default values for certain fields.
- **CHECK** constraints to verify values more than zero for time balance and reserved hours

### Relationships

#### Entity relationship diagram .
![ER Diagram](diagram.png)

#### Relationships between the entities in your database
- One cliente can made one or more reservation.
- A reservation refer to one especific room.
- A room can has none or multiply reservations.
- A cliente have a time_account.
- Everytime a client made a reservátion the total hours are subtracted from time balance of the time account of the client,  if the time reserved is less than time balance of the client.

## Optimizations

### Which optimizations (e.g., indexes, views) did you create? Why?

- **INDEXES**
    - `reservation_client_id`: to search reservations by client by id
    - `reservation_room_id`: to search reservations by room by id
    - `time_account_client_id`: to search de time account of the client by id
    - `client_name`: to search clients by name

- **VIEWS**
    - `clients_accounts` : to show all clients with time account
    - `clients_reservations`: to show all clients reservations
    - `rooms_reservations` : to show all rooms reservations

- **TRIGGERS**
    - `update_time_account`: when a client reserve a room, substract the reserve hour from time balance of the client if time reserved is less than time balance of the client. 
    - `create_time_account`: when insert a new client, create a time_account associated

- **FUNCTIONS**
    - `NextYear`(): to measure expire date

## Limitations

### What are the limitations of your design?
- Assumes all time is used in whole hours, might not be suitable for tracking minutes.
- Lacks details like room size, capacity, or specific features (e.g., projector, whiteboard).
- Can't easily handle reservations that repeat regularly.
- Limited to basic contact details, no address or other demographics.

### What might your database not be able to represent very well?

- Difficult to handle discounts, variable rates, different pricing tiers and complex pricing models.
- No built-in mechanism to prevent double-booking a room.
- Can't easily track partial hours or specific usage patterns within a room.
- Can't handle reservations for other resources like equipment or services.
- Can't represent Financial Operations like Processing payments or generated invoices.
- Can't represent Room Maintenance like Scheduling cleaning or repairs 
