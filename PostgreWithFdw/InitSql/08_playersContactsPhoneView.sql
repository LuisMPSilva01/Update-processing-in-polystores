/*-- Program is validated --
CREATE OR REPLACE VIEW public.players_phone AS 
SELECT __dummy__.COL0 AS CONTACTID,__dummy__.COL1 AS NAME,__dummy__.COL2 AS PHONE 
FROM (SELECT players_phone_a3_0.COL0 AS COL0, players_phone_a3_0.COL1 AS COL1, players_phone_a3_0.COL2 AS COL2 
FROM (SELECT players_contact_a4_0.CONTACTID AS COL0, players_contact_a4_0.NAME AS COL1, players_contact_a4_0.PHONE AS COL2 
FROM public.players_contact AS players_contact_a4_0 
WHERE players_contact_a4_0.EMAIL IS NULL AND players_contact_a4_0.PHONE  IS NOT NULL ) AS players_phone_a3_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__players_phone_detected_deletions (txid int, LIKE public.players_phone );
CREATE INDEX IF NOT EXISTS idx__dummy__players_phone_detected_deletions ON public.__dummy__players_phone_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__players_phone_detected_insertions (txid int, LIKE public.players_phone );
CREATE INDEX IF NOT EXISTS idx__dummy__players_phone_detected_insertions ON public.__dummy__players_phone_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.players_phone_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__players_phone_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__players_phone_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.players_phone"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__players_phone_detected_deletions;
        --DELETE FROM public.__dummy__players_phone_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.players_phone_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.players_phone_delta_action()
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
  array_delta_del public.players_phone[];
  array_delta_ins public.players_phone[];
  temprec_delta_del_players_contact public.players_contact%ROWTYPE;
            array_delta_del_players_contact public.players_contact[];
temprec_delta_ins_players_contact public.players_contact%ROWTYPE;
            array_delta_ins_players_contact public.players_contact[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'players_phone_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure players_phone_delta_action';
        CREATE TEMPORARY TABLE players_phone_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT __tmp_delta_ins_players_phone_a3_0.CONTACTID AS COL0, __tmp_delta_ins_players_phone_a3_0.NAME AS COL1, __tmp_delta_ins_players_phone_a3_0.PHONE AS COL2 
FROM __tmp_delta_ins_players_phone AS __tmp_delta_ins_players_phone_a3_0   UNION SELECT players_phone_a3_0.CONTACTID AS COL0, players_phone_a3_0.NAME AS COL1, players_phone_a3_0.PHONE AS COL2 
FROM public.players_phone AS players_phone_a3_0 
WHERE NOT EXISTS ( SELECT * 
FROM __tmp_delta_del_players_phone AS __tmp_delta_del_players_phone_a3 
WHERE __tmp_delta_del_players_phone_a3.PHONE = players_phone_a3_0.PHONE AND __tmp_delta_del_players_phone_a3.NAME = players_phone_a3_0.NAME AND __tmp_delta_del_players_phone_a3.CONTACTID = players_phone_a3_0.CONTACTID ) ) AS p_1_a3_0 
WHERE p_1_a3_0.COL2 IS NULL ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.players_contact AS players_contact_a4_0, public.players_contact AS players_contact_a4_1 
WHERE players_contact_a4_1.CONTACTID = players_contact_a4_0.CONTACTID AND players_contact_a4_0.EMAIL  <>  players_contact_a4_1.EMAIL  UNION ALL SELECT  
FROM public.players_contact AS players_contact_a4_0, public.players_contact AS players_contact_a4_1 
WHERE players_contact_a4_1.CONTACTID = players_contact_a4_0.CONTACTID AND players_contact_a4_0.NAME  <>  players_contact_a4_1.NAME  UNION ALL SELECT  
FROM public.players_contact AS players_contact_a4_0, public.players_contact AS players_contact_a4_1 
WHERE players_contact_a4_1.CONTACTID = players_contact_a4_0.CONTACTID AND players_contact_a4_0.PHONE  <>  players_contact_a4_1.PHONE  UNION ALL SELECT  
FROM public.players_contact AS players_contact_a4_0 
WHERE players_contact_a4_0.EMAIL  IS NOT NULL AND players_contact_a4_0.PHONE  IS NOT NULL  UNION ALL SELECT  
FROM public.players_contact AS players_contact_a4_0 
WHERE players_contact_a4_0.EMAIL IS NULL AND players_contact_a4_0.PHONE IS NULL ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_players_phone AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_players_phone as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_players_phone;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_players_phone;
        
            WITH __tmp_delta_del_players_phone_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_players_phone_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_players_contact FROM (SELECT (ROW(COL0,COL1,COL2,COL3) :: public.players_contact).* 
            FROM (SELECT delta_del_players_contact_a4_0.COL0 AS COL0, delta_del_players_contact_a4_0.COL1 AS COL1, delta_del_players_contact_a4_0.COL2 AS COL2, delta_del_players_contact_a4_0.COL3 AS COL3 
FROM (SELECT p_0_a4_0.COL0 AS COL0, p_0_a4_0.COL1 AS COL1, p_0_a4_0.COL2 AS COL2, p_0_a4_0.COL3 AS COL3 
FROM (SELECT players_contact_a4_1.CONTACTID AS COL0, players_contact_a4_1.PHONE AS COL1, players_contact_a4_1.NAME AS COL2, players_contact_a4_1.EMAIL AS COL3 
FROM __tmp_delta_del_players_phone_ar AS __tmp_delta_del_players_phone_ar_a3_0, public.players_contact AS players_contact_a4_1 
WHERE players_contact_a4_1.NAME = __tmp_delta_del_players_phone_ar_a3_0.NAME AND players_contact_a4_1.PHONE = __tmp_delta_del_players_phone_ar_a3_0.PHONE AND players_contact_a4_1.CONTACTID = __tmp_delta_del_players_phone_ar_a3_0.CONTACTID AND players_contact_a4_1.EMAIL IS NULL ) AS p_0_a4_0  ) AS delta_del_players_contact_a4_0  ) AS delta_del_players_contact_extra_alias) AS tbl;


            WITH __tmp_delta_del_players_phone_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_players_phone_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_players_contact FROM (SELECT (ROW(COL0,COL1,COL2,COL3) :: public.players_contact).* 
            FROM (SELECT delta_ins_players_contact_a4_0.COL0 AS COL0, delta_ins_players_contact_a4_0.COL1 AS COL1, delta_ins_players_contact_a4_0.COL2 AS COL2, delta_ins_players_contact_a4_0.COL3 AS COL3 
FROM (SELECT p_0_a4_0.COL0 AS COL0, p_0_a4_0.COL1 AS COL1, p_0_a4_0.COL2 AS COL2, p_0_a4_0.COL3 AS COL3 
FROM (SELECT __tmp_delta_ins_players_phone_ar_a3_0.CONTACTID AS COL0, __tmp_delta_ins_players_phone_ar_a3_0.PHONE AS COL1, __tmp_delta_ins_players_phone_ar_a3_0.NAME AS COL2, NULL AS COL3 
FROM __tmp_delta_ins_players_phone_ar AS __tmp_delta_ins_players_phone_ar_a3_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.players_contact AS players_contact_a4 
WHERE players_contact_a4.EMAIL IS NULL AND players_contact_a4.NAME = __tmp_delta_ins_players_phone_ar_a3_0.NAME AND players_contact_a4.PHONE = __tmp_delta_ins_players_phone_ar_a3_0.PHONE AND players_contact_a4.CONTACTID = __tmp_delta_ins_players_phone_ar_a3_0.CONTACTID ) ) AS p_0_a4_0  ) AS delta_ins_players_contact_a4_0  ) AS delta_ins_players_contact_extra_alias) AS tbl; 


            IF array_delta_del_players_contact IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_players_contact IN array array_delta_del_players_contact  LOOP 
                   DELETE FROM public.players_contact WHERE CONTACTID =  temprec_delta_del_players_contact.CONTACTID AND PHONE =  temprec_delta_del_players_contact.PHONE AND NAME =  temprec_delta_del_players_contact.NAME AND EMAIL =  temprec_delta_del_players_contact.EMAIL;
                END LOOP;
            END IF;


            IF array_delta_ins_players_contact IS DISTINCT FROM NULL THEN 
                INSERT INTO public.players_contact (SELECT * FROM unnest(array_delta_ins_players_contact) as array_delta_ins_players_contact_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.players_phone';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.players_phone ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.players_phone_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_players_phone' OR table_name = '__tmp_delta_del_players_phone')
    THEN
        -- RAISE LOG 'execute procedure players_phone_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_players_phone ( LIKE public.players_phone )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_players_phone_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_players_phone DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.players_phone_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_players_phone ( LIKE public.players_phone )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_players_phone_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_players_phone DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.players_phone_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.players_phone';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.players_phone ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS players_phone_trigger_materialization ON public.players_phone;
CREATE TRIGGER players_phone_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.players_phone FOR EACH STATEMENT EXECUTE PROCEDURE public.players_phone_materialization();

CREATE OR REPLACE FUNCTION public.players_phone_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure players_phone_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value IS NULL) FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_players_phone WHERE ROW(CONTACTID,NAME,PHONE) = NEW;
      INSERT INTO __tmp_delta_ins_players_phone SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value IS NULL) FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_players_phone WHERE ROW(CONTACTID,NAME,PHONE) = OLD;
      INSERT INTO __tmp_delta_del_players_phone SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_players_phone WHERE ROW(CONTACTID,NAME,PHONE) = NEW;
      INSERT INTO __tmp_delta_ins_players_phone SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_players_phone WHERE ROW(CONTACTID,NAME,PHONE) = OLD;
      INSERT INTO __tmp_delta_del_players_phone SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.players_phone';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.players_phone ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS players_phone_trigger_update ON public.players_phone;
CREATE TRIGGER players_phone_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.players_phone FOR EACH ROW EXECUTE PROCEDURE public.players_phone_update();

CREATE OR REPLACE FUNCTION public.players_phone_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_players_phone_trigger_delta_action_ins, __tmp_players_phone_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_players_phone_trigger_delta_action_ins, __tmp_players_phone_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS players_phone_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_players_phone;
    DROP TABLE IF EXISTS __tmp_delta_ins_players_phone;
    RETURN true;
  END;
$$;*/