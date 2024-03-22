---------------------------------------------------------
-- TABLE DES INSTANCIATIONS
---------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS rico_instanciations CASCADE;

CREATE MATERIALIZED VIEW rico_instanciations AS 
SELECT * FROM (
   SELECT
   -- Instantiation type
    (xpath('//cit:presentationForm/cit:CI_PresentationFormCode/@codeListValue',
               data::xml,
               ARRAY[
                  ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0']
             ]))[1]::text AS instanciation_type,
   -- a rico:RecordSet
   (xpath('//mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
             ARRAY['mcc', 'http://standards.iso.org/iso/19115/-3/mcc/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
        ]))[1]::text AS uuid,
   -- rico:title
   (xpath('//mri:citation/cit:CI_Citation/cit:title/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ]))[1]::text AS title,
   -- rico:recordSetTypes
   -- ??
   -- dc:format
   (xpath('//mrd:distributionFormat/mrd:MD_Format/mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mrd', 'http://standards.iso.org/iso/19115/-3/mrd/1.0']
        ]))[1]::text AS distribution_format,
   -- xyz:extent
   (
       SELECT ST_ASTEXT(ST_MakeEnvelope(coords[1],coords[3],coords[2],coords[4]))
       FROM 
           ( SELECT xpath('//gex:EX_GeographicBoundingBox//gco:Decimal/text()',
               data::xml,
                ARRAY[
                     ARRAY['gex', 'http://standards.iso.org/iso/19115/-3/gex/1.0'],
                     ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
                ])::text[]::float[] as coords 
       ) AS extent_coords
   ) as geo_extent,
   -- Temporal Extent
   xpath('//gex:EX_TemporalExtent//gex:extent/gml:TimePeriod/*/text()',
        data::xml,
         ARRAY[
             ARRAY['gex', 'http://standards.iso.org/iso/19115/-3/gex/1.0'],
             ARRAY['gml', 'http://www.opengis.net/gml/3.2']
        ])::text[] AS temporal_extent,
   -- xys:geometricResolution
   (xpath('//mri:spatialResolution/mri:MD_Resolution/mri:equivalentScale/mri:MD_RepresentativeFraction/mri:denominator/gco:Integer/text()',
        data::xml,
         ARRAY[
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
        ]))[1]::text AS geometric_resolution,
   -- Coordinate system
   (xpath('//mrs:MD_ReferenceSystem/mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['mrs', 'http://standards.iso.org/iso/19115/-3/mrs/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mcc', 'http://standards.iso.org/iso/19115/-3/mcc/1.0']
        ]))[1]::text AS crs,
   -- rico:creationDate
   (ARRAY(
       SELECT TO_DATE(
           UNNEST(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''creation'']/gco:Date/text()',
                        data::xml,
                        ARRAY[
                            ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
                            ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                            ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                        ])::text[]),
           'YYYY-MM-DD')
   ))[1] AS creation,
   -- releaseDate ?
   (ARRAY(
       SELECT TO_DATE(
           UNNEST(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''released'']/gco:Date/text()',
                        data::xml,
                        ARRAY[
                            ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
                            ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                            ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                        ])::text[]),
           'YYYY-MM-DD')
   ))[1] AS released,
   -- #Ajouter un concept “histoire de la cartographie”
   -- rico:hasOrHadMainSubject
   xpath('//mri:keyword/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[] AS keywords,
   data
   FROM public.metadata
   WHERE  'instantiation' ILIKE ANY(
                                   xpath('//mri:keyword/gco:CharacterString/text()',
                                   data::xml,
                                   ARRAY[
                                      ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                                      ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                                   ])::text[])
) AS parsed
WHERE uuid IS NOT NULL;

CREATE INDEX rico_instanciations_idx ON rico_instanciations (uuid);

---------------------------------------------------------
-- TABLE DES RECORDSETS
---------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS rico_recordsets CASCADE;

