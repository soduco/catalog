-- View: public.rico_recordresources

-- DROP MATERIALIZED VIEW IF EXISTS public.rico_recordresources;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_recordresources
TABLESPACE pg_default
AS
 WITH raw AS (
         SELECT (xpath('//mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]]))[1]::text AS uuid,
            (xpath('//mri:citation/cit:CI_Citation/cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]]))[1]::text AS title,
            (xpath('//mrd:distributionFormat/mrd:MD_Format/mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mrd'::text, 'http://standards.iso.org/iso/19115/-3/mrd/1.0'::text]]))[1]::text AS distribution_format,
            ( SELECT st_astext(st_makeenvelope(extent_coords.coords[1], extent_coords.coords[3], extent_coords.coords[2], extent_coords.coords[4])) AS st_astext
                   FROM ( SELECT xpath('//gex:EX_GeographicBoundingBox//gco:Decimal/text()'::text, metadata.data::xml, ARRAY[ARRAY['gex'::text, 'http://standards.iso.org/iso/19115/-3/gex/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]::double precision[] AS coords) extent_coords) AS geo_extent,
            xpath('//gex:EX_TemporalExtent//gex:extent/gml:TimePeriod/*/text()'::text, metadata.data::xml, ARRAY[ARRAY['gex'::text, 'http://standards.iso.org/iso/19115/-3/gex/1.0'::text], ARRAY['gml'::text, 'http://www.opengis.net/gml/3.2'::text]])::text[] AS temporal_extent,
            (xpath('//mri:spatialResolution/mri:MD_Resolution/mri:equivalentScale/mri:MD_RepresentativeFraction/mri:denominator/gco:Integer/text()'::text, metadata.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]]))[1]::text AS geometric_resolution,
            (xpath('//mrs:MD_ReferenceSystem/mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mrs'::text, 'http://standards.iso.org/iso/19115/-3/mrs/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text]]))[1]::text AS crs,
            (ARRAY( SELECT to_date(unnest(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''creation'']/gco:Date/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]), 'YYYY-MM-DD'::text) AS to_date))[1] AS creation,
            (ARRAY( SELECT to_date(unnest(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''released'']/gco:Date/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]), 'YYYY-MM-DD'::text) AS to_date))[1] AS released,
            xpath('//mri:keyword/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[] AS keywords,
            metadata.data
           FROM metadata
          WHERE (EXISTS ( SELECT true AS bool
                   FROM unnest(xpath('//mri:keyword/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) xpath_text(xpath_text)
                  WHERE xpath_text.xpath_text ~* '(record(set|part)?)|file'::text))
        )
 SELECT raw.uuid,
    raw.title,
    array_to_string(ARRAY( SELECT kw.kw
           FROM unnest(raw.keywords) kw(kw)
          WHERE kw.kw ~~* ANY (ARRAY['Record'::text, 'RecordSet'::text, 'RecordPart'::text, 'File'::text])), ','::text) AS recordtype,
    raw.distribution_format,
    raw.geo_extent,
    raw.temporal_extent,
    raw.geometric_resolution,
    raw.crs,
    raw.creation,
    raw.released,
    raw.keywords,
    raw.data
   FROM raw
WITH DATA;

ALTER TABLE IF EXISTS public.rico_recordresources
    OWNER TO geonetwork;

-- View: public.rico_recordresources_mapping

-- DROP VIEW public.rico_recordresources_mapping;

CREATE OR REPLACE VIEW public.rico_recordresources_mapping
 AS
 SELECT rico_recordresources.uuid,
    rico_recordresources.title,
    rico_recordresources.recordtype,
    rico_recordresources.distribution_format,
    rico_recordresources.geo_extent,
    rico_recordresources.temporal_extent,
    rico_recordresources.geometric_resolution,
    rico_recordresources.crs,
    rico_recordresources.creation,
    rico_recordresources.released,
    rico_recordresources.keywords,
    rico_recordresources.data,
        CASE rico_recordresources.crs
            WHEN 'WGS84'::text THEN 'WGS84G'::text
            WHEN 'WGS 1984'::text THEN 'WGS84G'::text
            WHEN 'Lambert 93'::text THEN 'RGF93LAMB93'::text
            WHEN 'Verniquet'::text THEN 'VERNIQUET'::text
            WHEN NULL::text THEN ''::text
            ELSE NULL::text
        END AS crsuri,
    array_to_string(rico_recordresources.keywords, ';'::text) AS motsclefs,
    split_part(array_to_string(rico_recordresources.temporal_extent, ';'::text), ';'::text, 1) AS date1,
    split_part(array_to_string(rico_recordresources.temporal_extent, ';'::text), ';'::text, 2) AS date2,
    lower(rico_recordresources.recordtype) AS lrecordtype
   FROM rico_recordresources;

ALTER TABLE public.rico_recordresources_mapping
    OWNER TO geonetwork;

-- View: public.rico_recordresources_vertical_relations

-- DROP VIEW public.rico_recordresources_vertical_relations;

CREATE OR REPLACE VIEW public.rico_recordresources_vertical_relations
 AS
 SELECT rec.uuid AS res1,
    lower(rec.recordtype) AS lrecordtyperes1,
    rel.parent AS res2,
    lower(recp.recordtype) AS lrecordtyperes2,
        CASE rel.association
            WHEN 'isComposedOf'::text THEN 'includesOrIncluded'::text
            WHEN 'largerWorkCitation'::text THEN 'isOrWasIncludedIn'::text
            ELSE NULL::text
        END AS ppte
   FROM rico_recordresources rec
     JOIN rico_vertical_relations rel ON rec.uuid = rel.uuid::text
     JOIN rico_recordresources recp ON recp.uuid = rel.parent;

ALTER TABLE public.rico_recordresources_vertical_relations
    OWNER TO geonetwork;
