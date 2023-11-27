-- View: public.rico_contacts

-- DROP MATERIALIZED VIEW IF EXISTS public.rico_contacts;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.rico_contacts
TABLESPACE pg_default
AS
 SELECT parsed.uuid,
    parsed.document_type,
    parsed.contacts_roles,
    parsed.contacts_names,
    parsed.contacts_uris,
    parsed.data
   FROM ( SELECT metadata.uuid,
            unnest(xpath('//mdb:identificationInfo//cit:CI_RoleCode/@codeListValue'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mdb'::text, 'http://standards.iso.org/iso/19115/-3/mdb/2.0'::text]])::text[]) AS contacts_roles,
            unnest(xpath('//mri:pointOfContact//cit:name/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) AS contacts_names,
            unnest(xpath('//mri:pointOfContact/cit:CI_Responsibility/cit:party/cit:CI_Organisation//cit:CI_OnlineResource/cit:linkage/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['cit'::text, 'http://standards.iso.org/iso/19115/-3/cit/2.0'::text], ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) AS contacts_uris,
            unnest(xpath('//mri:descriptiveKeywords//mri:keyword/gco:CharacterString/text()'::text, metadata.data::xml, ARRAY[ARRAY['gco'::text, 'http://standards.iso.org/iso/19115/-3/gco/1.0'::text], ARRAY['mri'::text, 'http://standards.iso.org/iso/19115/-3/mri/1.0'::text]])::text[]) AS document_type,
            metadata.data
           FROM metadata) parsed
  WHERE parsed.uuid IS NOT NULL AND parsed.document_type ~~ '%Record%'::text OR parsed.document_type ~~ '%Instantiation%'::text
WITH DATA;

ALTER TABLE IF EXISTS public.rico_contacts
    OWNER TO geonetwork;
