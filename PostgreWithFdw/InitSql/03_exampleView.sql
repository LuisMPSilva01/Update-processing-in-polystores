CREATE SERVER "MongoDB server" FOREIGN DATA WRAPPER mongo_fdw OPTIONS (
  address 'updt_process_mongo_container',
  port '27017'
);

GRANT USAGE ON FOREIGN SERVER "MongoDB server" TO root;

CREATE USER MAPPING FOR root SERVER "MongoDB server" OPTIONS (
  username 'admin',
  password 'admin'
);

CREATE FOREIGN TABLE zips (
  _id name,
  city text,
  pop int,
  state text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'zips'
);

CREATE FOREIGN TABLE cities (
  _id name,
  name text,
  address text,
  phone text,
  nationkey int
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'cities'
);
CREATE FOREIGN TABLE shop (
  _id name,
  item text,
  qty int,
  size json,
  status text
) SERVER "MongoDB server" OPTIONS (
    database 'test',
        collection 'shop'
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

