![context](https://www.ths-greifswald.de/wp-content/uploads/2019/01/Design-Logo-THS-deutsch-271.png)
# TTP FHIR Gateway
Current Docker-Version of TTP-FHIR Gateway: 2025.1.1 (Sept. 2025)
# TTP-FHIR Gateway 2025.1.1

## Improvements
* Unterstützung Domainbasierte Rollen in Keycloak in FHIR Gateway für gICS und E-PIX
* Dependency Updates (u.a. FHIR HAPI 8.4.0)
* 
## Bugfixes
* [MII KDS Consent] Consent.policyUri verweist auf 184 statt auf Dokument-spezifische OID (z.b. 1790)
* [MII KDS Consent] Suchparameter mii-policy-uri erlaubt unzulässige Angaben
* [MII KDS Consent] Fehlende Angabe von Level2-Provision.period.end im Fall von Widerruf und Ablehnung führt zu internen Validierungsfehlern bei Verwendung Suchparameter category 184
 
# TTP-FHIR Gateway 2025.1.0

## New Feature
* gPAS-Funktionalität: Umsetzung **pseudonymize-secondary** für Sekundärpseudonymisierung in MII & NUM

## Improvements
* Aktualisierung [MII KDS Modul Consent v2025.0.4](https://www.medizininformatik-initiative.de/Kerndatensatz/KDS_Consent_V2025/MII-IG-Modul-Consent.html) (für SNID und DZPG)
* Neue ENV-Variable **TTP_FHIR_GICS_CONSENT_SEARCH_DEFAULT_RESULT_TYPE** zur Konfiguration des Default-Resulttype für FHIR Consent Search
* Dependency Update HAPI FHIR 8.2.0 und [HL7-D AG Einwilligungsmanagement 2.0 STU](https://ig.fhir.de/einwilligungsmanagement/2.0.0/Home.html)
* Verwendung unbekannter SignerIds bei Consent-Suchparameter patient.identifier führt zu OperationOutcome im ResultBundle anstelle von 'leeren' Consent-Ressourcen (ohne Level2-Provisions)
* Konsistenz-Verbesserung bei Consent-Operations in Bezug auf Generierung Bunde.Totals und Bundle.Entry.FullUrls
* Erweiterung MixedMode for ConsentResearchStudy bei Kombination von Opt-In und Opt-Out im gICS
 
# Bugfixes
* Re-Aktivierung SnapshotGeneratingValidationSupport für Ressourcen-Validierung nach Bugfix in HAPI 8.2.0
* MII KDS Consent Unexpanded Valuesets führen zu Validation.Warning "incorrect display"

# TTP-FHIR Gateway 2024.3.2

## Bugfixes
* FHIR SEARCH nach Consent mit ResultType "consent-status" liefert Level1-Provision mit Period.Start und Period.End am selben Tag

# TTP-FHIR Gateway 2024.3.1

## Bugfixes
* ExternalProperty *forceProfileConsent* in gICS Domain-Config funktioniert nicht FHIR Consent Search mit *ResultType|consent-status*

# TTP-FHIR Gateway 2024.3.0

## New Feature
* Unterstützung gPAS Operation insertValuePseudonymPairs
* Unterstützung gICS Operation addConsentOptOut
* Umsetzung FHIR Consent Export gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)
* Umsetzung der neuen Suchparameter domain, category, patient.identifier gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)
* Umsetzung Consent-Suche per _revinclude=Provenance:target zur Ausleitung von Herkunfsinformationen (Provenance)
* Erweiterung Consent-Suche unter Angabe ConsentManagementTemplateType und ResultType (document, consent-status und policy) gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)

