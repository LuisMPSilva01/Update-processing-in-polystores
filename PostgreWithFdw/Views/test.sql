-- Program is validated and the view definition is derived --
-- Program is validated --

/*view definition (get):
japan_view(KEY, NAME, ADDRESS) :- p_0(KEY, NAME, ADDRESS).
p_0(KEY, NAME, ADDRESS) :- NATION = 'Japan' , cities(KEY, NAME, ADDRESS, COL3, COL4) , countries(COL4, NATION, _).
*/

CREATE OR REPLACE VIEW public.japan_view AS 
SELECT __dummy__.COL0 AS KEY,__dummy__.COL1 AS NAME,__dummy__.COL2 AS ADDRESS 
FROM (SELECT japan_view_a3_0.COL0 AS COL0, japan_view_a3_0.COL1 AS COL1, japan_view_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_0_a3_0  ) AS japan_view_a3_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__japan_view_detected_deletions (txid int, LIKE public.japan_view );
CREATE INDEX IF NOT EXISTS idx__dummy__japan_view_detected_deletions ON public.__dummy__japan_view_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__japan_view_detected_insertions (txid int, LIKE public.japan_view );
CREATE INDEX IF NOT EXISTS idx__dummy__japan_view_detected_insertions ON public.__dummy__japan_view_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.japan_view_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__japan_view_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__japan_view_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.japan_view"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__japan_view_detected_deletions;
        --DELETE FROM public.__dummy__japan_view_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.japan_view_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.japan_view_delta_action()
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
  array_delta_del public.japan_view[];
  array_delta_ins public.japan_view[];
  temprec_delta_del_cities public.cities%ROWTYPE;
            array_delta_del_cities public.cities[];
temprec_delta_ins_cities public.cities%ROWTYPE;
            array_delta_ins_cities public.cities[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'japan_view_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure japan_view_delta_action';
        CREATE TEMPORARY TABLE japan_view_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT WHERE false )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT   
