CREATE VIEW item_size_view AS
SELECT
    _id,
    item,
    qty,
    size->>'h' AS height,
    size->>'w' AS width,
    size->>'uom' AS uom,
    CASE 
        WHEN size->'type' IS NOT NULL THEN size->'type'->>'uom' 
        ELSE NULL 
    END AS type_uom,
    status
FROM shop;