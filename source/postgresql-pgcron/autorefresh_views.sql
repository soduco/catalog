-- Rafraichissement automatique des vues matérialisées
-- lors d'une modification (UPDATE|INSERT|DELETE) sur
-- la table public.metadata.
-- Principe :
--     - une modification sur public.metadata place déclence
--       un trigger demandant la mise à jour des vues avec
--       un `flag` stocké dans la table `flag_refresh_materialized_views`.
--     - toutes les 5 minutes, un cronjob regarde cette table.
--       Si le flag est VRAI, déclenche le rafraichissement de toutes
--       les vues matérialisées dans le schéma où se trouve la function
--       refresh_materialized_views().
--     - une fois les vues traitées, le flag est mis à FAUX.

-- Cleanup
DROP TABLE IF EXISTS flag_refresh_materialized_views;
DROP FUNCTION IF EXISTS refresh_materialized_views();
DROP FUNCTION IF EXISTS ask_matviews_refresh() CASCADE;

-- Table "flag" utilisée pour demander un rafraichissement des vues
CREATE TABLE flag_refresh_materialized_views (
    flag BOOLEAN NOT NULL DEFAULT FALSE
);
INSERT INTO flag_refresh_materialized_views VALUES (FALSE);

CREATE FUNCTION refresh_materialized_views()
RETURNS TEXT[] AS $$
DECLARE
    status_flag BOOLEAN;
    view TEXT;
    materialized_views TEXT[];
BEGIN
    -- Rafraichit toutes les vues matérialises dans le schéma courant
    -- et réinitialise la valeur du drapeau flag_refresh_materialized_views.
    -- RETOURNE: TEXT[] la liste des vues rafraichies.
    SELECT flag
    INTO status_flag
    FROM flag_refresh_materialized_views;
    
    IF status_flag THEN
        SELECT ARRAY_AGG(matviewname) INTO materialized_views
        FROM pg_matviews
        WHERE schemaname = current_schema();

        FOREACH view IN ARRAY materialized_views
        LOOP
            EXECUTE format('REFRESH MATERIALIZED VIEW %I', view);
            RAISE DEBUG 'Refreshed view %', view;
        END LOOP;
        UPDATE flag_refresh_materialized_views SET flag = FALSE;
        RETURN materialized_views;
    ELSE
        RAISE DEBUG 'Call to refresh_materialized_views() but status flag is %', status_flag;
        RETURN ARRAY[]::TEXT[];
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ask_matviews_refresh()
RETURNS TRIGGER AS $$
BEGIN
    -- Demande un rafraichissement des vues matérialisées
    UPDATE flag_refresh_materialized_views SET flag = TRUE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer ce trigger sur toutes les tables à partir desquslles
-- sont constuites les vues à rafraichir.
CREATE TRIGGER trigger_ask_matview_refresh
AFTER INSERT OR UPDATE OR DELETE ON public.metadata
FOR EACH STATEMENT EXECUTE FUNCTION ask_matviews_refresh();

-- Ajoute un cronjob qui surveille la valeur du drapeau de rafraichissement toutes les 5 minutes.
SELECT cron.schedule('refresh-materialized-views','5 * * * *', $$SELECT refresh_materialized_views()$$);

-- Pour désactiver le cronjob
-- SELECT cron.unschedule('refresh-materialized-views');

-- Vérifie que le cronjob a été ajouté;
SELECT * FROM cron.job;

-- Inspection des jobs effectués
-- Les logs sont désactivés via postgresql.conf.
-- Pour logger les détails, changer la valeur de `cron.log_run` dans docker-compose.yml
SELECT * FROM cron.job_run_details;