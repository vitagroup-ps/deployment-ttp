![context](https://user-images.githubusercontent.com/12081369/49164566-a5794200-f32f-11e8-8d3a-96244ea00832.png)

Current Docker-Version of gPAS: 2025.1.1 (Juli 2025)<br/>
Current Docker-Version of TTP-FHIR-Gateway: 2025.1.0 (June 2025), Details from [ReleaseNotes](https://www.ths-greifswald.de/ttpfhirgw/releasenotes/2025-1-0)

# About #
Large research networks, the implementation of clinical-epidemiological studies, but also the establishment
of registries and cohorts, require data processing that complies with data protection regulations. In accordance with Art. 32 para. 1a GDPR,
the use of pseudonyms helps to ensure an appropriate level of data processing protection.

The gPAS® was developed for this specific purpose. It is used to generate and manage pseudonyms. The domain concept enables the
structured management of pseudonyms per data source, application context (data collection, data transfer) or location.
The characters (alphabet) and algorithms used can be freely defined. The linking of domains enables the creation of hierarchies and
the generation of pseudonyms of any level (pseudonymisation of pseudonyms). The intuitive web interface supports the creation and resolving of pseudonyms.
If necessary, pseudonyms can be created temporarily or anonymised in order to take account of the ‘right to be forgotten’ of data subjects.
At the same time, gPAS also supports large amounts of data by means of list processing.
The dashboard provides an overview of the figures for generated pseudonyms and configured domains.
Users can get started quickly and easily with the manual provided, which guides them step by step through the functionalities and necessary configurations.

![context](https://www.ths-greifswald.de/wp-content/uploads/2019/01/gPAS-Screenshot-Pseudonymisieren.png)

# Download #

[Latest Docker-compose version of gPAS](https://www.ths-greifswald.de/gpas/#_download "")

# Source #

https://github.com/mosaic-hgw/gPAS/tree/master/source

## Live-Demo and more information ##

Try out gPAS from https://demo.ths-greifswald.de

or visit https://ths-greifswald.de/gpas for more information.

# API

## SOAP

All functionalities of the gPAS are provided for external use via SOAP-interfaces.
The [JavaDoc specs for the Services](https://www.ths-greifswald.de/gpas/doc "")
are available online (see package `org.emau.icmvc.ganimed.ttp.psn`).

Use SOAP-UI to create sample requests based on the WSDL files.

### Service-Interface for PSN Management

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gpas/gpasService?wsdl](https://demo.ths-greifswald.de/gpas/gpasService?wsdl)

### Service-Interface  for PSN Management with Notifications

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gpas/gpasServiceWithNotification?wsdl](https://demo.ths-greifswald.de/gpas/gpasServiceWithNotification?wsdl)

### Service-Interface for Configuration and Domain Management

The WSDL URL is [http://&lt;YOUR IPADDRESS&gt;:8080/gpas/DomainService?wsdl](https://demo.ths-greifswald.de/gpas/DomainService?wsdl)

## FHIR

More details from https://www.ths-greifswald.de/gpas/fhir

# IT-Security Recommendations #
Access to relevant application and database servers of the Trusted Third Party tools should only be possible for authorised personnel and via authorised end devices. We therefore recommend additionally implementing the following IT security measures:

* Operation of the relevant servers in separate network zones (separate from the research and supply network).
* Use of firewalls and IP filters
* Access restriction at URL level with Basic Authentication (e.g. with NGINX or Apache)
* use of Keycloak to restrict access to Web-Frontends and technical interfaces

# Additional Information #
The gPAS was developed by the University Medicine Greifswald and published in 2013 as part of the [MOSAIC-Project](https://ths-greifswald.de/mosaic "") (funded by the DFG HO 1937/2-1).

Selected functionalities of gPAS were developed as part of the following research projects:
- MIRACUM (funded by the German Federal Ministry of Education and Research 01ZZ1801M)

## Credits ##
**Concept and implementation:** L. Geidel <br/>
**Web-Client:** A. Blumentritt, M. Bialke, F.M. Moser <br/>
**Docker:** R. Schuldt <br/>
**TTP-FHIR Gateway für gPAS:** M. Bialke, P. Penndorf, L. Geidel, S. Lang, F.M. Moser

## License ##
**License:** AGPLv3, https://www.gnu.org/licenses/agpl-3.0.en.html <br/>
**Copyright:** 2013 - 2025 University Medicine Greifswald <br/>
**Contact:** https://www.ths-greifswald.de/kontakt/

## Publications ##
- https://dx.doi.org/10.3414/ME14-01-0133
- https://dx.doi.org/10.1186/s12967-015-0545-6
- https://dx.doi.org/10.3205/24gmds102
- https://dx.doi.org/10.3205/24gmds101

# Supported languages #
German, English