## Improvements
* Anpassung Default-Consent-Profile : HL7 FHIR Consent der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)
* Neues externalProperty zur Definition *fhirForceProfileConsent=value* zur Ausleitung aller Consent-Ressourcen über Suchparameter und Operations in *Wunsch-Profil* (e.g. MII) zu erzwingen
* Aktualisierung Abhängigkeit und Conformance (inkl Validierung) zu MII KDS Modul Consent [de.medizininformatikinitiative.kerndatensatz.consent 2025.0.0](https://simplifier.net/packages/de.medizininformatikinitiative.kerndatensatz.consent/2025.0.0) (Opt-In/Opt-Out, Multi-Category, Updated MII Policies)
* Erweiterung ResearchStudy-Resource um Extension zur Unterscheidung von *Opt-In/Opt-Out* Domains gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)
* Anpassung FHIR QuestionnaireResponse Export gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)
* Anpassung FHIR Provenance Export gemäß 2024er HL7 FHIR Consent Standard der HL7D AG [Einwilligungsmanagement](https://simplifier.net/guide/Einwilligungsmanagement/IGEinwilligungsmanagement?version=current)

# TTP-FHIR Gateway 2024.2.3

## Improvements
* Aktualisierung Dependencies: FHIR HAPI 7.6.0

#  TTP-FHIR Gateway 2024.2.2

## Improvements
* Aktualisierung Dependencies: FHIR HAPI 7.4.3

#  TTP-FHIR Gateway 2024.2.1

## Improvements
* Aktualisierung Dependencies: FHIR HAPI 7.4.0
* Erweiterung gPAS-FHIR-Funktionen für Multi-Psn-Domain Kompatibilität

#  TTP-FHIR Gateway 2024.2.0

## New Feature
* [deletePseudonyms](https://simplifier.net/guide/ttp-fhir-gateway-ig/markdown-Pseudonymmanagement-Operations-deletePseudonyms?version=current) (for singlePsn-Domains)
* [anonymizeOriginals](https://simplifier.net/guide/ttp-fhir-gateway-ig/markdown-Pseudonymmanagement-Operations-anonymizeOriginals?version=current) (for singlePsn-Domains)

## Improvements
*  Dokumentation aller FHIR-bezogenen ExternalProperties für gICS in README

## Bugfix
*  MII Consent Suche: **Paging**-Parameter **_offset** und **_count** resultiert in unerwarteter Ressourcen-Anzahl im Consent-Bundle

#  TTP-FHIR Gateway 2024.1.0

## Improvements
*  Umstellung von JavaEE auf JakartaEE
*  Anpassung LogLevel für ausgewählte Meldungen
*  Berücksichtigung Patient.telecom E-MAIL bei Import und Export
*  Telecom Mail/phone in Hauptidentität (Person-Ressource) ausleiten

## Docker
*  Geänderte Logging-Variable: TTP_FHIR_LOG_TO_FILE zu TTP_FHIR_LOG_TO

#  TTP-FHIR Gateway 2023.1.3

## Verbesserung

- Dependency Updates: junit-jupiter 5.10.1, jboss-vfs 3.3.0.Final, maven-war-plugin 3.4.0, wildfly-maven-
plugin 3.9.6, maven-deploy-plugin 3.1.1, gICS 2023.1.4, E-PIX 2023.1.3, Noti-Service 2023.1.2

## Bugfix

-  Korrektur System-Angabe Im Fall von de.medizininformatikinitiative.kerndatensatz.consent v1.0.6 bei Consent-Resource (Consent.provision.provision.coding.code.system)

#  TTP-FHIR Gateway 2023.1.2

## Verbesserung

- Deklaration globaler Module durch Nutzung expliziter Modul-Abhängigkeiten ersetzen im FHIR-GW
- Verwendung von Pipes statt %7C in GET-Requests mit WF_DISABLE_HTTP2=TRUE ermöglichen (z.B. für Consent-Suche)
- Korrektur "Ort der Unterschrift" einer Einwilligung bei Import und Export verschieben von "Provenance.signature.onbehalfof" nach "Provenance.signature.SignatureLocationExtension.valueString"
- HL7 AG Einwilligungsmanagement: Anpassung Provenance Import/Export Unterschrift "aufklärende Person" und "Gesetzlicher Vertreter"
- Verbesserte Fehlermeldung bei Aufruf von $pseudonymizeAllowCreate mit leerem Original-Value

## Bugfix

- E-PIX Search for Person-Resources: Bundle.Total soll Ergebnis der Personensuche unabhängig von PageSize der Such-Anfrage entsprechen
- Parallele Requests mit verschiedenen Rollen können zu falschem Admin-Status führen
- Suche mit PolicyUri liefert mehr Ergebnisse als erwartet
- NPE bei Aufruf von addPatient-Request
- Fehlerhafter Verweis auf Import-Domain in Systemangabe des lokalen Identifiers beim Anlegen von Patienten
- Konvertierung Nationality bei Export Patient-Resource führt zu Fehlen von Patient-Ressourcen im Export-Bundle trotz Verwendung _include=Person:link

#  TTP-FHIR Gateway 2023.1.1

## Verbesserung

- Aktualisierung MII KDS Consent-PolicyValueSet in TerminologyManager und Korrektur Verwendung Display-Values
- Korrektur Struktur Code/Coding innerhalb von Consent.provision.provision
- Umsetzung Paging für getAllPersonsForDomain, getAllConsentsForTemplate, getAllPersonsForDomain (PDQ)
- Umsetzung Paging für MII KDS Consent Search [inklusive Parameter _count, _offset gemäß Default-Vorgaben im THS-IG](https://simplifier.net/guide/ttp-fhir-gateway-ig/markdown-Einwilligungsmanagement-ProfileUndExtensions-Consent?version=current)      
- Aktualisierung Dependency auf FHIR HAPI v6.6.2
 
## Bugfix

- Korrektur Berücksichtigung Template externalProperty "fhirPolicyUri" zur Angabe "TemplateVersion gemäß MII KDS Consent" in Consent.policy.uri
- Korrektur Consent.Provision-Struktur nach MII KDS Consent-Profil

#  TTP-FHIR Gateway 2023.1.0

## New Feature

- [Unterstützung MII KDS Consent v1.0.3 Consent Profile und SearchParams und CompositeSearchParams der MII Taskforce Consent-Umsetzung (Mai 2023)](https://www.medizininformatik-initiative.de/Kerndatensatz/Modul_Consent/IGMIIKDSModulConsent-TechnischeImplementierung-FHIRProfile-Consent.html)
- Unterstützung MII KDS Consent v1.0.2 Consent Profile und SearchParams der MII Taskforce Consent-Umsetzung (Jan. 2023)
- Umsetzung Operation addConsent zur Anlage von Einwilligungen per FHIR (gICS)
- Umsetzung Operation updateBf zur Aktualisierung von Bloomfiltern (fTTP)

## Verbesserung

- Package-basierte Validierung eingehender Ressourcen (E-PIX, gICS)
- Erweiterung CapabilityStatement um Versionsnummer TTP-FHIR Gateway und Publisher-Information
- Ergänzung Extension "created" bei Consent-related Ressourcen
- Ergänzung "fullUrls" bei Consent-related Ressourcen
- ENV-Variablen zum Schalten der verschiedenen FHIR-Module

## Bugfix

- Korrektur Identifier.system-Angabe bei requestPsnWorkflow (fTTP)

## Change API
- Deprecated Funktionen entfernt: policyStatesForPerson

## Docker

- Einheitliche Endpoint-Konfiguration des TTP-FHIR GW per TTP-FHIR.env zur Aktivierung von E-PIX, gPAS und gICS-Enpunkten

# TTP-FHIR Gateway 2.2.3

## Improvements

- Verbesserung Konfiguration und Verwendung von SharedResources

# TTP-FHIR Gateway 2.2.2

## Improvements

- Umstrukturierung SharedResources zur Vereinfachung von Build-/Deploy-Prozessen

## Dependency-Updates

- FHIR HAPI 6.2.1

# TTP-FHIR Gateway 2.2.1

## Dependency-Updates

- FHIR HAPI 6.2.0 mit Fixes für CVE-2022-42889

# TTP-FHIR Gateway 2.2.0

## Implementation Guide

- https://www.ths-greifswald.de/fhir/ig/2-2-0

## New Features

Neuer FHIR-Endpoint zum Anlegen, Aktualisieren und Suchen von Personen. Details im [Implementation Guide](https://www.ths-greifswald.de/e-pix/fhir) sowie im [Handbuch](https://www.ths-greifswald.de/e-pix/handbuch/3-0-0)
- $addPatient: Anlegen von Personen per POST
- $updatePatient: Aktualisieren von Personen per POST
- Suche nach Personen und zugeordneten Identitäten per
- FHIR-SEARCH und _include=Person:link

## Improvements

- Validierung eingehender Ressourcen vom Typ Patient
- Ungültige Systemangaben bei $getAllConsentedIdsFor melden
- Optimierte Fehlermeldung bei Angabe ungültiger Consent-PolicyCodes
- Änderung FHIR Consent.datetime von gICSconsent.externalDate auf gICSconsent.legalDate

## Bug Fixes

- Suche nach ActivityDefinition per PolicyCode liefert BadRequest

## Dokumentation

- Bezeichnung der Rollen in KeyCloak-Dokumentation analog zu THS-Tools vereinheitlicht
- Verwendung ENV- und CLI-Files analog zu THS-Tools vereinheitlicht, Details siehe ReadMe.md

# TTP-FHIR Gateway 2.1.1

März 2022

## Improvements

- Erweiterte JMeter-Tests für gICS

## Bug Fixes

- Fehlerhafte Berücksichtigung von Version und PolicyCoding-System Parametern bei isConsented und getAllConsentedIdsFor

# TTP-FHIR Gateway 2.1.0

## New Features
- Umsetzung allPolicyStatesForPerson und currentPolicyStatesForPerson (ersetzen @deprecated policyStatesForPerson)
- Umsetzung  allConsentsForTemplate
- Umsetzung allConsentsForPerson
- Neues Default-Consent-Profil: https://ths-greifswald.de/fhir/StructureDefinition/gics/Consent mit Properties und QS-Status (VerificationResult)
- einheitlicher _profile-Parameter für Search und Operations
- Abruf aller Ressourcen per ID ermöglichen
- Admin-Role-basierte Keycloak-Absicherung

## Improvements

- Konfigurierbarer Import externer Codesysteme in FHIR R4 XML/JSON
- Aktualisierung Lizenztexte von 2021 -> 2022
- Erweiterte Benachrichtigung fehlende Keycloak-Server-Verbindung
- Konsistente Umsetzung ExpirationProperties in allen relevanten Profilen und Resourcen
- optionales ExternalProperty für ConsentTemplates "fhirPolicyValueSet"

## Bug Fixes

- ParseException bei Erstellung von Consent-Resourcen auf Basis von Template mit FreeText-Definitions

# TTP-FHIR Gateway 2.0.3

## Dependency-Updates

- slf4j-api v.1.7.5
- javaee-api v.8.0
- phloc-schematron v.2.7.1
- hapi-fhir-server v.5.6.1
- hapi-fhir-base v.5.6.1
- hapi-fhir-structures-r4 v.5.6.1
- hapi-fhir-validation-resources-r4 v.5.6.1
- phloc-schematron v.2.7.1
- keycloak-authz-client v.15.0.2
- keycloak-core v.15.0.2
- keycloak-common v.15.0.2

# TTP-FHIR Gateway 2.0.2

## Bug Fixes

- Fehlerhafte Auswertung Keycloak-Request

# TTP-FHIR Gateway 2.0.1

## New Features

- Berücksichtigung External Property fhirQuestionCodeSystem

## Improvements

- Trennung von Operations in fttpClearing und fttpProbability (neue Build-Profiles)
- Handling fehlenden Unterschriften und Scans
- Umgang mit fehlerhaften Base64 in Provenance-Ressourcen
- Meldung von Speicherproblemen
- Spezifikation von SafeSignerIdType per SAFE_SIGNERID_TYPE (deprecated) und fhirSafeSignerIdType

## Bug Fixes

- Ungültige Angabe SAFE_SIGNERID_TYPE führt zu NULL-Angabe

# Additional Information #
## Credits ##
**Concept and implementation:** P. Penndorf, M. Bialke, F.M. Moser <br/>
**FHIR-API:** P. Penndorf, M. Bialke <br/>
**Specification:** S. Lang

## License ##
**License:** AGPLv3, https://www.gnu.org/licenses/agpl-3.0.en.html <br/>
**Copyright:** 2025 Trusted Third Party of the University Medicine Greifswald <br/>
**Contact:** https://www.ths-greifswald.de/kontakt/

## Publications ##
- https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-022-02081-4
- http://dx.doi.org/10.1186/s12967-015-0545-6
- https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-020-02457-y
- https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-018-1631-3
- https://doi.org/10.1016/j.ijmedinf.2024.105545