![context](https://user-images.githubusercontent.com/12081369/49164555-a27e5180-f32f-11e8-8725-7b97e35134b5.png)

Current Version: 2025.1.1 (Sep 2025)<br/>
Current Docker-Version of TTP-FHIR-Gateway: 2025.1.1 (Sept 2025), Details from [ReleaseNotes](https://www.ths-greifswald.de/ttpfhirgw/releasenotes/2025-1-1)

# About #
The collection, processing and use of medical research data generally requires the informed consent of the data subject for a specific purpose, known as informed consent (IC) (see Art. 6-11 GDPR). In addition to this classic opt-in approach (with IC), legal requirements (e.g. GDNG, KFRG, ePA) may permit the collection and use of data without the prior consent of data subjects (opt-out). In both cases, however, the obligation to provide evidence to supervisory authorities (Art. 5 para. 2 GDPR) and the data subject's will not to participate (withdrawal, objection) should be taken into account. Therefore, in the context of constantly growing national and international research initiatives, a reliable and efficient procedure for the digital management of the data subject's will is indispensable as the basis for legally permissible data processing.

The consent management solution gICS® supports both approaches: opt-in and opt-out. gICS® can be integrated into purely paper-based consent processes (import of scans and structured documentation) and supports the necessary quality assurance. Purely digital workflows (digital signature, tablet integration, API) can also be realised quickly and easily.
Comprehensive analysis mechanisms allow all consent-related documents of a data subject to be analysed in real time in a traceable and reproducible manner at any time and the valid consent status to be determined.

Templates for required documents (consents, withdrawals, objections, etc.) can be created, edited and exported or imported in the WYSIWYG editor. A wide range of response options, freely configurable additional fields, individual validity specifications (from/to date, period, age) and the option of storing properties of external systems allow a wide range of requirements for research projects and registry projects to be implemented.

![context](https://user-images.githubusercontent.com/22166209/42631209-c1a9e236-85d9-11e8-94e8-74b5022a2f43.PNG)

# Download #

[Latest Docker-compose version of gICS](https://www.ths-greifswald.de/gics/#_download "")

# Source #

https://github.com/mosaic-hgw/gICS/tree/master/source

# Live-Demo and more information #

Try out gICS from https://demo.ths-greifswald.de

or visit https://ths-greifswald.de/gics for more information.

# API

## SOAP

All functionalities of the gICS are provided for external use via SOAP-interfaces.
The [JavaDoc specs for the Consent Services](https://www.ths-greifswald.de/gics/doc "")
are available online (see package `org.emau.icmvc.ganimed.ttp.cm2`).

Use SOAP-UI to create sample requests based on the WSDL files.

### Standard-Service-Interface

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gics/gicsService?wsdl](https://demo.ths-greifswald.de/gics/gicsService?wsdl)

### Standard-Service-Interface with Notifications

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gics/gicsServiceWithNotification?wsdl](https://demo.ths-greifswald.de/gics/gicsServiceWithNotification?wsdl)

### Management-Service-Interface

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gics/gicsManagementService?wsdl](https://demo.ths-greifswald.de/gics/gicsManagementService?wsdl)

## FHIR

More details from https://www.ths-greifswald.de/gics/fhir

# IT-Security Recommendations #
Access to relevant application and database servers of the Trusted Third Party tools should only be possible for authorised personnel and via authorised end devices. We therefore recommend additionally implementing the following IT security measures:

* Operation of the relevant servers in separate network zones (separate from the research and supply network).
* Use of firewalls and IP filters
* Access restriction at URL level with Basic Authentication (e.g. with NGINX or Apache)
* use of Keycloak to restrict access to Web-Frontends and technical interfaces

# Additional Information #

The gICS was developed by the University Medicine Greifswald and published in 2014 as part of the [MOSAIC-Project](https://ths-greifswald.de/mosaic "")  (funded by the DFG HO 1937/2-1). Selected
functionalities of gICS were developed as part of the following research projects:

- MAGIC (funded by the DFG HO 1937/5-1)
- MIRACUM (funded by the German Federal Ministry of Education and Research 01ZZ1801M)
- NUM-CODEX (funded by the German Federal Ministry of Education and Research 01KX2021)

## Credits ##
**Concept and implementation:** L. Geidel <br/>
**Web-Client:** A. Blumentritt, M. Bialke, F.M.Moser <br/>
**Docker:** R. Schuldt <br/>
**TTP-FHIR Gateway für gICS:** M. Bialke, P. Penndorf, L. Geidel, S. Lang, F.M. Moser

## License ##
**License:** AGPLv3, https://www.gnu.org/licenses/agpl-3.0.en.html <br/>
**Copyright:** 2014 - 2025 University Medicine Greifswald <br/>
**Contact:** https://www.ths-greifswald.de/kontakt/

## Publications ##
- https://doi.org/10.1186/s12911-022-02081-4
- https://rdcu.be/b5Yck
- https://rdcu.be/6LJd
- https://dx.doi.org/10.3414/ME14-01-0133
- https://dx.doi.org/10.1186/s12967-015-0545-6

# Supported languages #
German, English