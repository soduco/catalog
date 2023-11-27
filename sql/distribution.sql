-- View: public.prov_distribution

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_distribution;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_distribution
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.output_uuid,
    parsed.download_url,
    parsed.data
   FROM ( SELECT metadata.uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:output/mrl:LE_Source/mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS output_uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:output/mrl:LE_Source/mrl:sourceCitation//cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS download_url,
            metadata.data
           FROM metadata) parsed
  WHERE parsed.uuid IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.prov_distribution
    OWNER TO geonetwork;
