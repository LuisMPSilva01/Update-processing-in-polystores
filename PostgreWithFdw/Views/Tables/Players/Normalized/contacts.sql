-- Program is validated --
CREATE OR REPLACE VIEW public.contactsportonormalized AS 
SELECT __dummy__.COL0 AS NAME,__dummy__.COL1 AS CONTACT 
FROM (SELECT contactsportonormalized_a2_0.COL0 AS COL0, contactsportonormalized_a2_0.COL1 AS COL1 
FROM (SELECT playerscontacts_a3_1.NAME AS COL0, playerscontacts_a3_1.CONTACT AS COL1 
FROM public.playersbase AS playersbase_a4_0, public.playerscontacts AS playerscontacts_a3_1 
WHERE playerscontacts_a3_1.NAME = playersbase_a4_0.NAME AND playersbase_a4_0.ADDRESS = 'Porto' ) AS contactsportonormalized_a2_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__contactsportonormalized_detected_deletions (txid int, LIKE public.contactsportonormalized );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsportonormalized_detected_deletions ON public.__dummy__contactsportonormalized_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__contactsportonormalized_detected_insertions (txid int, LIKE public.contactsportonormalized );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsportonormalized_detected_insertions ON public.__dummy__contactsportonormalized_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.contactsportonormalized_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsportonormalized_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsportonormalized_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.contactsportonormalized"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__contactsportonormalized_detected_deletions;
        --DELETE FROM public.__dummy__contactsportonormalized_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsportonormalized_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.contactsportonormalized_delta_action()
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
  array_delta_del public.contactsportonormalized[];
  array_delta_ins public.contactsportonormalized[];
  temprec_delta_del_playerscontacts public.playerscontacts%ROWTYPE;
            array_delta_del_playerscontacts public.playerscontacts[];
temprec_delta_ins_playersbase public.playersbase%ROWTYPE;
            array_delta_ins_playersbase public.playersbase[];
temprec_delta_ins_playerscontacts public.playerscontacts%ROWTYPE;
            array_delta_ins_playerscontacts public.playerscontacts[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'contactsportonormalized_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure contactsportonormalized_delta_action';
        CREATE TEMPORARY TABLE contactsportonormalized_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.playersbase AS playersbase_a4_0, (SELECT __tmp_delta_ins_contactsportonormalized_a2_0.CONTACT AS COL0, __tmp_delta_ins_contactsportonormalized_a2_0.NAME AS COL1 
FROM __tmp_delta_ins_contactsportonormalized AS __tmp_delta_ins_contactsportonormalized_a2_0   UNION SELECT contactsportonormalized_a2_0.CONTACT AS COL0, contactsportonormalized_a2_0.NAME AS COL1 
FROM public.contactsportonormalized AS contactsportonormalized_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM __tmp_delta_del_contactsportonormalized AS __tmp_delta_del_contactsportonormalized_a2 
WHERE __tmp_delta_del_contactsportonormalized_a2.CONTACT = contactsportonormalized_a2_0.CONTACT AND __tmp_delta_del_contactsportonormalized_a2.NAME = contactsportonormalized_a2_0.NAME ) ) AS p_1_a2_1 
WHERE p_1_a2_1.COL1 = playersbase_a4_0.NAME AND playersbase_a4_0.ADDRESS  <>  'Porto' ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.playersbase AS playersbase_a4_0, public.playersbase AS playersbase_a4_1 
WHERE playersbase_a4_1.NAME = playersbase_a4_0.NAME AND playersbase_a4_0.ADDRESS  <>  playersbase_a4_1.ADDRESS  UNION ALL SELECT  
FROM public.playersbase AS playersbase_a4_0, public.playersbase AS playersbase_a4_1 
WHERE playersbase_a4_1.NAME = playersbase_a4_0.NAME AND playersbase_a4_0.CLUB  <>  playersbase_a4_1.CLUB  UNION ALL SELECT  
FROM public.playerscontacts AS playerscontacts_a3_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT playersbase_a4_0.NAME AS COL0 
FROM public.playersbase AS playersbase_a4_0   UNION SELECT playersbase_a4_0.NAME AS COL0 
FROM public.playersbase AS playersbase_a4_0  ) AS p_1_a1 
WHERE p_1_a1.COL0 = playerscontacts_a3_0.NAME ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_contactsportonormalized AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_contactsportonormalized as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_contactsportonormalized;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_contactsportonormalized;
        
            WITH __tmp_delta_del_contactsportonormalized_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsportonormalized_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_playerscontacts FROM (SELECT (ROW(COL0,COL1,COL2) :: public.playerscontacts).* 
            FROM (SELECT delta_del_playerscontacts_a3_0.COL0 AS COL0, delta_del_playerscontacts_a3_0.COL1 AS COL1, delta_del_playerscontacts_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT playerscontacts_a3_2._ID AS COL0, playerscontacts_a3_2.NAME AS COL1, playerscontacts_a3_2.CONTACT AS COL2 
FROM __tmp_delta_del_contactsportonormalized_ar AS __tmp_delta_del_contactsportonormalized_ar_a2_0, public.playersbase AS playersbase_a4_1, public.playerscontacts AS playerscontacts_a3_2 
WHERE playerscontacts_a3_2.CONTACT = __tmp_delta_del_contactsportonormalized_ar_a2_0.CONTACT AND playerscontacts_a3_2.NAME = playersbase_a4_1.NAME AND playerscontacts_a3_2.NAME = __tmp_delta_del_contactsportonormalized_ar_a2_0.NAME AND playersbase_a4_1.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM (SELECT playerscontacts_a3_1._ID AS COL0, playerscontacts_a3_1.NAME AS COL1, playerscontacts_a3_1.CONTACT AS COL2 
FROM public.playersbase AS playersbase_a4_0, public.playerscontacts AS playerscontacts_a3_1 
WHERE playerscontacts_a3_1.NAME = playersbase_a4_0.NAME AND playersbase_a4_0.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM (SELECT playersbase_a4_1.NAME AS COL0, playerscontacts_a3_0.CONTACT AS COL1 
FROM public.playerscontacts AS playerscontacts_a3_0, public.playersbase AS playersbase_a4_1 
WHERE playersbase_a4_1.NAME = playerscontacts_a3_0.NAME AND playersbase_a4_1.ADDRESS = 'Porto' ) AS p_2_a2 
WHERE p_2_a2.COL1 = playerscontacts_a3_1.CONTACT AND p_2_a2.COL0 = playerscontacts_a3_1.NAME ) ) AS p_1_a3 
WHERE p_1_a3.COL2 = playerscontacts_a3_2.CONTACT AND p_1_a3.COL1 = playerscontacts_a3_2.NAME AND p_1_a3.COL0 = playerscontacts_a3_2._ID ) ) AS p_0_a3_0  ) AS delta_del_playerscontacts_a3_0  ) AS delta_del_playerscontacts_extra_alias) AS tbl;


            WITH __tmp_delta_del_contactsportonormalized_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsportonormalized_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_playersbase FROM (SELECT (ROW(COL0,COL1,COL2,COL3) :: public.playersbase).* 
            FROM (SELECT delta_ins_playersbase_a4_0.COL0 AS COL0, delta_ins_playersbase_a4_0.COL1 AS COL1, delta_ins_playersbase_a4_0.COL2 AS COL2, delta_ins_playersbase_a4_0.COL3 AS COL3 
FROM (SELECT p_0_a4_0.COL0 AS COL0, p_0_a4_0.COL1 AS COL1, p_0_a4_0.COL2 AS COL2, p_0_a4_0.COL3 AS COL3 
FROM (SELECT '' AS COL0, __tmp_delta_ins_contactsportonormalized_ar_a2_0.NAME AS COL1, 'Porto' AS COL2, 'None' AS COL3 
FROM __tmp_delta_ins_contactsportonormalized_ar AS __tmp_delta_ins_contactsportonormalized_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT '' AS COL0, playersbase_a4_1.NAME AS COL1, 'Porto' AS COL2, 'None' AS COL3 
FROM public.playerscontacts AS playerscontacts_a3_0, public.playersbase AS playersbase_a4_1 
WHERE playersbase_a4_1.NAME = playerscontacts_a3_0.NAME AND playersbase_a4_1.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM public.playersbase AS playersbase_a4 
WHERE playersbase_a4.NAME = playersbase_a4_1.NAME ) ) AS p_1_a4 
WHERE p_1_a4.COL3 = 'None' AND p_1_a4.COL2 = 'Porto' AND p_1_a4.COL1 = __tmp_delta_ins_contactsportonormalized_ar_a2_0.NAME AND p_1_a4.COL0 = '' ) AND NOT EXISTS ( SELECT * 
FROM public.playersbase AS playersbase_a4 
WHERE playersbase_a4.NAME = __tmp_delta_ins_contactsportonormalized_ar_a2_0.NAME ) ) AS p_0_a4_0  ) AS delta_ins_playersbase_a4_0  ) AS delta_ins_playersbase_extra_alias) AS tbl;


            WITH __tmp_delta_del_contactsportonormalized_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsportonormalized_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_playerscontacts FROM (SELECT (ROW(COL0,COL1,COL2) :: public.playerscontacts).* 
            FROM (SELECT delta_ins_playerscontacts_a3_0.COL0 AS COL0, delta_ins_playerscontacts_a3_0.COL1 AS COL1, delta_ins_playerscontacts_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT '' AS COL0, __tmp_delta_ins_contactsportonormalized_ar_a2_0.NAME AS COL1, __tmp_delta_ins_contactsportonormalized_ar_a2_0.CONTACT AS COL2 
FROM __tmp_delta_ins_contactsportonormalized_ar AS __tmp_delta_ins_contactsportonormalized_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.playerscontacts AS playerscontacts_a3 
WHERE playerscontacts_a3.CONTACT = __tmp_delta_ins_contactsportonormalized_ar_a2_0.CONTACT AND playerscontacts_a3.NAME = __tmp_delta_ins_contactsportonormalized_ar_a2_0.NAME ) ) AS p_0_a3_0  ) AS delta_ins_playerscontacts_a3_0  ) AS delta_ins_playerscontacts_extra_alias) AS tbl; 


            IF array_delta_del_playerscontacts IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_playerscontacts IN array array_delta_del_playerscontacts  LOOP 
                   DELETE FROM public.playerscontacts WHERE _ID =  temprec_delta_del_playerscontacts._ID AND NAME =  temprec_delta_del_playerscontacts.NAME AND CONTACT =  temprec_delta_del_playerscontacts.CONTACT;
                END LOOP;
            END IF;


            IF array_delta_ins_playersbase IS DISTINCT FROM NULL THEN 
                INSERT INTO public.playersbase (SELECT * FROM unnest(array_delta_ins_playersbase) as array_delta_ins_playersbase_alias) ; 
            END IF;


            IF array_delta_ins_playerscontacts IS DISTINCT FROM NULL THEN 
                INSERT INTO public.playerscontacts (SELECT * FROM unnest(array_delta_ins_playerscontacts) as array_delta_ins_playerscontacts_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportonormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportonormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsportonormalized_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_contactsportonormalized' OR table_name = '__tmp_delta_del_contactsportonormalized')
    THEN
        -- RAISE LOG 'execute procedure contactsportonormalized_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_contactsportonormalized ( LIKE public.contactsportonormalized )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsportonormalized_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_contactsportonormalized DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsportonormalized_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_contactsportonormalized ( LIKE public.contactsportonormalized )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsportonormalized_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_contactsportonormalized DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsportonormalized_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportonormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportonormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsportonormalized_trigger_materialization ON public.contactsportonormalized;
CREATE TRIGGER contactsportonormalized_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.contactsportonormalized FOR EACH STATEMENT EXECUTE PROCEDURE public.contactsportonormalized_materialization();

CREATE OR REPLACE FUNCTION public.contactsportonormalized_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure contactsportonormalized_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_contactsportonormalized WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsportonormalized SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_contactsportonormalized WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsportonormalized SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_contactsportonormalized WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsportonormalized SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_contactsportonormalized WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsportonormalized SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsportonormalized';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsportonormalized ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsportonormalized_trigger_update ON public.contactsportonormalized;
CREATE TRIGGER contactsportonormalized_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.contactsportonormalized FOR EACH ROW EXECUTE PROCEDURE public.contactsportonormalized_update();

CREATE OR REPLACE FUNCTION public.contactsportonormalized_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_contactsportonormalized_trigger_delta_action_ins, __tmp_contactsportonormalized_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_contactsportonormalized_trigger_delta_action_ins, __tmp_contactsportonormalized_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS contactsportonormalized_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_contactsportonormalized;
    DROP TABLE IF EXISTS __tmp_delta_ins_contactsportonormalized;
    RETURN true;
  END;
$$;