-- Program is validated --
CREATE OR REPLACE VIEW public.contactsporto AS 
SELECT __dummy__.COL0 AS NAME,__dummy__.COL1 AS CONTACT 
FROM (SELECT contactsporto_a2_0.COL0 AS COL0, contactsporto_a2_0.COL1 AS COL1 
FROM (SELECT playerscontact_a3_1.PLAYERS_NAME AS COL0, playerscontact_a3_1.CONTACT AS COL1 
FROM public.players AS players_a3_0, public.playerscontact AS playerscontact_a3_1 
WHERE playerscontact_a3_1.PLAYERS_NAME = players_a3_0.NAME AND players_a3_0.ADDRESS = 'Porto' ) AS contactsporto_a2_0  ) AS __dummy__;

CREATE EXTENSION IF NOT EXISTS plsh;

CREATE TABLE IF NOT EXISTS public.__dummy__contactsporto_detected_deletions (txid int, LIKE public.contactsporto );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsporto_detected_deletions ON public.__dummy__contactsporto_detected_deletions (txid);
CREATE TABLE IF NOT EXISTS public.__dummy__contactsporto_detected_insertions (txid int, LIKE public.contactsporto );
CREATE INDEX IF NOT EXISTS idx__dummy__contactsporto_detected_insertions ON public.__dummy__contactsporto_detected_insertions (txid);

CREATE OR REPLACE FUNCTION public.contactsporto_get_detected_update_data(txid int)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  deletion_data text;
  insertion_data text;
  json_data text;
  BEGIN
    insertion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsporto_detected_insertions as t where t.txid = $1);
    IF insertion_data IS NOT DISTINCT FROM NULL THEN 
        insertion_data := '[]';
    END IF; 
    deletion_data := (SELECT (array_to_json(array_agg(t)))::text FROM public.__dummy__contactsporto_detected_deletions as t where t.txid = $1);
    IF deletion_data IS NOT DISTINCT FROM NULL THEN 
        deletion_data := '[]';
    END IF; 
    IF (insertion_data IS DISTINCT FROM '[]') OR (deletion_data IS DISTINCT FROM '[]') THEN 
        -- calcuate the update data
        json_data := concat('{"view": ' , '"public.contactsporto"', ', ' , '"insertions": ' , insertion_data , ', ' , '"deletions": ' , deletion_data , '}');
        -- clear the update data
        --DELETE FROM public.__dummy__contactsporto_detected_deletions;
        --DELETE FROM public.__dummy__contactsporto_detected_insertions;
    END IF;
    RETURN json_data;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsporto_run_shell(text) RETURNS text AS $$
#!/bin/sh
echo "true"
$$ LANGUAGE plsh;


CREATE OR REPLACE FUNCTION public.contactsporto_delta_action()
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
  array_delta_del public.contactsporto[];
  array_delta_ins public.contactsporto[];
  temprec_delta_del_playerscontact public.playerscontact%ROWTYPE;
            array_delta_del_playerscontact public.playerscontact[];
temprec_delta_ins_players public.players%ROWTYPE;
            array_delta_ins_players public.players[];
