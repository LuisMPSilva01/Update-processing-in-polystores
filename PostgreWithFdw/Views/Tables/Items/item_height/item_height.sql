-- Program is validated --
CREATE OR REPLACE VIEW public.item_height AS 
SELECT __dummy__.COL0 AS ORIGINAL_ID,__dummy__.COL1 AS HEIGHT 
FROM (SELECT item_height_a2_0.COL0 AS COL0, item_height_a2_0.COL1 AS COL1 
FROM (SELECT gorda_a7_0.ORIGINAL_ID AS COL0, gorda_a7_0.H AS COL1 
FROM public.gorda AS gorda_a7_0  ) AS item_height_a2_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__item_height_detected_deletions (txid int, LIKE public.item_height );
CREATE INDEX IF NOT EXISTS idx__dummy__item_height_detected_deletions ON public.__dummy__item_height_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__item_height_detected_insertions (txid int, LIKE public.item_height );
CREATE INDEX IF NOT EXISTS idx__dummy__item_height_detected_insertions ON public.__dummy__item_height_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.item_height_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__item_height_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__item_height_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.item_height"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__item_height_detected_deletions;
        --DELETE FROM public.__dummy__item_height_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.item_height_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.item_height_delta_action()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  deletion_data text;
  insertion_data text;
  json_data text;
  result text;
  user_name text;
  xid int;
  delta_ins_size int;
  delta_del_size int;
  array_delta_del public.item_height[];
  array_delta_ins public.item_height[];
  temprec_delta_del_gorda public.gorda%ROWTYPE;
            array_delta_del_gorda public.gorda[];
temprec_delta_ins_gorda public.gorda%ROWTYPE;
            array_delta_ins_gorda public.gorda[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'item_height_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure item_height_delta_action';
        CREATE TEMPORARY TABLE item_height_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT __tmp_delta_ins_item_height_a2_0.ORIGINAL_ID AS COL0, __tmp_delta_ins_item_height_a2_0.HEIGHT AS COL1 
FROM __tmp_delta_ins_item_height AS __tmp_delta_ins_item_height_a2_0   UNION SELECT item_height_a2_0.ORIGINAL_ID AS COL0, item_height_a2_0.HEIGHT AS COL1 
FROM public.item_height AS item_height_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM __tmp_delta_del_item_height AS __tmp_delta_del_item_height_a2 
WHERE __tmp_delta_del_item_height_a2.HEIGHT = item_height_a2_0.HEIGHT AND __tmp_delta_del_item_height_a2.ORIGINAL_ID = item_height_a2_0.ORIGINAL_ID ) ) AS p_1_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.item AS item_a4 
WHERE item_a4.ORIGINAL_ID = p_1_a2_0.COL0 ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.item AS item_a4_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.gorda AS gorda_a7 
WHERE gorda_a7.UOM = item_a4_0.UOM AND gorda_a7.QTY = item_a4_0.QTY AND gorda_a7.ITEM = item_a4_0.ITEM AND gorda_a7.ORIGINAL_ID = item_a4_0.ORIGINAL_ID ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_item_height AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_item_height as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_item_height;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_item_height;
        
            WITH __tmp_delta_del_item_height_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_item_height_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_gorda FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4,COL5,COL6) :: public.gorda).* 
            FROM (SELECT delta_del_gorda_a7_0.COL0 AS COL0, delta_del_gorda_a7_0.COL1 AS COL1, delta_del_gorda_a7_0.COL2 AS COL2, delta_del_gorda_a7_0.COL3 AS COL3, delta_del_gorda_a7_0.COL4 AS COL4, delta_del_gorda_a7_0.COL5 AS COL5, delta_del_gorda_a7_0.COL6 AS COL6 
FROM (SELECT p_0_a7_0.COL0 AS COL0, p_0_a7_0.COL1 AS COL1, p_0_a7_0.COL2 AS COL2, p_0_a7_0.COL3 AS COL3, p_0_a7_0.COL4 AS COL4, p_0_a7_0.COL5 AS COL5, p_0_a7_0.COL6 AS COL6 
FROM (SELECT gorda_a7_1._ID AS COL0, gorda_a7_1.ORIGINAL_ID AS COL1, gorda_a7_1.ITEM AS COL2, gorda_a7_1.QTY AS COL3, gorda_a7_1.H AS COL4, gorda_a7_1.W AS COL5, gorda_a7_1.UOM AS COL6 
FROM __tmp_delta_del_item_height_ar AS __tmp_delta_del_item_height_ar_a2_0, public.gorda AS gorda_a7_1 
WHERE gorda_a7_1.ORIGINAL_ID = __tmp_delta_del_item_height_ar_a2_0.ORIGINAL_ID AND gorda_a7_1.H = __tmp_delta_del_item_height_ar_a2_0.HEIGHT ) AS p_0_a7_0  ) AS delta_del_gorda_a7_0  ) AS delta_del_gorda_extra_alias) AS tbl;


            WITH __tmp_delta_del_item_height_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_item_height_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_gorda FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4,COL5,COL6) :: public.gorda).* 
            FROM (SELECT delta_ins_gorda_a7_0.COL0 AS COL0, delta_ins_gorda_a7_0.COL1 AS COL1, delta_ins_gorda_a7_0.COL2 AS COL2, delta_ins_gorda_a7_0.COL3 AS COL3, delta_ins_gorda_a7_0.COL4 AS COL4, delta_ins_gorda_a7_0.COL5 AS COL5, delta_ins_gorda_a7_0.COL6 AS COL6 
FROM (SELECT p_0_a7_0.COL0 AS COL0, p_0_a7_0.COL1 AS COL1, p_0_a7_0.COL2 AS COL2, p_0_a7_0.COL3 AS COL3, p_0_a7_0.COL4 AS COL4, p_0_a7_0.COL5 AS COL5, p_0_a7_0.COL6 AS COL6 
FROM (SELECT '' AS COL0, gorda_a7_1.ORIGINAL_ID AS COL1, gorda_a7_1.ITEM AS COL2, gorda_a7_1.QTY AS COL3, __tmp_delta_ins_item_height_ar_a2_0.HEIGHT AS COL4, gorda_a7_1.W AS COL5, gorda_a7_1.UOM AS COL6 
FROM __tmp_delta_ins_item_height_ar AS __tmp_delta_ins_item_height_ar_a2_0, public.gorda AS gorda_a7_1 
WHERE gorda_a7_1.ORIGINAL_ID = __tmp_delta_ins_item_height_ar_a2_0.ORIGINAL_ID AND gorda_a7_1.H  <>  __tmp_delta_ins_item_height_ar_a2_0.HEIGHT AND NOT EXISTS ( SELECT * 
FROM public.gorda AS gorda_a7 
WHERE gorda_a7.H = __tmp_delta_ins_item_height_ar_a2_0.HEIGHT AND gorda_a7.ORIGINAL_ID = gorda_a7_1.ORIGINAL_ID ) ) AS p_0_a7_0  ) AS delta_ins_gorda_a7_0  ) AS delta_ins_gorda_extra_alias) AS tbl; 


            IF array_delta_del_gorda IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_gorda IN array array_delta_del_gorda  LOOP 
                   DELETE FROM public.gorda WHERE _ID =  temprec_delta_del_gorda._ID AND ORIGINAL_ID =  temprec_delta_del_gorda.ORIGINAL_ID AND ITEM =  temprec_delta_del_gorda.ITEM AND QTY =  temprec_delta_del_gorda.QTY AND H =  temprec_delta_del_gorda.H AND W =  temprec_delta_del_gorda.W AND UOM =  temprec_delta_del_gorda.UOM;
                END LOOP;
            END IF;


            IF array_delta_ins_gorda IS DISTINCT FROM NULL THEN 
                INSERT INTO public.gorda (SELECT * FROM unnest(array_delta_ins_gorda) as array_delta_ins_gorda_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item_height';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item_height ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.item_height_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_item_height' OR table_name = '__tmp_delta_del_item_height')
    THEN
        -- RAISE LOG 'execute procedure item_height_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_item_height ( LIKE public.item_height )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_item_height_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_item_height DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.item_height_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_item_height ( LIKE public.item_height )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_item_height_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_item_height DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.item_height_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item_height';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item_height ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS item_height_trigger_materialization ON public.item_height;
