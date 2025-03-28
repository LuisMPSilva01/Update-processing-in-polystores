CREATE SERVER "MongoDB server" FOREIGN DATA WRAPPER mongo_fdw OPTIONS (
  address 'updt_process_mongo_container',
  port '27017'
);

GRANT USAGE ON FOREIGN SERVER "MongoDB server" TO root;

CREATE USER MAPPING FOR root SERVER "MongoDB server" OPTIONS (
  username 'admin',
  password 'admin'
);

CREATE FOREIGN TABLE players (
  _id name,
  name text,
  address text,
  club text,
  contact JSON
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'Players'
);