temprec_delta_ins_playerscontact public.playerscontact%ROWTYPE;
            array_delta_ins_playerscontact public.playerscontact[];
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'contactsporto_delta_action_flag') THEN
        -- RAISE LOG 'execute procedure contactsporto_delta_action';
        CREATE TEMPORARY TABLE contactsporto_delta_action_flag ON COMMIT DROP AS (SELECT true as finish);
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.players AS players_a3_0, (SELECT __tmp_delta_ins_contactsporto_a2_0.CONTACT AS COL0, __tmp_delta_ins_contactsporto_a2_0.NAME AS COL1 
FROM __tmp_delta_ins_contactsporto AS __tmp_delta_ins_contactsporto_a2_0   UNION SELECT contactsporto_a2_0.CONTACT AS COL0, contactsporto_a2_0.NAME AS COL1 
FROM public.contactsporto AS contactsporto_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM __tmp_delta_del_contactsporto AS __tmp_delta_del_contactsporto_a2 
WHERE __tmp_delta_del_contactsporto_a2.CONTACT = contactsporto_a2_0.CONTACT AND __tmp_delta_del_contactsporto_a2.NAME = contactsporto_a2_0.NAME ) ) AS p_1_a2_1 
WHERE p_1_a2_1.COL1 = players_a3_0.NAME AND players_a3_0.ADDRESS  <>  'Porto' ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the view are violated';
        END IF;
        IF EXISTS (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM (SELECT  
FROM public.players AS players_a3_0, public.players AS players_a3_1 
WHERE players_a3_1.NAME = players_a3_0.NAME AND players_a3_0.ADDRESS  <>  players_a3_1.ADDRESS  UNION ALL SELECT  
FROM public.playerscontact AS playerscontact_a3_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.players AS players_a3 
WHERE players_a3.NAME = playerscontact_a3_0.PLAYERS_NAME ) ) AS p_0_a0_0  ) AS bot_a0_0  ) AS __dummy__ )
        THEN 
          RAISE check_violation USING MESSAGE = 'Invalid view update: constraints on the source relations are violated';
        END IF;
        SELECT array_agg(tbl) INTO array_delta_ins FROM __tmp_delta_ins_contactsporto AS tbl;
        SELECT array_agg(tbl) INTO array_delta_del FROM __tmp_delta_del_contactsporto as tbl;
        select count(*) INTO delta_ins_size FROM __tmp_delta_ins_contactsporto;
        select count(*) INTO delta_del_size FROM __tmp_delta_del_contactsporto;
        
            WITH __tmp_delta_del_contactsporto_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsporto_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_del_playerscontact FROM (SELECT (ROW(COL0,COL1,COL2) :: public.playerscontact).* 
            FROM (SELECT delta_del_playerscontact_a3_0.COL0 AS COL0, delta_del_playerscontact_a3_0.COL1 AS COL1, delta_del_playerscontact_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT playerscontact_a3_2._ID AS COL0, playerscontact_a3_2.CONTACT AS COL1, playerscontact_a3_2.PLAYERS_NAME AS COL2 
FROM __tmp_delta_del_contactsporto_ar AS __tmp_delta_del_contactsporto_ar_a2_0, public.players AS players_a3_1, public.playerscontact AS playerscontact_a3_2 
WHERE playerscontact_a3_2.PLAYERS_NAME = players_a3_1.NAME AND playerscontact_a3_2.PLAYERS_NAME = __tmp_delta_del_contactsporto_ar_a2_0.NAME AND playerscontact_a3_2.CONTACT = __tmp_delta_del_contactsporto_ar_a2_0.CONTACT AND players_a3_1.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM (SELECT playerscontact_a3_1._ID AS COL0, playerscontact_a3_1.CONTACT AS COL1, playerscontact_a3_1.PLAYERS_NAME AS COL2 
FROM public.players AS players_a3_0, public.playerscontact AS playerscontact_a3_1 
WHERE playerscontact_a3_1.PLAYERS_NAME = players_a3_0.NAME AND players_a3_0.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM (SELECT playerscontact_a3_1.CONTACT AS COL0, playerscontact_a3_1.PLAYERS_NAME AS COL1 
FROM public.players AS players_a3_0, public.playerscontact AS playerscontact_a3_1 
WHERE playerscontact_a3_1.PLAYERS_NAME = players_a3_0.NAME AND players_a3_0.ADDRESS = 'Porto' ) AS p_2_a2 
WHERE p_2_a2.COL1 = playerscontact_a3_1.PLAYERS_NAME AND p_2_a2.COL0 = playerscontact_a3_1.CONTACT ) ) AS p_1_a3 
WHERE p_1_a3.COL2 = playerscontact_a3_2.PLAYERS_NAME AND p_1_a3.COL1 = playerscontact_a3_2.CONTACT AND p_1_a3.COL0 = playerscontact_a3_2._ID ) ) AS p_0_a3_0  ) AS delta_del_playerscontact_a3_0  ) AS delta_del_playerscontact_extra_alias) AS tbl;


            WITH __tmp_delta_del_contactsporto_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsporto_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_players FROM (SELECT (ROW(COL0,COL1,COL2) :: public.players).* 
            FROM (SELECT delta_ins_players_a3_0.COL0 AS COL0, delta_ins_players_a3_0.COL1 AS COL1, delta_ins_players_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT '' AS COL0, 'Porto' AS COL1, __tmp_delta_ins_contactsporto_ar_a2_0.NAME AS COL2 
FROM __tmp_delta_ins_contactsporto_ar AS __tmp_delta_ins_contactsporto_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM (SELECT '' AS COL0, 'Porto' AS COL1, playerscontact_a3_1.PLAYERS_NAME AS COL2 
FROM public.players AS players_a3_0, public.playerscontact AS playerscontact_a3_1 
WHERE playerscontact_a3_1.PLAYERS_NAME = players_a3_0.NAME AND players_a3_0.ADDRESS = 'Porto' AND NOT EXISTS ( SELECT * 
FROM public.players AS players_a3 
WHERE players_a3.NAME = playerscontact_a3_1.PLAYERS_NAME ) ) AS p_1_a3 
WHERE p_1_a3.COL2 = __tmp_delta_ins_contactsporto_ar_a2_0.NAME AND p_1_a3.COL1 = 'Porto' AND p_1_a3.COL0 = '' ) AND NOT EXISTS ( SELECT * 
FROM public.players AS players_a3 
WHERE players_a3.NAME = __tmp_delta_ins_contactsporto_ar_a2_0.NAME ) ) AS p_0_a3_0  ) AS delta_ins_players_a3_0  ) AS delta_ins_players_extra_alias) AS tbl;


            WITH __tmp_delta_del_contactsporto_ar AS (SELECT * FROM unnest(array_delta_del) as array_delta_del_alias limit delta_del_size),
            __tmp_delta_ins_contactsporto_ar as (SELECT * FROM unnest(array_delta_ins) as array_delta_ins_alias limit delta_ins_size)
            SELECT array_agg(tbl) INTO array_delta_ins_playerscontact FROM (SELECT (ROW(COL0,COL1,COL2) :: public.playerscontact).* 
            FROM (SELECT delta_ins_playerscontact_a3_0.COL0 AS COL0, delta_ins_playerscontact_a3_0.COL1 AS COL1, delta_ins_playerscontact_a3_0.COL2 AS COL2 
FROM (SELECT p_0_a3_0.COL0 AS COL0, p_0_a3_0.COL1 AS COL1, p_0_a3_0.COL2 AS COL2 
FROM (SELECT '' AS COL0, __tmp_delta_ins_contactsporto_ar_a2_0.CONTACT AS COL1, __tmp_delta_ins_contactsporto_ar_a2_0.NAME AS COL2 
FROM __tmp_delta_ins_contactsporto_ar AS __tmp_delta_ins_contactsporto_ar_a2_0 
WHERE NOT EXISTS ( SELECT * 
FROM public.playerscontact AS playerscontact_a3 
WHERE playerscontact_a3.PLAYERS_NAME = __tmp_delta_ins_contactsporto_ar_a2_0.NAME AND playerscontact_a3.CONTACT = __tmp_delta_ins_contactsporto_ar_a2_0.CONTACT ) ) AS p_0_a3_0  ) AS delta_ins_playerscontact_a3_0  ) AS delta_ins_playerscontact_extra_alias) AS tbl; 


            IF array_delta_del_playerscontact IS DISTINCT FROM NULL THEN 
                FOREACH temprec_delta_del_playerscontact IN array array_delta_del_playerscontact  LOOP 
                   DELETE FROM public.playerscontact WHERE _ID =  temprec_delta_del_playerscontact._ID AND CONTACT =  temprec_delta_del_playerscontact.CONTACT AND PLAYERS_NAME =  temprec_delta_del_playerscontact.PLAYERS_NAME;
                END LOOP;
            END IF;


            IF array_delta_ins_players IS DISTINCT FROM NULL THEN 
                INSERT INTO public.players (SELECT * FROM unnest(array_delta_ins_players) as array_delta_ins_players_alias) ; 
            END IF;


            IF array_delta_ins_playerscontact IS DISTINCT FROM NULL THEN 
                INSERT INTO public.playerscontact (SELECT * FROM unnest(array_delta_ins_playerscontact) as array_delta_ins_playerscontact_alias) ; 
            END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsporto';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsporto ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

