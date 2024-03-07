-- Step 1: Create the table

CREATE SEQUENCE unwindexample_seq;

CREATE TABLE unwindexample (
    id INTEGER PRIMARY KEY,
    original_id VARCHAR(24),
    item VARCHAR(50),
    uom VARCHAR(10),
    h INTEGER,
    w INTEGER
);

CREATE OR REPLACE FUNCTION generate_new_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.id = NEXTVAL('unwindexample_seq');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_new_id_trigger
BEFORE INSERT ON unwindexample
FOR EACH ROW
EXECUTE FUNCTION generate_new_id();


-- Step 2: Insert the values
INSERT INTO unwindexample (original_id, item, uom, h, w) VALUES
('65e883c62686b2d68a2c670f', 'journal', 'cm', 1, 4),
('65e883c62686b2d68a2c670f', 'journal', 'cm', 1, 5),
('65e883c62686b2d68a2c670f', 'journal', 'cm', 2, 4),
('65e883c62686b2d68a2c670f', 'journal', 'cm', 2, 5),
('65e883c62686b2d68a2c6710', 'notebook', 'in', 10, 20),
('65e883c62686b2d68a2c6710', 'notebook', 'in', 10, 40),
('65e883c62686b2d68a2c6710', 'notebook', 'in', 12, 20),
('65e883c62686b2d68a2c6710', 'notebook', 'in', 12, 40);
