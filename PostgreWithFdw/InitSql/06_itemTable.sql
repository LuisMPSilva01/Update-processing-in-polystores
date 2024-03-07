-- Program is validated --
CREATE OR REPLACE VIEW public.item AS 
SELECT __dummy__.COL0 AS ORIGINAL_ID,__dummy__.COL1 AS ITEM,__dummy__.COL2 AS UOM 
FROM (SELECT item_a3_0.COL0 AS COL0, item_a3_0.COL1 AS COL1, item_a3_0.COL2 AS COL2 
FROM (SELECT unwindexample_a6_0.ORIGINAL_ID AS COL0, unwindexample_a6_0.ITEM AS COL1, unwindexample_a6_0.UOM AS COL2 
FROM public.unwindexample AS unwindexample_a6_0  ) AS item_a3_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__item_detected_deletions (txid int, LIKE public.item );
CREATE INDEX IF NOT EXISTS idx__dummy__item_detected_deletions ON public.__dummy__item_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__item_detected_insertions (txid int, LIKE public.item );
CREATE INDEX IF NOT EXISTS idx__dummy__item_detected_insertions ON public.__dummy__item_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.item_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__item_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__item_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.item"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__item_detected_deletions;
        --DELETE FROM public.__dummy__item_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.item_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.item_delta_action()
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
  array_delta_del public.item[];
  array_delta_ins public.item[];
  temprec_delta_del_unwindexample public.unwindexample%ROWTYPE;
            array_delta_del_unwindexample public.unwindexample[];
temprec_delta_ins_unwindexample public.unwindexample%ROWTYPE;
            array_delta_ins_unwindexample public.unwindexample[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'item_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure item_delta_action';
        CREATE TEMPORARY TABLE item_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT WHERE false )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.unwindexample AS unwindexample_a6_0, public.unwindexample AS unwindexample_a6_1 
WHERE unwindexample_a6_1.ORIGINAL_ID = unwindexample_a6_0.ORIGINAL_ID AND unwindexample_a6_0.ITEM  <>  unwindexample_a6_1.ITEM  UNION ALL SELECT  
FROM public.unwindexample AS unwindexample_a6_0, public.unwindexample AS unwindexample_a6_1 
WHERE unwindexample_a6_1.ORIGINAL_ID = unwindexample_a6_0.ORIGINAL_ID AND unwindexample_a6_0.UOM  <>  unwindexample_a6_1.UOM  UNION ALL SELECT  
FROM public.unwindexample AS unwindexample_a6_0, public.unwindexample AS unwindexample_a6_1 
WHERE unwindexample_a6_1.ORIGINAL_ID = unwindexample_a6_0.ORIGINAL_ID AND NOT EXISTS ( SELECT * 
FROM public.unwindexample AS unwindexample_a6 
WHERE unwindexample_a6.W = unwindexample_a6_1.W AND unwindexample_a6.H = unwindexample_a6_0.H AND unwindexample_a6.ORIGINAL_ID = unwindexample_a6_1.ORIGINAL_ID ) AND NOT EXISTS ( SELECT * 
FROM public.unwindexample AS unwindexample_a6 
WHERE unwindexample_a6.W = unwindexample_a6_0.W AND unwindexample_a6.H = unwindexample_a6_1.H AND unwindexample_a6.ORIGINAL_ID = unwindexample_a6_1.ORIGINAL_ID ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_item AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_item as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_item;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_item;
        
            WITH __tmp_delta_del_item_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_item_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_unwindexample FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4,COL5) :: public.unwindexample).* 
            FROM (SELECT delta_del_unwindexample_a6_0.COL0 AS COL0, delta_del_unwindexample_a6_0.COL1 AS COL1, delta_del_unwindexample_a6_0.COL2 AS COL2, delta_del_unwindexample_a6_0.COL3 AS COL3, delta_del_unwindexample_a6_0.COL4 AS COL4, delta_del_unwindexample_a6_0.COL5 AS COL5 
FROM (SELECT p_0_a6_0.COL0 AS COL0, p_0_a6_0.COL1 AS COL1, p_0_a6_0.COL2 AS COL2, p_0_a6_0.COL3 AS COL3, p_0_a6_0.COL4 AS COL4, p_0_a6_0.COL5 AS COL5 
FROM (SELECT unwindexample_a6_1.ID AS COL0, unwindexample_a6_1.ORIGINAL_ID AS COL1, unwindexample_a6_1.ITEM AS COL2, unwindexample_a6_1.UOM AS COL3, unwindexample_a6_1.H AS COL4, unwindexample_a6_1.W AS COL5 
FROM __tmp_delta_del_item_ar AS __tmp_delta_del_item_ar_a3_0, public.unwindexample AS unwindexample_a6_1 
WHERE unwindexample_a6_1.ITEM = __tmp_delta_del_item_ar_a3_0.ITEM AND unwindexample_a6_1.ORIGINAL_ID = __tmp_delta_del_item_ar_a3_0.ORIGINAL_ID AND unwindexample_a6_1.UOM = __tmp_delta_del_item_ar_a3_0.UOM ) AS p_0_a6_0  ) AS delta_del_unwindexample_a6_0  ) AS delta_del_unwindexample_extra_alias) AS tbl;


            WITH __tmp_delta_del_item_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_item_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_unwindexample FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4,COL5) :: public.unwindexample).* 
            FROM (SELECT delta_ins_unwindexample_a6_0.COL0 AS COL0, delta_ins_unwindexample_a6_0.COL1 AS COL1, delta_ins_unwindexample_a6_0.COL2 AS COL2, delta_ins_unwindexample_a6_0.COL3 AS COL3, delta_ins_unwindexample_a6_0.COL4 AS COL4, delta_ins_unwindexample_a6_0.COL5 AS COL5 
FROM (SELECT p_0_a6_0.COL0 AS COL0, p_0_a6_0.COL1 AS COL1, p_0_a6_0.COL2 AS COL2, p_0_a6_0.COL3 AS COL3, p_0_a6_0.COL4 AS COL4, p_0_a6_0.COL5 AS COL5 
FROM (SELECT 0 AS COL0, __tmp_delta_ins_item_ar_a3_0.ORIGINAL_ID AS COL1, __tmp_delta_ins_item_ar_a3_0.ITEM AS COL2, __tmp_delta_ins_item_ar_a3_0.UOM AS COL3, 1 AS COL4, 1 AS COL5 
FROM __tmp_delta_ins_item_ar AS __tmp_delta_ins_item_ar_a3_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.unwindexample AS unwindexample_a6 
WHERE unwindexample_a6.UOM = __tmp_delta_ins_item_ar_a3_0.UOM AND unwindexample_a6.ITEM = __tmp_delta_ins_item_ar_a3_0.ITEM AND unwindexample_a6.ORIGINAL_ID = __tmp_delta_ins_item_ar_a3_0.ORIGINAL_ID ) ) AS p_0_a6_0  ) AS delta_ins_unwindexample_a6_0  ) AS delta_ins_unwindexample_extra_alias) AS tbl; 


            IF array_delta_del_unwindexample IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_unwindexample IN array array_delta_del_unwindexample  LOOP 
                   DELETE FROM public.unwindexample WHERE ID =  temprec_delta_del_unwindexample.ID AND ORIGINAL_ID =  temprec_delta_del_unwindexample.ORIGINAL_ID AND ITEM =  temprec_delta_del_unwindexample.ITEM AND UOM =  temprec_delta_del_unwindexample.UOM AND H =  temprec_delta_del_unwindexample.H AND W =  temprec_delta_del_unwindexample.W;
                END LOOP;
            END IF;


            IF array_delta_ins_unwindexample IS DISTINCT FROM NULL THEN 
                INSERT INTO public.unwindexample (SELECT * FROM unnest(array_delta_ins_unwindexample) as array_delta_ins_unwindexample_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.item_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_item' OR table_name = '__tmp_delta_del_item')
    THEN
        -- RAISE LOG 'execute procedure item_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_item ( LIKE public.item )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_item_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_item DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.item_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_item ( LIKE public.item )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_item_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_item DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.item_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS item_trigger_materialization ON public.item;
CREATE TRIGGER item_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.item FOR EACH STATEMENT EXECUTE PROCEDURE public.item_materialization();

CREATE OR REPLACE FUNCTION public.item_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure item_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_item WHERE ROW(ORIGINAL_ID,ITEM,UOM) = NEW;
      INSERT INTO __tmp_delta_ins_item SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_item WHERE ROW(ORIGINAL_ID,ITEM,UOM) = OLD;
      INSERT INTO __tmp_delta_del_item SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_item WHERE ROW(ORIGINAL_ID,ITEM,UOM) = NEW;
      INSERT INTO __tmp_delta_ins_item SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_item WHERE ROW(ORIGINAL_ID,ITEM,UOM) = OLD;
      INSERT INTO __tmp_delta_del_item SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.item';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.item ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS item_trigger_update ON public.item;
CREATE TRIGGER item_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.item FOR EACH ROW EXECUTE PROCEDURE public.item_update();

CREATE OR REPLACE FUNCTION public.item_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_item_trigger_delta_action_ins, __tmp_item_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_item_trigger_delta_action_ins, __tmp_item_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS item_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_item;
    DROP TABLE IF EXISTS __tmp_delta_ins_item;
    RETURN true;
  END;
$$;

