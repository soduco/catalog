-- View: public.rico_horizontal_relations

DROP MATERIALIZED VIEW IF EXISTS public.rico_horizontal_relations;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_horizontal_relations
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
 	unnest(xpath('//mri:MD_Keywords[mri:type/mri:MD_KeywordTypeCode[@codeListValue="taxon"]]/mri:keyword/gco:CharacterString/text()'::text, metadata_1.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS resource_type,
    parsed.parent,
    unnest(xpath('//mri:MD_Keywords[mri:type/mri:MD_KeywordTypeCode[@codeListValue="taxon"]]/mri:keyword/gco:CharacterString/text()'::text, metadata_2.data::xml, ARRAY[ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text]])::text[]) AS parent_type,
    parsed.data
   FROM ( SELECT metadata.uuid,
            unnest(xpath('//mdb:resourceLineage//mrl:source/@uuidref'::text, metadata.data::xml, ARRAY[ARRAY['mrl'::text, 'http://standards.iso.org/iso/19115/-3/mrl/2.0'::text], ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text]])::text[]) AS parent,
            metadata.data
           FROM metadata) parsed,
		   metadata AS metadata_1,
		   metadata AS metadata_2
  WHERE parsed.uuid IS NOT NULL AND metadata_1.uuid = parsed.uuid AND metadata_2.uuid = parsed.parent
WITH DATA;

ALTER TABLE IF EXISTS public.rico_horizontal_relations
    OWNER TO geonetwork;

