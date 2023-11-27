-- View: public.softwares

-- DROP VIEW public.softwares;

CREATE OR REPLACE VIEW public.softwares
 AS
 SELECT metadata.id,
    metadata.uuid,
    unnest(xpath('//dc:title/text()'::text, metadata.data::xml, ARRAY[ARRAY['dc'::text, 'http://purl.org/dc/elements/1.1/'::text]])::text[]) AS title,
    metadata.data,
    metadata.schemaid,
    metadata.istemplate,
    metadata.source
   FROM metadata
  WHERE metadata.schemaid::text = 'dublin-core'::text AND metadata.data ~~ '%software%'::text
  ORDER BY metadata.id;

ALTER TABLE public.softwares
    OWNER TO geonetwork;

-- View: public.prov_software

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_software;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_software
TABLESPACE pg_default
AS
 SELECT parsed.uuid_document,
    parsed.software_agent,
    parsed.software_uuid,
    softwares.uuid,
    parsed.software_website,
    parsed.software_comment,
    parsed.data
   FROM ( SELECT metadata.uuid AS uuid_document,
            unnest(xpath('//mrl:softwareReference/cit:CI_Citation/cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS software_agent,
            unnest(xpath('//mrl:softwareReference/cit:CI_Citation/cit:identifier//mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS software_uuid,
            unnest(xpath('//mrl:softwareReference/cit:CI_Citation/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS software_website,
            unnest(xpath('//mrl:softwareReference/cit:CI_Citation/cit:onlineResource/cit:CI_OnlineResource/cit:description/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS software_comment,
            metadata.data
           FROM metadata) parsed
     LEFT JOIN softwares ON parsed.software_agent = softwares.title
  WHERE parsed.uuid_document IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.prov_software
    OWNER TO geonetwork;
