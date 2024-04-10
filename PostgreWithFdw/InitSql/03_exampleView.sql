CREATE SERVER "MongoDB server" FOREIGN DATA WRAPPER mongo_fdw OPTIONS (
  address 'updt_process_mongo_container',
  port '27017'
);

GRANT USAGE ON FOREIGN SERVER "MongoDB server" TO root;

CREATE USER MAPPING FOR root SERVER "MongoDB server" OPTIONS (
  username 'admin',
  password 'admin'
);

CREATE FOREIGN TABLE gorda (
  _id name,
  original_id name,
  item text,
  qty int,
  h float,
  w float,
  uom text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'gorda'
);

CREATE FOREIGN TABLE PlayersDenormalized (
  _id name,
  name text,
  address text,
  club text,
  contact text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'Playersgorda'
);

CREATE FOREIGN TABLE PlayersBase (
  _id name,
  name text,
  address text,
  club text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'PlayersBase'
);

CREATE FOREIGN TABLE PlayersContacts (
  _id name,
  name text,
  contact text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'Contacts'
);