WHERE NOT EXISTS ( SELECT * 
FROM public.countries AS countries_a3 
WHERE countries_a3.NAME = 'Japan' ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_japan_view AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_japan_view as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_japan_view;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_japan_view;
        
            WITH __tmp_delta_del_japan_view_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_japan_view_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_cities FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4) :: public.cities).* 
            FROM (SELECT delta_del_cities_a5_0.COL0 AS COL0, delta_del_cities_a5_0.COL1 AS COL1, delta_del_cities_a5_0.COL2 AS COL2, delta_del_cities_a5_0.COL3 AS COL3, delta_del_cities_a5_0.COL4 AS COL4 
FROM (SELECT p_0_a5_0.COL0 AS COL0, p_0_a5_0.COL1 AS COL1, p_0_a5_0.COL2 AS COL2, p_0_a5_0.COL3 AS COL3, p_0_a5_0.COL4 AS COL4 
FROM (SELECT cities_a5_1._ID AS COL0, cities_a5_1.NAME AS COL1, cities_a5_1.ADDRESS AS COL2, cities_a5_1.PHONE AS COL3, countries_a3_2.KEY AS COL4 
FROM __tmp_delta_del_japan_view_ar AS __tmp_delta_del_japan_view_ar_a3_0, public.cities AS cities_a5_1, public.countries AS countries_a3_2 
WHERE cities_a5_1.ADDRESS = __tmp_delta_del_japan_view_ar_a3_0.ADDRESS AND cities_a5_1.NAME = __tmp_delta_del_japan_view_ar_a3_0.NAME AND cities_a5_1._ID = __tmp_delta_del_japan_view_ar_a3_0.KEY AND countries_a3_2.KEY = cities_a5_1.NATIONKEY AND countries_a3_2.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2, cities_a5_0.PHONE AS COL3, countries_a3_1.KEY AS COL4 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_2_a3 
WHERE p_2_a3.COL2 = cities_a5_0.ADDRESS AND p_2_a3.COL1 = cities_a5_0.NAME AND p_2_a3.COL0 = cities_a5_0._ID ) ) AS p_1_a5 
WHERE p_1_a5.COL4 = countries_a3_2.KEY AND p_1_a5.COL3 = cities_a5_1.PHONE AND p_1_a5.COL2 = cities_a5_1.ADDRESS AND p_1_a5.COL1 = cities_a5_1.NAME AND p_1_a5.COL0 = cities_a5_1._ID ) ) AS p_0_a5_0  ) AS delta_del_cities_a5_0  ) AS delta_del_cities_extra_alias) AS tbl;


            WITH __tmp_delta_del_japan_view_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_japan_view_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_cities FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4) :: public.cities).* 
            FROM (SELECT delta_ins_cities_a5_0.COL0 AS COL0, delta_ins_cities_a5_0.COL1 AS COL1, delta_ins_cities_a5_0.COL2 AS COL2, delta_ins_cities_a5_0.COL3 AS COL3, delta_ins_cities_a5_0.COL4 AS COL4 
FROM (SELECT p_0_a5_0.COL0 AS COL0, p_0_a5_0.COL1 AS COL1, p_0_a5_0.COL2 AS COL2, p_0_a5_0.COL3 AS COL3, p_0_a5_0.COL4 AS COL4 
FROM (SELECT cities_a5_1._ID AS COL0, __tmp_delta_ins_japan_view_ar_a3_0.NAME AS COL1, __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AS COL2, cities_a5_1.PHONE AS COL3, countries_a3_2.KEY AS COL4 
FROM __tmp_delta_ins_japan_view_ar AS __tmp_delta_ins_japan_view_ar_a3_0, public.cities AS cities_a5_1, public.countries AS countries_a3_2 
WHERE cities_a5_1._ID = __tmp_delta_ins_japan_view_ar_a3_0.KEY AND countries_a3_2.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_1._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2, cities_a5_1.PHONE AS COL3, countries_a3_2.KEY AS COL4 
FROM public.cities AS cities_a5_0, public.cities AS cities_a5_1, public.countries AS countries_a3_2, public.countries AS countries_a3_3 
WHERE cities_a5_1._ID = cities_a5_0._ID AND countries_a3_3.KEY = cities_a5_0.NATIONKEY AND countries_a3_2.NAME = 'Japan' AND countries_a3_3.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_5_a3 
WHERE p_5_a3.COL2 = cities_a5_0.ADDRESS AND p_5_a3.COL1 = cities_a5_0.NAME AND p_5_a3.COL0 = cities_a5_1._ID ) ) AS p_4_a5 
WHERE p_4_a5.COL4 = countries_a3_2.KEY AND p_4_a5.COL3 = cities_a5_1.PHONE AND p_4_a5.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_4_a5.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_4_a5.COL0 = cities_a5_1._ID ) AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2, 'unknown' AS COL3, countries_a3_1.KEY AS COL4 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1, public.countries AS countries_a3_2 
WHERE countries_a3_2.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' AND countries_a3_2.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_3_a3 
WHERE p_3_a3.COL2 = cities_a5_0.ADDRESS AND p_3_a3.COL1 = cities_a5_0.NAME AND p_3_a3.COL0 = cities_a5_0._ID ) AND NOT EXISTS ( SELECT * 
FROM public.cities AS cities_a5 
WHERE cities_a5._ID = cities_a5_0._ID ) ) AS p_2_a5 
WHERE p_2_a5.COL4 = countries_a3_2.KEY AND p_2_a5.COL3 = cities_a5_1.PHONE AND p_2_a5.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_2_a5.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_2_a5.COL0 = cities_a5_1._ID ) AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_1_a3 
WHERE p_1_a3.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_1_a3.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_1_a3.COL0 = cities_a5_1._ID )  UNION SELECT __tmp_delta_ins_japan_view_ar_a3_0.KEY AS COL0, __tmp_delta_ins_japan_view_ar_a3_0.NAME AS COL1, __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AS COL2, 'unknown' AS COL3, countries_a3_1.KEY AS COL4 
FROM __tmp_delta_ins_japan_view_ar AS __tmp_delta_ins_japan_view_ar_a3_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_1._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2, cities_a5_1.PHONE AS COL3, countries_a3_2.KEY AS COL4 
FROM public.cities AS cities_a5_0, public.cities AS cities_a5_1, public.countries AS countries_a3_2, public.countries AS countries_a3_3 
WHERE cities_a5_1._ID = cities_a5_0._ID AND countries_a3_3.KEY = cities_a5_0.NATIONKEY AND countries_a3_2.NAME = 'Japan' AND countries_a3_3.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_10_a3 
WHERE p_10_a3.COL2 = cities_a5_0.ADDRESS AND p_10_a3.COL1 = cities_a5_0.NAME AND p_10_a3.COL0 = cities_a5_1._ID ) ) AS p_9_a5 
WHERE p_9_a5.COL4 = countries_a3_1.KEY AND p_9_a5.COL3 = 'unknown' AND p_9_a5.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_9_a5.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_9_a5.COL0 = __tmp_delta_ins_japan_view_ar_a3_0.KEY ) AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2, 'unknown' AS COL3, countries_a3_1.KEY AS COL4 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1, public.countries AS countries_a3_2 
WHERE countries_a3_2.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' AND countries_a3_2.NAME = 'Japan' AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_8_a3 
WHERE p_8_a3.COL2 = cities_a5_0.ADDRESS AND p_8_a3.COL1 = cities_a5_0.NAME AND p_8_a3.COL0 = cities_a5_0._ID ) AND NOT EXISTS ( SELECT * 
FROM public.cities AS cities_a5 
WHERE cities_a5._ID = cities_a5_0._ID ) ) AS p_7_a5 
WHERE p_7_a5.COL4 = countries_a3_1.KEY AND p_7_a5.COL3 = 'unknown' AND p_7_a5.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_7_a5.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_7_a5.COL0 = __tmp_delta_ins_japan_view_ar_a3_0.KEY ) AND NOT EXISTS ( SELECT * 
FROM (SELECT cities_a5_0._ID AS COL0, cities_a5_0.NAME AS COL1, cities_a5_0.ADDRESS AS COL2 
FROM public.cities AS cities_a5_0, public.countries AS countries_a3_1 
WHERE countries_a3_1.KEY = cities_a5_0.NATIONKEY AND countries_a3_1.NAME = 'Japan' ) AS p_6_a3 
WHERE p_6_a3.COL2 = __tmp_delta_ins_japan_view_ar_a3_0.ADDRESS AND p_6_a3.COL1 = __tmp_delta_ins_japan_view_ar_a3_0.NAME AND p_6_a3.COL0 = __tmp_delta_ins_japan_view_ar_a3_0.KEY ) AND NOT EXISTS ( SELECT * 
FROM public.cities AS cities_a5 
WHERE cities_a5._ID = __tmp_delta_ins_japan_view_ar_a3_0.KEY ) ) AS p_0_a5_0  ) AS delta_ins_cities_a5_0  ) AS delta_ins_cities_extra_alias) AS tbl; 


            IF array_delta_del_cities IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_cities IN array array_delta_del_cities  LOOP 
                   DELETE FROM public.cities WHERE _ID =  temprec_delta_del_cities._ID AND NAME =  temprec_delta_del_cities.NAME AND ADDRESS =  temprec_delta_del_cities.ADDRESS AND PHONE =  temprec_delta_del_cities.PHONE AND NATIONKEY =  temprec_delta_del_cities.NATIONKEY;
                END LOOP;
            END IF;


            IF array_delta_ins_cities IS DISTINCT FROM NULL THEN 
                INSERT INTO public.cities (SELECT * FROM unnest(array_delta_ins_cities) as array_delta_ins_cities_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.japan_view';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.japan_view ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.japan_view_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_japan_view' OR table_name = '__tmp_delta_del_japan_view')
    THEN
        -- RAISE LOG 'execute procedure japan_view_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_japan_view ( LIKE public.japan_view ) ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_japan_view_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_japan_view DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.japan_view_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_japan_view ( LIKE public.japan_view ) ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_japan_view_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_japan_view DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.japan_view_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.japan_view';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.japan_view ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS japan_view_trigger_materialization ON public.japan_view;
