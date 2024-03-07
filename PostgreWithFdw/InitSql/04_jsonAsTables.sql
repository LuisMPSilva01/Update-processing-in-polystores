/*CREATE TABLE items (
    item_id INT,
    item VARCHAR(100),
    qty INTEGER,
    PRIMARY KEY(item_id)
);

CREATE TABLE items_size (
    items_size_id INT,
    item_id INT,
    uom VARCHAR(100),
    PRIMARY KEY(items_size_id),
    CONSTRAINT fk_item_id
      FOREIGN KEY(item_id) 
	  REFERENCES items(item_id)
	  ON DELETE SET NULL
);

CREATE TABLE items_size_h (
    items_size_h_id INT,
    items_size_id INT,
    h FLOAT8,
    PRIMARY KEY(items_size_h_id),
    CONSTRAINT fk_items_size_id
      FOREIGN KEY(items_size_id) 
	  REFERENCES items_size(items_size_id)
	  ON DELETE SET NULL
);

CREATE TABLE items_size_w (
    items_size_w_id INT,
    items_size_id INT,
    w FLOAT8,
    PRIMARY KEY(items_size_w_id),
    CONSTRAINT fk_items_size_id
      FOREIGN KEY(items_size_id) 
	  REFERENCES items_size(items_size_id)
	  ON DELETE SET NULL
);

-- Inserting data into items table
INSERT INTO items (item_id, item, qty)
VALUES
    (1, 'journal', 25),
    (2, 'notebook', 50),
    (3, 'paper', 100),
    (4, 'planner', 75),
    (5, 'postcard', 45);

-- Inserting data into items_size table
INSERT INTO items_size (items_size_id, uom, item_id)
VALUES
    (1, 'cm', 1),
    (2, 'in', 2),
    (3, 'in', 3),
    (4, 'cm', 4),
    (5, 'cm', 5);

-- Inserting data into items_size_h table
INSERT INTO items_size_h (items_size_h_id,items_size_id, h)
VALUES
    (1,1, 14),
    (2,1, 15),
    (3,1, 16),
    (4,2, 8.5),
    (5,2, 9.5),
    (6,2, 11.5),
    (7,3, 7.5),
    (8,3, 8.5),
    (9,4, 22.85),
    (10,5, 10),
    (11,5, 12),
    (12,5, 14);

-- Inserting data into items_size_w table
INSERT INTO items_size_w (items_size_w_id,items_size_id, w)
VALUES
    (1,1, 4),
    (2,1, 5),
    (3,2, 1),
    (4,2, 2),
    (5,3, 4),
    (6,4, 14),
    (7,4, 15),
    (8,4, 16),
    (9,5, 7);
[ 
  { "item": "journal", "qty": 25, "size": { "h": [14,15,16],  "w": [4,5], "uom": "cm" }},
  { "item": "notebook", "qty": 50, "size": { "h": [8.5,9.5,11.5], "w": [1,2], "uom": "in" }},
  { "item": "paper", "qty": 100, "size": { "h": [7.5,8.5],"w": 4, "uom": "in" }},
  { "item": "planner", "qty": 75, "size": { "h": 22.85, "w": [14,15,16],"uom": "cm" }},
  { "item": "postcard", "qty": 45, "size": { "h": [10,12,14], "w": 7,"uom": "cm"}}
]
*/