CREATE TRIGGER item_height_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.item_height FOR EACH STATEMENT EXECUTE PROCEDURE public.item_height_materialization();

CREATE OR REPLACE FUNCTION public.item_height_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure item_height_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_item_height WHERE ROW(ORIGINAL_ID,HEIGHT) = NEW;
      INSERT INTO __tmp_delta_ins_item_height SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_item_height WHERE ROW(ORIGINAL_ID,HEIGHT) = OLD;
      INSERT INTO __tmp_delta_del_item_height SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_item_height WHERE ROW(ORIGINAL_ID,HEIGHT) = NEW;
      INSERT INTO __tmp_delta_ins_item_height SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_item_height WHERE ROW(ORIGINAL_ID,HEIGHT) = OLD;
      INSERT INTO __tmp_delta_del_item_height SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item_height';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item_height ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS item_height_trigger_update ON public.item_height;
CREATE TRIGGER item_height_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.item_height FOR EACH ROW EXECUTE PROCEDURE public.item_height_update();

CREATE OR REPLACE FUNCTION public.item_height_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_item_height_trigger_delta_action_ins, __tmp_item_height_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_item_height_trigger_delta_action_ins, __tmp_item_height_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS item_height_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_item_height;
    DROP TABLE IF EXISTS __tmp_delta_ins_item_height;
    RETURN true;
  END;
$$;