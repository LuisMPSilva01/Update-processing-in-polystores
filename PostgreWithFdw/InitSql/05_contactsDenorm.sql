-- Program is validated --
/*CREATE OR REPLACE VIEW public.contactsportodenormalized AS 
SELECT __dummy__.COL0 AS NAME,__dummy__.COL1 AS CONTACT 
FROM (SELECT contactsportodenormalized_a2_0.COL0 AS COL0, contactsportodenormalized_a2_0.COL1 AS COL1 
FROM (SELECT playersdenormalized_a5_0.NAME AS COL0, playersdenormalized_a5_0.CONTACT AS COL1 
FROM public.playersdenormalized AS playersdenormalized_a5_0 
WHERE playersdenormalized_a5_0.ADDRESS = 'Porto' ) AS contactsportodenormalized_a2_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__contactsportodenormalized_detected_deletions (txid int, LIKE public.contactsportodenormalized );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsportodenormalized_detected_deletions ON public.__dummy__contactsportodenormalized_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__contactsportodenormalized_detected_insertions (txid int, LIKE public.contactsportodenormalized );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsportodenormalized_detected_insertions ON public.__dummy__contactsportodenormalized_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.contactsportodenormalized_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsportodenormalized_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsportodenormalized_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.contactsportodenormalized"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__contactsportodenormalized_detected_deletions;
        --DELETE FROM public.__dummy__contactsportodenormalized_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsportodenormalized_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.contactsportodenormalized_delta_action()
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
  array_delta_del public.contactsportodenormalized[];
  array_delta_ins public.contactsportodenormalized[];
  temprec_delta_del_playersdenormalized public.playersdenormalized%ROWTYPE;
            array_delta_del_playersdenormalized public.playersdenormalized[];
temprec_delta_ins_playersdenormalized public.playersdenormalized%ROWTYPE;
            array_delta_ins_playersdenormalized public.playersdenormalized[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'contactsportodenormalized_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure contactsportodenormalized_delta_action';
        CREATE TEMPORARY TABLE contactsportodenormalized_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.playersdenormalized AS playersdenormalized_a5_0, (SELECT __tmp_delta_ins_contactsportodenormalized_a2_0.CONTACT AS COL0, __tmp_delta_ins_contactsportodenormalized_a2_0.NAME AS COL1 
FROM __tmp_delta_ins_contactsportodenormalized AS __tmp_delta_ins_contactsportodenormalized_a2_0   UNION SELECT contactsportodenormalized_a2_0.CONTACT AS COL0, contactsportodenormalized_a2_0.NAME AS COL1 
FROM public.contactsportodenormalized AS contactsportodenormalized_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM __tmp_delta_del_contactsportodenormalized AS __tmp_delta_del_contactsportodenormalized_a2 
WHERE __tmp_delta_del_contactsportodenormalized_a2.CONTACT = contactsportodenormalized_a2_0.CONTACT AND __tmp_delta_del_contactsportodenormalized_a2.NAME = contactsportodenormalized_a2_0.NAME ) ) AS p_1_a2_1 
WHERE p_1_a2_1.COL1 = playersdenormalized_a5_0.NAME AND playersdenormalized_a5_0.ADDRESS  <>  'Porto' ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.playersdenormalized AS playersdenormalized_a5_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = playersdenormalized_a5_0.NAME AND playersdenormalized_a5_0.ADDRESS  <>  playersdenormalized_a5_1.ADDRESS  UNION ALL SELECT  
FROM public.playersdenormalized AS playersdenormalized_a5_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = playersdenormalized_a5_0.NAME AND playersdenormalized_a5_1.CLUB  <>  playersdenormalized_a5_0.CLUB ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_contactsportodenormalized AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_contactsportodenormalized as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_contactsportodenormalized;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_contactsportodenormalized;
        
            WITH __tmp_delta_del_contactsportodenormalized_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsportodenormalized_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_playersdenormalized FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4) :: public.playersdenormalized).* 
            FROM (SELECT delta_del_playersdenormalized_a5_0.COL0 AS COL0, delta_del_playersdenormalized_a5_0.COL1 AS COL1, delta_del_playersdenormalized_a5_0.COL2 AS COL2, delta_del_playersdenormalized_a5_0.COL3 AS COL3, delta_del_playersdenormalized_a5_0.COL4 AS COL4 
FROM (SELECT p_0_a5_0.COL0 AS COL0, p_0_a5_0.COL1 AS COL1, p_0_a5_0.COL2 AS COL2, p_0_a5_0.COL3 AS COL3, p_0_a5_0.COL4 AS COL4 
FROM (SELECT playersdenormalized_a5_1._ID AS COL0, playersdenormalized_a5_1.NAME AS COL1, playersdenormalized_a5_1.ADDRESS AS COL2, playersdenormalized_a5_1.CLUB AS COL3, playersdenormalized_a5_1.CONTACT AS COL4 
FROM __tmp_delta_del_contactsportodenormalized_ar AS __tmp_delta_del_contactsportodenormalized_ar_a2_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = __tmp_delta_del_contactsportodenormalized_ar_a2_0.NAME AND playersdenormalized_a5_1.CONTACT = __tmp_delta_del_contactsportodenormalized_ar_a2_0.CONTACT AND playersdenormalized_a5_1.ADDRESS = 'Porto' ) AS p_0_a5_0  ) AS delta_del_playersdenormalized_a5_0  ) AS delta_del_playersdenormalized_extra_alias) AS tbl;


            WITH __tmp_delta_del_contactsportodenormalized_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsportodenormalized_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_playersdenormalized FROM (SELECT (ROW(COL0,COL1,COL2,COL3,COL4) :: public.playersdenormalized).* 
            FROM (SELECT delta_ins_playersdenormalized_a5_0.COL0 AS COL0, delta_ins_playersdenormalized_a5_0.COL1 AS COL1, delta_ins_playersdenormalized_a5_0.COL2 AS COL2, delta_ins_playersdenormalized_a5_0.COL3 AS COL3, delta_ins_playersdenormalized_a5_0.COL4 AS COL4 
FROM (SELECT p_0_a5_0.COL0 AS COL0, p_0_a5_0.COL1 AS COL1, p_0_a5_0.COL2 AS COL2, p_0_a5_0.COL3 AS COL3, p_0_a5_0.COL4 AS COL4 
FROM (SELECT '' AS COL0, __tmp_delta_ins_contactsportodenormalized_ar_a2_0.NAME AS COL1, 'Porto' AS COL2, 'None' AS COL3, __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AS COL4 
FROM __tmp_delta_ins_contactsportodenormalized_ar AS __tmp_delta_ins_contactsportodenormalized_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT '' AS COL0, playersdenormalized_a5_1.NAME AS COL1, 'Porto' AS COL2, playersdenormalized_a5_0.CLUB AS COL3, playersdenormalized_a5_1.CONTACT AS COL4 
FROM public.playersdenormalized AS playersdenormalized_a5_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = playersdenormalized_a5_0.NAME AND playersdenormalized_a5_1.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM public.playersdenormalized AS playersdenormalized_a5 
WHERE playersdenormalized_a5.CONTACT = playersdenormalized_a5_1.CONTACT AND playersdenormalized_a5.ADDRESS = 'Porto' AND playersdenormalized_a5.NAME = playersdenormalized_a5_1.NAME ) ) AS p_1_a5 
WHERE p_1_a5.COL4 = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AND p_1_a5.COL3 = 'None' AND p_1_a5.COL2 = 'Porto' AND p_1_a5.COL1 = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.NAME AND p_1_a5.COL0 = '' ) AND NOT EXISTS ( SELECT * 
FROM public.playersdenormalized AS playersdenormalized_a5 
WHERE playersdenormalized_a5.NAME = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.NAME )  UNION SELECT '' AS COL0, playersdenormalized_a5_1.NAME AS COL1, 'Porto' AS COL2, playersdenormalized_a5_1.CLUB AS COL3, __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AS COL4 
FROM __tmp_delta_ins_contactsportodenormalized_ar AS __tmp_delta_ins_contactsportodenormalized_ar_a2_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.NAME AND NOT EXISTS ( SELECT * 
FROM (SELECT '' AS COL0, playersdenormalized_a5_1.NAME AS COL1, 'Porto' AS COL2, playersdenormalized_a5_0.CLUB AS COL3, playersdenormalized_a5_1.CONTACT AS COL4 
FROM public.playersdenormalized AS playersdenormalized_a5_0, public.playersdenormalized AS playersdenormalized_a5_1 
WHERE playersdenormalized_a5_1.NAME = playersdenormalized_a5_0.NAME AND playersdenormalized_a5_1.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM public.playersdenormalized AS playersdenormalized_a5 
WHERE playersdenormalized_a5.CONTACT = playersdenormalized_a5_1.CONTACT AND playersdenormalized_a5.ADDRESS = 'Porto' AND playersdenormalized_a5.NAME = playersdenormalized_a5_1.NAME ) ) AS p_3_a5 
WHERE p_3_a5.COL4 = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AND p_3_a5.COL3 = playersdenormalized_a5_1.CLUB AND p_3_a5.COL2 = 'Porto' AND p_3_a5.COL1 = playersdenormalized_a5_1.NAME AND p_3_a5.COL0 = '' ) AND NOT EXISTS ( SELECT * 
FROM (SELECT '' AS COL0, playersdenormalized_a5_0.NAME AS COL1, 'Porto' AS COL2, 'None' AS COL3, playersdenormalized_a5_0.CONTACT AS COL4 
FROM public.playersdenormalized AS playersdenormalized_a5_0 
WHERE playersdenormalized_a5_0.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM public.playersdenormalized AS playersdenormalized_a5 
WHERE playersdenormalized_a5.NAME = playersdenormalized_a5_0.NAME ) ) AS p_2_a5 
WHERE p_2_a5.COL4 = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AND p_2_a5.COL3 = playersdenormalized_a5_1.CLUB AND p_2_a5.COL2 = 'Porto' AND p_2_a5.COL1 = playersdenormalized_a5_1.NAME AND p_2_a5.COL0 = '' ) AND NOT EXISTS ( SELECT * 
FROM public.playersdenormalized AS playersdenormalized_a5 
WHERE playersdenormalized_a5.CONTACT = __tmp_delta_ins_contactsportodenormalized_ar_a2_0.CONTACT AND playersdenormalized_a5.ADDRESS = 'Porto' AND playersdenormalized_a5.NAME = playersdenormalized_a5_1.NAME ) ) AS p_0_a5_0  ) AS delta_ins_playersdenormalized_a5_0  ) AS delta_ins_playersdenormalized_extra_alias) AS tbl; 


            IF array_delta_del_playersdenormalized IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_playersdenormalized IN array array_delta_del_playersdenormalized  LOOP 
                   DELETE FROM public.playersdenormalized WHERE _ID =  temprec_delta_del_playersdenormalized._ID AND NAME =  temprec_delta_del_playersdenormalized.NAME AND ADDRESS =  temprec_delta_del_playersdenormalized.ADDRESS AND CLUB =  temprec_delta_del_playersdenormalized.CLUB AND CONTACT =  temprec_delta_del_playersdenormalized.CONTACT;
                END LOOP;
            END IF;


            IF array_delta_ins_playersdenormalized IS DISTINCT FROM NULL THEN 
                INSERT INTO public.playersdenormalized (SELECT * FROM unnest(array_delta_ins_playersdenormalized) as array_delta_ins_playersdenormalized_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportodenormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportodenormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsportodenormalized_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_contactsportodenormalized' OR table_name = '__tmp_delta_del_contactsportodenormalized')
    THEN
        -- RAISE LOG 'execute procedure contactsportodenormalized_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_contactsportodenormalized ( LIKE public.contactsportodenormalized )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsportodenormalized_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_contactsportodenormalized DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsportodenormalized_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_contactsportodenormalized ( LIKE public.contactsportodenormalized )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsportodenormalized_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_contactsportodenormalized DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsportodenormalized_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportodenormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportodenormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsportodenormalized_trigger_materialization ON public.contactsportodenormalized;
CREATE TRIGGER contactsportodenormalized_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.contactsportodenormalized FOR EACH STATEMENT EXECUTE PROCEDURE public.contactsportodenormalized_materialization();

CREATE OR REPLACE FUNCTION public.contactsportodenormalized_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure contactsportodenormalized_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_contactsportodenormalized WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsportodenormalized SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_contactsportodenormalized WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsportodenormalized SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_contactsportodenormalized WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsportodenormalized SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_contactsportodenormalized WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsportodenormalized SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportodenormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportodenormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsportodenormalized_trigger_update ON public.contactsportodenormalized;
CREATE TRIGGER contactsportodenormalized_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.contactsportodenormalized FOR EACH ROW EXECUTE PROCEDURE public.contactsportodenormalized_update();

CREATE OR REPLACE FUNCTION public.contactsportodenormalized_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_contactsportodenormalized_trigger_delta_action_ins, __tmp_contactsportodenormalized_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_contactsportodenormalized_trigger_delta_action_ins, __tmp_contactsportodenormalized_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS contactsportodenormalized_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_contactsportodenormalized;
    DROP TABLE IF EXISTS __tmp_delta_ins_contactsportodenormalized;
    RETURN true;
  END;
$$;

*/