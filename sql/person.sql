-- View: public.persons

-- DROP VIEW public.persons;

CREATE OR REPLACE VIEW public.persons
 AS
 SELECT metadata.id,
    metadata.uuid,
    unnest(xpath('//dc:title/text()'::text, metadata.data::xml, ARRAY[ARRAY['dc'::text, 'http://purl.org/dc/elements/1.1/'::text]])::text[]) AS title,
    metadata.data,
    metadata.schemaid,
    metadata.istemplate,
    metadata.source
   FROM metadata
  WHERE metadata.schemaid::text = 'dublin-core'::text AND metadata.data ~~ '%person%'::text
  ORDER BY metadata.id;

ALTER TABLE public.persons
    OWNER TO geonetwork;

-- View: public.prov_person

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_person;

-- role do not retrieve the first role encountered and note the one matching the personn

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_person
TABLESPACE pg_default
AS
 SELECT parsed.uuid_document,
    parsed.person,
    -- parsed.role,
    persons.uuid,
    parsed.data
   FROM ( SELECT metadata.uuid AS uuid_document,
            unnest(xpath('//cit:party//cit:name/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS person,
            -- unnest(xpath('//cit:role/cit:CI_RoleCode/@codeListValue'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS role,
            metadata.data
           FROM metadata) parsed
     LEFT JOIN persons ON parsed.person = persons.title
  WHERE parsed.uuid_document IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.prov_person
    OWNER TO geonetwork;
