-- View: public.rico_instanciations

-- DROP MATERIALIZED VIEW IF EXISTS public.rico_instanciations;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_instanciations
TABLESPACE pg_default
AS
 SELECT parsed.instanciation_type,
    parsed.uuid,
    parsed.title,
    parsed.distribution_format,
    parsed.geo_extent,
    parsed.temporal_extent,
    parsed.geometric_resolution,
    parsed.crs,
    parsed.creation,
    parsed.released,
    parsed.keywords,
    parsed.data
   FROM ( SELECT (xpath('//cit:presentationForm/cit:CI_PresentationFormCode/@codeListValue'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text]]))[1]::text AS instanciation_type,
            (xpath('//mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text], ARRAY['mcc'::text, 'http://standards.iso.org/iso/19115/-3/mcc/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]]))[1]::text AS uuid,
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
          WHERE 'instantiation'::text ~~* ANY (xpath('//mri:keyword/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[])) parsed
  WHERE parsed.uuid IS NOT NULL
WITH DATA;

ALTER TABLE IF EXISTS public.rico_instanciations
    OWNER TO geonetwork;


CREATE INDEX rico_instanciations_idx
    ON public.rico_instanciations USING btree
    (uuid COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- View: public.rico_instanciations_mapping

-- DROP VIEW public.rico_instanciations_mapping;

CREATE OR REPLACE VIEW public.rico_instanciations_mapping
 AS
 SELECT rico_instanciations.instanciation_type,
    rico_instanciations.uuid,
    rico_instanciations.title,
    rico_instanciations.distribution_format,
    rico_instanciations.geo_extent,
    rico_instanciations.temporal_extent,
    rico_instanciations.geometric_resolution,
    rico_instanciations.crs,
    rico_instanciations.creation,
    rico_instanciations.released,
    rico_instanciations.keywords,
    rico_instanciations.data,
        CASE rico_instanciations.instanciation_type
            WHEN 'mapDigital'::text THEN '<ark:/67717/c25e8a3b-c22c-4f00-bb06-b13f8eccb732>'::text
            WHEN 'mapHardcopy'::text THEN 'carrierType/FRAN_RI_002-d3nd9yh03b--1lx80czdt83ae>'::text
            ELSE NULL::text
        END AS carrier,
        CASE rico_instanciations.crs
            WHEN 'WGS84'::text THEN 'WGS84G'::text
            WHEN 'WGS 1984'::text THEN 'WGS84G'::text
            WHEN 'Lambert 93'::text THEN 'RGF93LAMB93'::text
            WHEN 'Verniquet'::text THEN 'VERNIQUET'::text
            WHEN NULL::text THEN ''::text
            ELSE NULL::text
        END AS crsuri,
    array_to_string(rico_instanciations.keywords, ';'::text) AS motsclefs
   FROM rico_instanciations;

ALTER TABLE public.rico_instanciations_mapping
    OWNER TO geonetwork;

-- View: public.rico_instanciations_vertical_relations

-- DROP VIEW public.rico_instanciations_vertical_relations;

CREATE OR REPLACE VIEW public.rico_instanciations_vertical_relations
 AS
 SELECT rec.uuid AS res1,
    rel.parent AS res2,
        CASE rel.association
            WHEN 'isComposedOf'::text THEN 'hasOrHadComponent'::text
            WHEN 'largerWorkCitation'::text THEN 'isOrWasComponentOf'::text
            ELSE NULL::text
        END AS ppte
   FROM rico_instanciations rec
     JOIN rico_vertical_relations rel ON rec.uuid = rel.uuid::text;

ALTER TABLE public.rico_instanciations_vertical_relations
    OWNER TO geonetwork;