CREATE OR REPLACE FUNCTION public.contactsporto_materialization()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = '__tmp_delta_ins_contactsporto' OR table_name = '__tmp_delta_del_contactsporto')
    THEN
        -- RAISE LOG 'execute procedure contactsporto_materialization';
        CREATE TEMPORARY TABLE __tmp_delta_ins_contactsporto ( LIKE public.contactsporto )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsporto_trigger_delta_action_ins
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_ins_contactsporto DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsporto_delta_action();

        CREATE TEMPORARY TABLE __tmp_delta_del_contactsporto ( LIKE public.contactsporto )  ON COMMIT DROP;
        CREATE CONSTRAINT TRIGGER __tmp_contactsporto_trigger_delta_action_del
        AFTER INSERT OR UPDATE OR DELETE ON 
            __tmp_delta_del_contactsporto DEFERRABLE INITIALLY DEFERRED 
            FOR EACH ROW EXECUTE PROCEDURE public.contactsporto_delta_action();
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsporto';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsporto ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsporto_trigger_materialization ON public.contactsporto;
CREATE TRIGGER contactsporto_trigger_materialization
    BEFORE INSERT OR UPDATE OR DELETE ON
      public.contactsporto FOR EACH STATEMENT EXECUTE PROCEDURE public.contactsporto_materialization();

