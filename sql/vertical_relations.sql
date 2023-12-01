-- View: public.rico_vertical_relations

-- DROP MATERIALIZED VIEW IF EXISTS public.rico_vertical_relations;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_vertical_relations
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.association,
    parsed.parent,
    unnest(xpath('//mri:MD_Keywords[mri:type/mri:MD_KeywordTypeCode[@codeListValue="taxon"]]/mri:keyword/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS parent_type,
    parsed.data
   FROM ( SELECT metadata_1.uuid,
            unnest(xpath('//mri:MD_AssociatedResource/mri:associationType/mri:DS_AssociationTypeCode/@codeListValue'::text, metadata_1.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) AS association,
            unnest(xpath('//mri:MD_AssociatedResource/mri:metadataReference/@uuidref'::text, metadata_1.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) AS parent,
            metadata_1.data
           FROM metadata metadata_1) parsed,
    metadata
  WHERE parsed.uuid IS NOT NULL AND parsed.parent = metadata.uuid::text
WITH DATA;

ALTER TABLE IF EXISTS public.rico_vertical_relations
    OWNER TO geonetwork;


CREATE INDEX rico_vertical_relations_parent_idx
    ON public.rico_vertical_relations USING btree
    (parent COLLATE pg_catalog."default")
    TABLESPACE pg_default;
CREATE INDEX rico_vertical_relations_uuid_idx
    ON public.rico_vertical_relations USING btree
    (uuid COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- View: public.rico_instanciations_vertical_relations

-- DROP VIEW public.rico_instanciations_vertical_relations;

CREATE OR REPLACE VIEW public.rico_instanciations_vertical_relations
 AS
 SELECT rec.uuid AS res1,
    rel.parent AS parent,
	rel.parent_type AS parent_type,
        CASE rel.association
            WHEN 'isComposedOf'::text THEN 'hasOrHadComponent'::text
            WHEN 'largerWorkCitation'::text THEN 'isOrWasComponentOf'::text
            ELSE NULL::text
        END AS ppte
   FROM rico_instanciations rec
     JOIN rico_vertical_relations rel ON rec.uuid = rel.uuid::text;

ALTER TABLE public.rico_instanciations_vertical_relations
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
