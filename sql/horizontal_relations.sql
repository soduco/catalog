-- View: public.rico_horizontal_relations

-- DROP MATERIALIZED VIEW IF EXISTS public.rico_horizontal_relations;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_horizontal_relations
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.parent,
    parsed.data
   FROM ( SELECT metadata.uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:source/@uuidref'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text]])::text[]) AS parent,
            metadata.data
           FROM metadata) parsed
  WHERE parsed.uuid IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.rico_horizontal_relations
    OWNER TO geonetwork;