CREATE OR REPLACE FUNCTION public.contactsporto_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  DECLARE
  text_var1 text;
  text_var2 text;
  text_var3 text;
  BEGIN
    -- RAISE LOG 'execute procedure contactsporto_update';
    IF TG_OP = 'INSERT' THEN
      -- RAISE LOG 'NEW: %', NEW;
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_del_contactsporto WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsporto SELECT (NEW).*; 
    ELSIF TG_OP = 'UPDATE' THEN
      IF (SELECT count(*) FILTER (WHERE j.value = jsonb 'null') FROM  jsonb_each(to_jsonb(NEW)) j) > 0 THEN 
        RAISE check_violation USING MESSAGE = 'Invalid update on view: view does not accept null value';
      END IF;
      DELETE FROM __tmp_delta_ins_contactsporto WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsporto SELECT (OLD).*;
      DELETE FROM __tmp_delta_del_contactsporto WHERE ROW(NAME,CONTACT) = NEW;
      INSERT INTO __tmp_delta_ins_contactsporto SELECT (NEW).*; 
    ELSIF TG_OP = 'DELETE' THEN
      -- RAISE LOG 'OLD: %', OLD;
      DELETE FROM __tmp_delta_ins_contactsporto WHERE ROW(NAME,CONTACT) = OLD;
      INSERT INTO __tmp_delta_del_contactsporto SELECT (OLD).*;
    END IF;
    RETURN NULL;
  EXCEPTION
    WHEN object_not_in_prerequisite_state THEN
        RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert or delete or update to source relations of public.contactsporto';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                text_var2 = PG_EXCEPTION_DETAIL,
                                text_var3 = MESSAGE_TEXT;
        RAISE SQLSTATE 'DA000' USING MESSAGE = 'error on the trigger of public.contactsporto ; error code: ' || text_var1 || ' ; ' || text_var2 ||' ; ' || text_var3;
        RETURN NULL;
  END;
$$;

DROP TRIGGER IF EXISTS contactsporto_trigger_update ON public.contactsporto;
CREATE TRIGGER contactsporto_trigger_update
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      public.contactsporto FOR EACH ROW EXECUTE PROCEDURE public.contactsporto_update();

CREATE OR REPLACE FUNCTION public.contactsporto_propagate_updates ()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
  BEGIN
    SET CONSTRAINTS __tmp_contactsporto_trigger_delta_action_ins, __tmp_contactsporto_trigger_delta_action_del IMMEDIATE;
    SET CONSTRAINTS __tmp_contactsporto_trigger_delta_action_ins, __tmp_contactsporto_trigger_delta_action_del DEFERRED;
    DROP TABLE IF EXISTS contactsporto_delta_action_flag;
    DROP TABLE IF EXISTS __tmp_delta_del_contactsporto;
    DROP TABLE IF EXISTS __tmp_delta_ins_contactsporto;
    RETURN true;
  END;
$$;

