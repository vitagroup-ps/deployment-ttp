![context](https://www.ths-greifswald.de/wp-content/uploads/2019/01/Design-Logo-THS-deutsch-271.png)
# TTP FHIR Gateway
Current Docker-Version of TTP-FHIR Gateway: 2025.1.1 (Sept. 2025)

## About
The [TTP FHIR Gateway](https://simplifier.net/guide/ttp-fhir-gateway-ig/Kontext) was developed by the Trusted Third Party of the University Medicine Greifswald  and initially published in 2020 and is based on [FHIR HAPI](https://hapifhir.io/hapi-fhir/docs/server_plain/rest_operations.html) (FHIR R4). 

### Validating the successful installation
After installation use **curl** (or postman, etc.) to validate the proper deployment of the TTP FHIR Gateway.

The capability of the FHIR gateway is tool-specific. GET-request should retrieve the **FHIR capability statement** for each tool.    

gICS
```
curl <your-address:your-port>/ttp-fhir/fhir/gics/metadata
```
gPAS
```
curl <your-address:your-port>/ttp-fhir/fhir/gpas/metadata
```
E-PIX
```
curl <your-address:your-port>/ttp-fhir/fhir/epix/metadata
```
Dispatcher
```
curl <your-address:your-port>/ttp-fhir/fhir/dispatcher/metadata
```

## Specification and Implementation Guide

[https://www.ths-greifswald.de/fhir](https://www.ths-greifswald.de/fhir)

## Keycloak Support

[https://www.ths-greifswald.de/ttpfhirgw/keycloak](https://www.ths-greifswald.de/ttpfhirgateway/keycloak)
             
## Release Notes

[https://www.ths-greifswald.de/ttpfhirgw/releasenotes](https://www.ths-greifswald.de/ttpfhirgw/releasenotes)

# Overview of FHIR Extern Properties for gICS

By default, when gICS content is provided in the form of FHIR resources by the TTP-FHIR Gateway, gICS-specific references and codings are used for e.g. answer options in
questionnaires, references to questions in consent modules (TemplateFrame) and policy semantics (ConsentFrame).
policy semantics (Consent.Provisions).

These can be configured by using corresponding external properties, for example via the gICS interface or customised by importing a user-defined template import format. The following tables show external properties which, if
are taken into account when FHIR resources are created.

Changes to external properties are also possible retrospectively for already finalised and
actively used templates, e.g. by importing updated consent templates (tick the box next to
allowUpdates)

| Scope    | ExternalProperty             | Example                            | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
----------|------------------------------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Domain | **fhirSafeSignerIdType** | `fhirSafeSignerIdType = Pseudonym` | In gICS, the signing participant is represented by 1-n participant IDs. The number and type of participant IDs are determined by the domain configuration. If more than one SignerIdType is configured within a consent domain (e.g. pseudonym, case numbers, patient ID), the first SignerIdType is used by default in FHIR Consent exports as the person identifier based on the FHIR Consent Patient17 in FHIR Consent. this can be adjusted if necessary by defining an external property fhirSafeSignerIdType for the respective domain. |
| **NEW** Domain |**fhirForceProfileConsent**|`fhirForceProfileConsent=https://ths-greifswald.de/fhir/StructureDefinition/gics/Consent`|Force default export of consent resources **within the whole domain** in gICS-specific Profile|
| Template | **fhirPolicyValueSet** |`fhirPolicyValueSet=urn:oid:2.16.840.1.113883.3.1937.777.24.5.3`| Default value set to be used for `Consent.Provision.Coding`. Affects all policies assigned to the template.                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Template | **fhirAnswerCodeSystem** |`fhirAnswerCodeSystem=2.16.840.1.113883.3.1937.777.24.5.2`| Individualisation of answers and answer options for FHIR Questionnaire and FHIR. Use with Questionnaire.Item.Item.AnswerValueset QuestionnaireResponse through selected external properties.                                                                                                                                                                                                                                                                                                                                                                                    |
| Template | **fhirAnswerValueSet**|`fhirAnswerValueSet=https://www.medizininformatik-initiative.de/fhir/ValueSet/MiiConsentAnswerValueSet`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.AnswerValueset |
| Template | **fhirAnswerCodeYes** |`fhirAnswerCodeYes=2.16.840.1.113883.3.1937.777.24.5.2.1`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer                                                                                                                                                                                                                                                                                                                                                                                                                            
| Template | **fhirAnswerCodeNo** |`fhirAnswerCodeNo=2.16.840.1.113883.3.1937.777.24.5.2.2`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer |
| Template | **fhirAnswerCodeUnknown** |`fhirAnswerCodeUnknown=2.16.840.1.113883.3.1937.777.24.5.2.3`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer.
| Template | **fhirAnswerDisplayYes** |`fhirAnswerDisplayYes=valid`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer |
| Template | **fhirAnswerDisplayNo** |`fhirAnswerDisplayNo=invalid`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer |
| Template | **fhirAnswerDisplayUnknown** |`fhirAnswerDisplayUnknown=unknown`| Individualisation of answers and answer options for FHIR Questionnaire. Use with Questionnaire.Item.Item.Initial and QuestionnaireResponse.Item.Anwer |
| Template | **fhirPolicyUri** |`fhirPolicyUri=urn:oid:2.16.840.1.113883.3.1937.777.24.2.1790`| Consent.policy.uri to uniquely identify the version of the MII Broad Consent |
| Template | **fhirConsentCategory** |`fhirConsentCategory=2.16.840.1.113883.3.1937.777.24.2.184`| Consent.category.coding to uniquely identify the MII Broad Consent |
| **NEW** Template |**fhirForceProfileConsent**|`fhirForceProfileConsent=https://www.medizininformatik-initiative.de/fhir/modul-consent/StructureDefinition/mii-pr-consent-einwilligung`|Force default export of consent resources **based on the specific template** in MII KDS Consent-specific Profile|
| Module | **fhirQuestionCode** |`fhirQuestionCode=2.16.840.1.113883.3.1937.777.24.2.1594`| Individualisation of FHIR Questionnaire.Item.linkId through selected external properties. Consideration for FHIR Element TemplateFrame (Questionnaire.Item.Code and linkId) and QuestionnaireComposed.Item.Code |

## Supported profiles for **fhirForceProfileConsent** 

- **DEFFAULT**: HL7 Germany Working Group Consent Management profile (as of Dec. 2024 ) : http://fhir.de/ConsentManagement/StructureDefinition/Consent 
    Details from  https://simplifier.net/guide/Einwilligungsmanagement/Consent?version=current

- MII Core Data Set Consent profile: https://www.medizininformatik-initiative.de/fhir/modul-consent/StructureDefinition/mii-pr-consent-einwilligung ,
 Details from https://www.medizininformatik-initiative.de/Kerndatensatz/Modul_Consent/IGMIIKDSModulConsent-TechnischeImplementierung-FHIRProfile-Consent.html

- gICS specific Consent Profile with several extensions: https://ths-greifswald.de/fhir/StructureDefinition/gics/Consent , 
Details from https://www.ths-greifswald.de/gics/fhir



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