CREATE MATERIALIZED VIEW rico_recordsets AS 
SELECT * FROM (
   SELECT
   -- a rico:RecordSet
   (xpath('//mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0'],
             ARRAY['mcc', 'http://standards.iso.org/iso/19115/-3/mcc/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
        ]))[1]::text AS uuid,
   -- rico:title
   (xpath('//mri:citation/cit:CI_Citation/cit:title/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ]))[1]::text AS title,
   -- rico:recordSetTypes
   -- ??
   -- dc:format
   (xpath('//mrd:distributionFormat/mrd:MD_Format/mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mrd', 'http://standards.iso.org/iso/19115/-3/mrd/1.0']
        ]))[1]::text AS distribution_format,
   -- xyz:extent
   (
       SELECT ST_ASTEXT(ST_MakeEnvelope(coords[1],coords[3],coords[2],coords[4]))
       FROM 
           ( SELECT xpath('//gex:EX_GeographicBoundingBox//gco:Decimal/text()',
               data::xml,
                ARRAY[
                     ARRAY['gex', 'http://standards.iso.org/iso/19115/-3/gex/1.0'],
                     ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
                ])::text[]::float[] as coords 
       ) AS extent_coords
   ) as geo_extent,
   -- Temporal Extent
   xpath('//gex:EX_TemporalExtent//gex:extent/gml:TimePeriod/*/text()',
        data::xml,
         ARRAY[
             ARRAY['gex', 'http://standards.iso.org/iso/19115/-3/gex/1.0'],
             ARRAY['gml', 'http://www.opengis.net/gml/3.2']
        ])::text[] AS temporal_extent,
   -- xys:geometricResolution
   (xpath('//mri:spatialResolution/mri:MD_Resolution/mri:equivalentScale/mri:MD_RepresentativeFraction/mri:denominator/gco:Integer/text()',
        data::xml,
         ARRAY[
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
        ]))[1]::text AS geometric_resolution,
   -- Coordinate system
   (xpath('//mrs:MD_ReferenceSystem/mrs:referenceSystemIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['mrs', 'http://standards.iso.org/iso/19115/-3/mrs/1.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mcc', 'http://standards.iso.org/iso/19115/-3/mcc/1.0']
        ]))[1]::text AS crs,
   -- rico:creationDate
   (ARRAY(
       SELECT TO_DATE(
           UNNEST(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''creation'']/gco:Date/text()',
                        data::xml,
                        ARRAY[
                            ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
                            ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                            ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                        ])::text[]),
           'YYYY-MM-DD')
   ))[1] AS creation,
   -- releaseDate ?
   (ARRAY(
       SELECT TO_DATE(
           UNNEST(xpath('//cit:date[../cit:dateType/cit:CI_DateTypeCode/@codeListValue = ''released'']/gco:Date/text()',
                        data::xml,
                        ARRAY[
                            ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
                            ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                            ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                        ])::text[]),
           'YYYY-MM-DD')
   ))[1] AS released,
   -- rico:hasOrHadMainSubject
   xpath('//mri:keyword/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[] AS keywords,
   data
   FROM public.metadata 
   WHERE  'recordset' ILIKE ANY(xpath('//mri:keyword/gco:CharacterString/text()',
                                   data::xml,
                                   ARRAY[
                                      ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
                                      ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
                                ])::text[])

-- NOT AN INSTANCE
--  WHERE (xpath('//cit:presentationForm/cit:CI_PresentationFormCode/@codeListValue',
--         data::xml,
--          ARRAY[
--              ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0']
--         ]))[1]::text IS NULL
) AS parsed
WHERE uuid IS NOT NULL;

CREATE INDEX rico_recordsets_idx ON rico_recordsets (uuid);

----------------------------------------------------
-- TABLE DES CONTACTS
----------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS rico_contacts CASCADE;

