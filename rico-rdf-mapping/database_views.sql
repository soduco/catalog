----------------------------------------------------------
-- TABLE DES INSTANCIATIONS
---------------------------------------------------------
CREATE OR REPLACE VIEW rico_instanciations AS 
SELECT * FROM (
    SELECT
    -- Instanciation type 
    instanciation_type,
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
    FROM
    (
        SELECT uuid, UNNEST(xpath('//mrd:MD_Distribution/mrd:description/gco:CharacterString/text()',
                           data::xml,
                          ARRAY[
                              ARRAY['mrd', 'http://standards.iso.org/iso/19115/-3/mrd/1.0'],
                              ARRAY['gco', 'http://standards.iso.org/iso/19115/-3/gco/1.0']
                         ])::text[]) AS instanciation_type,
                         data
        FROM public.metadata
        UNION 
        SELECT uuid,
               'mapHardcopy',
               data
        FROM public.metadata
        WHERE (xpath('//cit:presentationForm/cit:CI_PresentationFormCode/@codeListValue',
                   data::xml,
                   ARRAY[
                      ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0']
                 ]))[1]::text = 'mapHardcopy'
    ) AS instanciations
) AS parsed
WHERE uuid IS NOT NULL;


----------------------------------------------------------
-- TABLE DES RECORDSETS
---------------------------------------------------------
CREATE OR REPLACE VIEW rico_recordsets AS 
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
    WHERE 
    -- NOT AN INSTANCE
    (xpath('//cit:presentationForm/cit:CI_PresentationFormCode/@codeListValue',
         data::xml,
          ARRAY[
              ARRAY['cit', 'http://standards.iso.org/iso/19115/-3/cit/2.0']
         ]))[1]::text IS NULL
) AS parsed
WHERE uuid IS NOT NULL;


----------------------------------------------------
-- TABLE DES CONTACTS
----------------------------------------------------

CREATE OR REPLACE VIEW rico_contacts AS 
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


----------------------------------------------------
-- TABLE DES RELATIONS VERTICALES
----------------------------------------------------

CREATE OR REPLACE VIEW rico_vertical_relations AS 
SELECT * FROM (
    SELECT
    uuid,
    UNNEST(xpath('//mri:MD_AssociatedResource/mri:associationType/mri:DS_AssociationTypeCode/@codeListValue',
         data::xml,
          ARRAY[
              ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
         ])::text[]) AS associations_types,
    -- id de la relation
    UNNEST(xpath('//mri:MD_AssociatedResource/mri:metadataReference/@uuidref',
         data::xml,
          ARRAY[
              ARRAY['mri', 'http://standards.iso.org/iso/19115/-3/mri/1.0']
         ])::text[]) AS associations_ids,
    data
    FROM public.metadata
) AS parsed
WHERE uuid IS NOT NULL;



----------------------------------------------------
-- TABLE DES RELATIONS HORIZONTALES (instanciations)
----------------------------------------------------

CREATE OR REPLACE VIEW rico_horizontal_relations AS 
SELECT * FROM (
    SELECT
    uuid,
    UNNEST(xpath('//mdb:resourceLineage/*/mrl:source/@uuidref',
         data::xml,
          ARRAY[
              ARRAY['mrl', 'http://standards.iso.org/iso/19115/-3/mrl/2.0'],
              ARRAY['mdb', 'http://standards.iso.org/iso/19115/-3/mdb/2.0']
         ])::text[]) AS source,
    data
    FROM public.metadata
) AS parsed
WHERE uuid IS NOT NULL;

