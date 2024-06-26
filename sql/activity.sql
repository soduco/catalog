-- View: public.prov_activity

DROP MATERIALIZED VIEW IF EXISTS public.prov_activity CASCADE;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_activity
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.activity_type,
    parsed.activity_title,
    parsed.resource_uuid,
    parsed.source_uuid,
    parsed.software_uuid,
    parsed.output_uuid,
    parsed.date_begin,
    parsed.date_end,
    parsed.description,
    parsed.data
   FROM ( SELECT metadata.uuid AS resource_uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:processStep//mrl:reference//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:processStep//mrl:reference//cit:CI_Citation/cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS activity_title,
            unnest(xpath('//mdb:resourceLineage//mrl:processingInformation/mrl:LE_Processing/mrl:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS activity_type,
            xpath('//mdb:resourceLineage//mrl:source//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[] AS source_uuid,
            unnest(xpath('//mrl:softwareReference//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[]) AS software_uuid,
            xpath('//mrl:processStep//mrl:output//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]])::text[] AS output_uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:LE_ProcessStep//mrl:stepDateTime//gml:begin//gml:timePosition/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gml'::text, 'http://www.opengis.net/gml/3.2'::text]])::text[]) AS date_begin,
            unnest(xpath('//mdb:resourceLineage//mrl:LE_ProcessStep//mrl:stepDateTime//gml:end//gml:timePosition/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gml'::text, 'http://www.opengis.net/gml/3.2'::text]])::text[]) AS date_end,
            unnest(xpath('//mdb:resourceLineage//mrl:processStep/mrl:LE_ProcessStep/mrl:description/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS description,
            metadata.data
           FROM metadata) parsed
  WHERE parsed.uuid IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.prov_activity
    OWNER TO geonetwork;

-- View: public.prov_activity_source

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_activity_source;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_activity_source
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.source_uuid,
    parsed.resource_uuid,
    unnest(xpath(('//mdb:resourceLineage//mrl:source//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString[text()='''::text || parsed.source_uuid) || ''']/../../../../cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS source_title,
    unnest(xpath(('//mdb:resourceLineage//mrl:source//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString[text()='''::text || parsed.source_uuid) || ''']/../../../../cit:onlineResource//gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS source_url
   FROM ( SELECT prov_activity.uuid,
            unnest(prov_activity.source_uuid) AS source_uuid,
            prov_activity.resource_uuid
           FROM prov_activity
          WHERE prov_activity.activity_type = ANY (ARRAY['Scannage'::text, 'Numerisation'::text, 'Vectorisation'::text, 'CorrectionManuelle'::text, 'Geolocalisation'::text, 'Georeferencement'::text, 'Geocodage'::text, 'AcquisitionPointsControle'::text, 'Liage'::text, 'OCR'::text, 'NER'::text, 'DetectionMiseEnPage'::text, 'Structuration'::text, 'Autre'::text])) parsed
     LEFT JOIN metadata ON parsed.resource_uuid::text = metadata.uuid::text
WITH DATA;

ALTER TABLE IF EXISTS public.prov_activity_source
    OWNER TO geonetwork;


-- View: public.prov_activity_output

-- DROP MATERIALIZED VIEW IF EXISTS public.prov_activity_output;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.prov_activity_output
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.output_uuid,
    parsed.resource_uuid,
    unnest(xpath(('//mdb:resourceLineage//mrl:output//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString[text()='''::text || parsed.output_uuid) || ''']/../../../../cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS output_title,
    unnest(xpath(('//mdb:resourceLineage//mrl:output//mrl:sourceCitation//cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString[text()='''::text || parsed.output_uuid) || ''']/../../../../cit:onlineResource//gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]])::text[]) AS output_url
   FROM ( SELECT prov_activity.uuid,
            unnest(prov_activity.output_uuid) AS output_uuid,
            prov_activity.resource_uuid
           FROM prov_activity
          WHERE prov_activity.activity_type = ANY (ARRAY['Scannage'::text, 'Numerisation'::text, 'Vectorisation'::text, 'CorrectionManuelle'::text, 'Geolocalisation'::text, 'Georeferencement'::text, 'Geocodage'::text, 'AcquisitionPointsControle'::text, 'Liage'::text, 'OCR'::text, 'NER'::text, 'DetectionMiseEnPage'::text, 'Structuration'::text, 'Autre'::text])) parsed
     LEFT JOIN metadata ON parsed.resource_uuid::text = metadata.uuid::text
WITH DATA;

ALTER TABLE IF EXISTS public.prov_activity_output
    OWNER TO geonetwork;