CREATE MATERIALIZED VIEW rico_contacts AS 
SELECT * FROM (
   SELECT
   uuid,
   -- Contacts:Roles
   UNNEST(xpath('//mri:pointOfContact/cit:CI_Responsibility/cit:role/cit:CI_RoleCode/@codeListValue',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[]) AS contacts_roles,
   -- Contacts:Names
   UNNEST(xpath('( //mri:pointOfContact/cit:CI_Responsibility/cit:party/cit:CI_Organisation | //mri:pointOfContact/cit:CI_Responsibility/cit:party//cit:CI_Individual)/cit:name/gco:CharacterString/text()',
        data::xml,
        ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[]) AS contacts_names,   
   -- Contacts:URIs
   UNNEST(xpath('//mri:pointOfContact/cit:CI_Responsibility/cit:party/cit:CI_Organisation//cit:CI_OnlineResource/cit:linkage/gco:CharacterString/text()',
        data::xml,
         ARRAY[
             ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0'],
             ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0'],
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[]) AS contacts_uris,
   data
   FROM public.metadata
) AS parsed
WHERE uuid IS NOT NULL;

CREATE INDEX rico_contacts_idx ON rico_contacts (uuid);

----------------------------------------------------
-- TABLE DES RELATIONS VERTICALES
----------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS rico_vertical_relations CASCADE;

CREATE MATERIALIZED VIEW rico_vertical_relations AS 
SELECT * FROM (
   SELECT
   uuid,
   UNNEST(xpath('//mri:MD_AssociatedResource/mri:associationType/mri:DS_AssociationTypeCode/@codeListValue',
        data::xml,
         ARRAY[
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[]) AS association,
   -- id de la relation
   UNNEST(xpath('//mri:MD_AssociatedResource/mri:metadataReference/@uuidref',
        data::xml,
         ARRAY[
             ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
        ])::text[]) AS parent,
   data
   FROM public.metadata
) AS parsed
WHERE uuid IS NOT NULL;

CREATE INDEX rico_vertical_relations_uuid_idx ON rico_vertical_relations (uuid);
CREATE INDEX rico_vertical_relations_parent_idx ON rico_vertical_relations (parent);

----------------------------------------------------
-- TABLE DES RELATIONS HORIZONTALES (instanciations)
----------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS rico_horizontal_relations CASCADE;

CREATE MATERIALIZED VIEW rico_horizontal_relations AS 
SELECT * FROM (
   SELECT
   uuid,
   UNNEST(xpath('//mdb:resourceLineage/*/mrl:source/@uuidref',
        data::xml,
         ARRAY[
             ARRAY['mrl', 'http://standards.iso.org/iso/19115/-3/mrl/2.0'],
             ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0']
        ])::text[]) AS parent,
   data
   FROM public.metadata
) AS parsed
WHERE uuid IS NOT NULL;

CREATE INDEX rico_horizontal_relations_uuid_idx ON rico_horizontal_relations (uuid);
CREATE INDEX rico_horizontal_relations_parent_idx ON rico_horizontal_relations (parent);



--
-- Name: rico_instanciations_mapping; Type: VIEW; Schema: public; Owner: geonetwork
--

CREATE VIEW public.rico_instanciations_mapping AS
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
   FROM public.rico_instanciations;


ALTER TABLE public.rico_instanciations_mapping OWNER TO geonetwork;

--
-- Name: rico_recordsets_mapping; Type: VIEW; Schema: public; Owner: geonetwork
--

CREATE VIEW public.rico_recordsets_mapping AS
 SELECT rico_recordsets.uuid,
    rico_recordsets.title,
    rico_recordsets.distribution_format,
    rico_recordsets.geo_extent,
    rico_recordsets.temporal_extent,
    rico_recordsets.geometric_resolution,
    rico_recordsets.crs,
    rico_recordsets.creation,
    rico_recordsets.released,
    rico_recordsets.keywords,
    rico_recordsets.data,
        CASE rico_recordsets.crs
            WHEN 'WGS84'::text THEN 'WGS84G'::text
            WHEN 'WGS 1984'::text THEN 'WGS84G'::text
            WHEN 'Lambert 93'::text THEN 'RGF93LAMB93'::text
            WHEN 'Verniquet'::text THEN 'VERNIQUET'::text
            WHEN NULL::text THEN ''::text
            ELSE NULL::text
        END AS crsuri,
    array_to_string(rico_recordsets.keywords, ';'::text) AS motsclefs,
    split_part(array_to_string(rico_recordsets.temporal_extent, ';'::text), ';'::text, 1) AS date1,
    split_part(array_to_string(rico_recordsets.temporal_extent, ';'::text), ';'::text, 2) AS date2
   FROM public.rico_recordsets;


ALTER TABLE public.rico_recordsets_mapping OWNER TO geonetwork;

--
-- Name: rico_recordsets_vertical_relations; Type: VIEW; Schema: public; Owner: geonetwork
--

CREATE VIEW public.rico_recordsets_vertical_relations AS
 SELECT rec.uuid AS res1,
    rel.parent AS res2,
        CASE rel.association
            WHEN 'isComposedOf'::text THEN 'includesOrIncluded'::text
            WHEN 'largerWorkCitation'::text THEN 'isOrWasIncludedIn'::text
            ELSE NULL::text
        END AS ppte
   FROM (public.rico_recordsets rec
     JOIN public.rico_vertical_relations rel ON ((rec.uuid = (rel.uuid)::text)));


ALTER TABLE public.rico_recordsets_vertical_relations OWNER TO geonetwork;

--
-- Name: rico_instanciations_vertical_relations; Type: VIEW; Schema: public; Owner: geonetwork
--

CREATE VIEW public.rico_instanciations_vertical_relations AS
 SELECT rec.uuid AS res1,
    rel.parent AS res2,
        CASE rel.association
            WHEN 'isComposedOf'::text THEN 'hasOrHadComponent'::text
            WHEN 'largerWorkCitation'::text THEN 'isOrWasComponentOf'::text
            ELSE NULL::text
        END AS ppte
   FROM (public.rico_instanciations rec
     JOIN public.rico_vertical_relations rel ON ((rec.uuid = (rel.uuid)::text)));


ALTER TABLE public.rico_instanciations_vertical_relations OWNER TO geonetwork;
