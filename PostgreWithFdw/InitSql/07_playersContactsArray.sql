/*CREATE TABLE players (
    address VARCHAR,
    name VARCHAR PRIMARY KEY
);

CREATE TABLE players_contact (
    contactId INTEGER PRIMARY KEY,
    phone VARCHAR,
    name VARCHAR,
    FOREIGN KEY (name) REFERENCES players(name),
    email VARCHAR
);

INSERT INTO players (address, name) VALUES ('Porto', 'Marega');
INSERT INTO players_contact (contactId, phone, name, email) VALUES (1, '123', 'Marega', NULL);
INSERT INTO players_contact (contactId, phone, name, email) VALUES (2, NULL, 'Marega', 'Marega@gmail.com');
INSERT INTO players_contact (contactId, phone, name, email) VALUES (3, NULL, 'Marega', 'portoMarega@gmail.com');*/
