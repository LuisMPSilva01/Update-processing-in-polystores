-- Program is validated --
CREATE OR REPLACE VIEW public.contacts AS 
SELECT __dummy__.COL0 AS NAME,__dummy__.COL1 AS CONTACT 
FROM (SELECT contacts_a2_0.COL0 AS COL0, contacts_a2_0.COL1 AS COL1 
FROM (SELECT playerssimpledenormalized_a4_0.NAME AS COL0, playerssimpledenormalized_a4_0.CONTACT AS COL1 
FROM public.playerssimpledenormalized AS playerssimpledenormalized_a4_0 
WHERE playerssimpledenormalized_a4_0.ADDRESS = 'Porto' ) AS contacts_a2_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__contacts_detected_deletions (txid int, LIKE public.contacts );
CREATE INDEX IF NOT EXISTS idx__dummy__contacts_detected_deletions ON public.__dummy__contacts_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__contacts_detected_insertions (txid int, LIKE public.contacts );
CREATE INDEX IF NOT EXISTS idx__dummy__contacts_detected_insertions ON public.__dummy__contacts_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.contacts_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contacts_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contacts_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.contacts"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__contacts_detected_deletions;
        --DELETE FROM public.__dummy__contacts_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contacts_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.contacts_delta_action()
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
  array_delta_del public.contacts[];
  array_delta_ins public.contacts[];
  temprec_delta_del_playerssimpledenormalized public.playerssimpledenormalized%ROWTYPE;
            array_delta_del_playerssimpledenormalized public.playerssimpledenormalized[];
temprec_delta_ins_playerssimpledenormalized public.playerssimpledenormalized%ROWTYPE;
            array_delta_ins_playerssimpledenormalized public.playerssimpledenormalized[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'contacts_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure contacts_delta_action';
        CREATE TEMPORARY TABLE contacts_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT WHERE false )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.playerssimpledenormalized AS playerssimpledenormalized_a4_0, public.playerssimpledenormalized AS playerssimpledenormalized_a4_1 
WHERE playerssimpledenormalized_a4_1.NAME = playerssimpledenormalized_a4_0.NAME AND playerssimpledenormalized_a4_0.ADDRESS  <>  playerssimpledenormalized_a4_1.ADDRESS ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_contacts AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_contacts as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_contacts;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_contacts;
        
            WITH __tmp_delta_del_contacts_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contacts_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_playerssimpledenormalized FROM (SELECT (ROW(COL0,COL1,COL2,COL3) :: public.playerssimpledenormalized).* 
            FROM (SELECT delta_del_playerssimpledenormalized_a4_0.COL0 AS COL0, delta_del_playerssimpledenormalized_a4_0.COL1 AS COL1, delta_del_playerssimpledenormalized_a4_0.COL2 AS COL2, delta_del_playerssimpledenormalized_a4_0.COL3 AS COL3 
FROM (SELECT p_0_a4_0.COL0 AS COL0, p_0_a4_0.COL1 AS COL1, p_0_a4_0.COL2 AS COL2, p_0_a4_0.COL3 AS COL3 
FROM (SELECT playerssimpledenormalized_a4_1._ID AS COL0, playerssimpledenormalized_a4_1.NAME AS COL1, playerssimpledenormalized_a4_1.ADDRESS AS COL2, playerssimpledenormalized_a4_1.CONTACT AS COL3 
FROM __tmp_delta_del_contacts_ar AS __tmp_delta_del_contacts_ar_a2_0, public.playerssimpledenormalized AS playerssimpledenormalized_a4_1 
WHERE playerssimpledenormalized_a4_1.NAME = __tmp_delta_del_contacts_ar_a2_0.NAME AND playerssimpledenormalized_a4_1.CONTACT = __tmp_delta_del_contacts_ar_a2_0.CONTACT AND playerssimpledenormalized_a4_1.ADDRESS = 'Porto' ) AS p_0_a4_0  ) AS delta_del_playerssimpledenormalized_a4_0  ) AS delta_del_playerssimpledenormalized_extra_alias) AS tbl;


            WITH __tmp_delta_del_contacts_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contacts_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_playerssimpledenormalized FROM (SELECT (ROW(COL0,COL1,COL2,COL3) :: public.playerssimpledenormalized).* 
            FROM (SELECT delta_ins_playerssimpledenormalized_a4_0.COL0 AS COL0, delta_ins_playerssimpledenormalized_a4_0.COL1 AS COL1, delta_ins_playerssimpledenormalized_a4_0.COL2 AS COL2, delta_ins_playerssimpledenormalized_a4_0.COL3 AS COL3 
FROM (SELECT p_0_a4_0.COL0 AS COL0, p_0_a4_0.COL1 AS COL1, p_0_a4_0.COL2 AS COL2, p_0_a4_0.COL3 AS COL3 
FROM (SELECT '' AS COL0, __tmp_delta_ins_contacts_ar_a2_0.NAME AS COL1, 'Porto' AS COL2, __tmp_delta_ins_contacts_ar_a2_0.CONTACT AS COL3 
FROM __tmp_delta_ins_contacts_ar AS __tmp_delta_ins_contacts_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.playerssimpledenormalized AS playerssimpledenormalized_a4 
WHERE playerssimpledenormalized_a4.CONTACT = __tmp_delta_ins_contacts_ar_a2_0.CONTACT AND playerssimpledenormalized_a4.ADDRESS = 'Porto' AND playerssimpledenormalized_a4.NAME = __tmp_delta_ins_contacts_ar_a2_0.NAME ) ) AS p_0_a4_0  ) AS delta_ins_playerssimpledenormalized_a4_0  ) AS delta_ins_playerssimpledenormalized_extra_alias) AS tbl; 


            IF array_delta_del_playerssimpledenormalized IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_playerssimpledenormalized IN array array_delta_del_playerssimpledenormalized  LOOP 
                   DELETE FROM public.playerssimpledenormalized WHERE _ID =  temprec_delta_del_playerssimpledenormalized._ID AND NAME =  temprec_delta_del_playerssimpledenormalized.NAME AND ADDRESS =  temprec_delta_del_playerssimpledenormalized.ADDRESS AND CONTACT =  temprec_delta_del_playerssimpledenormalized.CONTACT;
                END LOOP;
            END IF;


            IF array_delta_ins_playerssimpledenormalized IS DISTINCT FROM NULL THEN 
                INSERT INTO public.playerssimpledenormalized (SELECT * FROM unnest(array_delta_ins_playerssimpledenormalized) as array_delta_ins_playerssimpledenormalized_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contacts';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contacts ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contacts_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_contacts' OR table_name = '__tmp_delta_del_contacts')
    THEN
        -- RAISE LOG 'execute procedure contacts_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_contacts ( LIKE public.contacts )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contacts_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_contacts DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contacts_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_contacts ( LIKE public.contacts )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contacts_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_contacts DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contacts_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contacts';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contacts ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contacts_trigger_materialization ON public.contacts;
CREATE TRIGGER contacts_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.contacts FOR EACH STATEMENT EXECUTE PROCEDURE public.contacts_materialization();

CREATE OR REPLACE FUNCTION public.contacts_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure contacts_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_contacts WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contacts SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_contacts WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contacts SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_contacts WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contacts SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_contacts WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contacts SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contacts';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contacts ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contacts_trigger_update ON public.contacts;
CREATE TRIGGER contacts_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.contacts FOR EACH ROW EXECUTE PROCEDURE public.contacts_update();

CREATE OR REPLACE FUNCTION public.contacts_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_contacts_trigger_delta_action_ins, __tmp_contacts_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_contacts_trigger_delta_action_ins, __tmp_contacts_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS contacts_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_contacts;
    DROP TABLE IF EXISTS __tmp_delta_ins_contacts;
    RETURN true;
  END;
$$;

