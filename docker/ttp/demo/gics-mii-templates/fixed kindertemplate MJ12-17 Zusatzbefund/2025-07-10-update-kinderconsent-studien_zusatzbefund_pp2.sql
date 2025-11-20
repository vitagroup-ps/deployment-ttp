/*
Ergänzungsskript zur Anpassung gICS Vorlage MII BroadConsent  Patienteneinwilligung MII (MJ 12-17) 1.1.a
Ziel: Modul MJ12-17_Rekontaktierung_weitere_Studien (Version 1.0), Policy Rekontaktierung_Zusatzbefund 1.0 ersetzen durch Rekontaktierung_weitere_Studien 1.1
ACHTUNG: Skript-Variablen sind nur anzupassen, sofern von der offiziell bereitgestellten Vorlage abgewichen wurde.
*/

-- >>> config
-- betreffende Datenbank
use gics;
-- betreffende Einwilligungsdomäne
SET @DOMAIN_NAME = 'MII';
-- betreffendes Modul
SET @MODULE_NAME = 'MJ12-17_Rekontaktierung_weitere_Studien';
set @MODULE_VERSION = 1000;
-- Betreffende Policy
SET @OLD_NAME="Rekontaktierung_Zusatzbefund";
SET @OLD_VERSION="1000";
-- neue Policy
set @NEW_POLICY_NAME = "Rekontaktierung_weitere_Studien";
set @NEW_POLICY_VERSION = 1001;
-- <<< config

-- >>> ab hier nichts anpassen
start transaction;
-- policy bereits per template import angelegt, jetzt neue Policy zu module zuordnen
INSERT INTO module_policy (P_NAME, P_DOMAIN_NAME, P_VERSION, M_NAME, M_DOMAIN_NAME, M_VERSION, FHIR_ID)
VALUES (@NEW_POLICY_NAME, @DOMAIN_NAME,  @NEW_POLICY_VERSION, @MODULE_NAME,  @DOMAIN_NAME, @MODULE_VERSION, UUID());
-- füge neue signed-policies der neuen policy mit dem status der alten policy hinzu (nur die die zu dem module gehören)
INSERT INTO signed_policy (STATUS, consent_date, CONSENT_VIRTUAL_PERSON_ID, CT_DOMAIN_NAME, CT_NAME, CT_VERSION, POLICY_DOMAIN_NAME, POLICY_NAME, POLICY_VERSION, FHIR_ID)
	select sp.STATUS, sp.consent_date, sp.CONSENT_VIRTUAL_PERSON_ID, sp.CT_DOMAIN_NAME, sp.CT_NAME, sp.CT_VERSION, sp.POLICY_DOMAIN_NAME, @NEW_POLICY_NAME, @NEW_POLICY_VERSION, UUID()
		from	signed_policy sp
		where sp.CT_DOMAIN_NAME = @DOMAIN_NAME
			and sp.POLICY_NAME = @OLD_NAME
			and sp.POLICY_VERSION = @OLD_VERSION
			and concat(sp.ct_name, '#+#+#', sp.ct_version) in
				(select concat(ct_name, '#+#+#', ct_version) from module_consent_template
					where m_name = @MODULE_NAME
					and m_domain = @DOMAIN_NAME
					and m_version = @MODULE_VERSION);

-- entfernen der policy aus dem module
DELETE FROM module_policy WHERE P_DOMAIN_NAME=@DOMAIN_NAME AND P_NAME=@OLD_NAME AND P_VERSION=@OLD_VERSION AND M_NAME=@MODULE_NAME and M_VERSION=@MODULE_VERSION;
-- entfernen aller signed-policies, die zum module und der policy passen
DELETE from	signed_policy sp
		where sp.CT_DOMAIN_NAME = @DOMAIN_NAME
			and sp.POLICY_NAME = @OLD_NAME
			and sp.POLICY_VERSION = @OLD_VERSION
			and concat(sp.ct_name, '#+#+#', sp.ct_version) in
				(select concat(ct_name, '#+#+#', ct_version) from module_consent_template
					where m_name = @MODULE_NAME
					and m_domain = @DOMAIN_NAME
					and m_version = @MODULE_VERSION);
-- entfernen der alten Policy wenn nicht in einem anderen modul verwendet
DELETE FROM policy WHERE DOMAIN_NAME=@DOMAIN_NAME AND NAME=@OLD_NAME AND VERSION=@OLD_VERSION 
	and concat(@DOMAIN_NAME, '#+#+#', @OLD_NAME, '#+#+#', @OLD_VERSION) not in (
		select concat(mp.P_DOMAIN_NAME, '#+#+#', mp.P_NAME, '#+#+#', mp.P_VERSION) from module_policy mp
		);

commit;