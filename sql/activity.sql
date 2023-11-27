-- View: public.prov_activity

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_activity;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_activity
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.activity_type,
    parsed.source_uuid,
    parsed.software_uuid,
    parsed.data_generated_uuid,
    parsed.date_begin,
    parsed.date_end,
    parsed.description,
    parsed.data
   FROM ( SELECT metadata.uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:processingInformation/mrl:LE_Processing/mrl:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS activity_type,
            unnest(xpath('//mdb:resourceLineage//mrl:source//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS source_uuid,
            unnest(xpath('//mrl:softwareReference//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS software_uuid,
            unnest(xpath('//mrl:processStep//mrl:output//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS data_generated_uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:LE_ProcessStep//mrl:stepDateTime//gml:begin//gml:timePosition/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gml'::text, 'http://www.opengis.net/gml/3.2'::text]])::text[]) AS date_begin,
            unnest(xpath('//mdb:resourceLineage//mrl:LE_ProcessStep//mrl:stepDateTime//gml:end//gml:timePosition/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gml'::text, 'http://www.opengis.net/gml/3.2'::text]])::text[]) AS date_end,
            unnest(xpath('//mdb:resourceLineage//mrl:processStep/mrl:LE_ProcessStep/mrl:description/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS description,
            metadata.data
           FROM metadata) parsed
  WHERE parsed.uuid IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.prov_activity
    OWNER TO geonetwork;