CREATE TRIGGER japan_view_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.japan_view FOR EACH STATEMENT EXECUTE PROCEDURE public.japan_view_materialization();

CREATE OR REPLACE FUNCTION public.japan_view_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure japan_view_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_japan_view WHERE ROW(KEY,NAME,ADDRESS) = NEW;
      INSERT INTO __tmp_delta_ins_japan_view SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_japan_view WHERE ROW(KEY,NAME,ADDRESS) = OLD;
      INSERT INTO __tmp_delta_del_japan_view SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_japan_view WHERE ROW(KEY,NAME,ADDRESS) = NEW;
      INSERT INTO __tmp_delta_ins_japan_view SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_japan_view WHERE ROW(KEY,NAME,ADDRESS) = OLD;
      INSERT INTO __tmp_delta_del_japan_view SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.japan_view';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.japan_view ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS japan_view_trigger_update ON public.japan_view;
CREATE TRIGGER japan_view_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.japan_view FOR EACH ROW EXECUTE PROCEDURE public.japan_view_update();

CREATE OR REPLACE FUNCTION public.japan_view_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_japan_view_trigger_delta_action_ins, __tmp_japan_view_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_japan_view_trigger_delta_action_ins, __tmp_japan_view_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS japan_view_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_japan_view;
    DROP TABLE IF EXISTS __tmp_delta_ins_japan_view;
    RETURN true;
  END;
$$;