![context](https://www.ths-greifswald.de/wp-content/uploads/2019/01/Design-Logo-THS-deutsch-542.png)

Stand: April 2023

# Authentifizierung und Autorisierung mit gRAS

Die Einrichtung des *generic Roles&Rights and Authorisation Service* (kurz *gRAS*) wird am Beispiel von gPAS demonstriert. Die Einrichtung für gICS (role.gics.admin/role.gics.user), E-PIX (role.epix.admin/role.epix.user) und TTP-Dispatcher erfolgt analog.

Die beschriebenen Authentifizierungs- und Autorisierungsmechanismen basieren auf MySQL und JAX-WS per Wildfly-Konfiguration. Nutzer müssen sich für die Nutzung des gPAS mittels Benutzernamen (**user@ths**) und Passwort einloggen. Je nach zugeordneter Rolle enthalten sie unterschiedliche Berechtigungen.
Bei der Installation des gPAS mittels Docker werden standardmäßig ein Admin-Nutzer „**admin**“, sowie ein Standard-Nutzer „**user**“ angelegt. Die Anmeldung erfolgt unter Angabe der Domäne „**ths**“.

```
[Default-Admin] username="admin@ths", password="ttp-tools"
[Default-User] username="user@ths", password="ttp-tools"
```

Die Autorisierung kann werkzeugübergreifend erfolgen. So kann ein und dieselbe Person z.B. beim E-PIX Standard-Nutzer und beim gPAS Admin-Nutzer sein.

<div style="page-break-after: always;"></div>

## Verwaltung der Nutzer, Rollen und Rechte mittels MySQL und Docker EXEC
Die Verwaltung der Nutzer (anlegen, aktivieren, deaktivieren, Passwort ändern) und das Zuweisen von Rechten kann direkt in der entsprechenden Datenbank (gRAS) oder per Docker EXEC auf dem entsprechenden Datenbank-Container (*hier examplarisch: gPAS-1.11.0-mysql*) erfolgen.
Die Verwaltung erfolgt auf Basis entsprechender MySQL-Prozeduren. Diese werden im Zuge der Docker-Installation der Web-Auth-Version für gPAS automatisch angelegt.
### Nutzer anlegen
⚠️ *Hinweis: Das Nutzer-Passwort wird zwar im Klartext angegeben, die Prozedur jedoch erzeugt automatisch einen SHA-256-Hash, der in der gRAS-Datenbank gespeichert wird.*

Docker
```
docker exec -it gPAS-1.11.0-mysql mysql -ugras_user -pgras_password 
-e "use gras;call createUser('BENUTZERNAME','PASSWORT','KOMMENTAR');"
```
SQL

```
use gras;
call createUser("BENUTZERNAME","PASSWORT","KOMMENTAR");
```
### Rechtevergabe
Nutzer haben standardmäßig keine Berechtigungen. Die Vergabe dieser erfolgt je Werkzeug („Projekt“) unter der Angabe von epix, gpas oder gics (Schreibweise wie hier dargestellt). 
#### Admin-Rechte vergeben
⚠️ *Hinweis: Admin-Rechte beinhalten die Standard-Rechte.*

Docker
```
docker exec -it gPAS-1.11.0-mysql mysql -ugras_user -pgras_password 
-e "use gras;call grantAdminRights('gPAS','BENUTZERNAME');"
```

SQL

```
use gras;
call grantAdminRights("gPAS","BENUTZERNAME");
```
#### Standard-Rechte vergeben

Docker
```
docker exec -it gPAS-1.11.0-mysql mysql -ugras_user -pgras_password 
-e "use gras;call grantStandardRights('gPAS','BENUTZERNAME');"
```

SQL
```
use gras;
call grantStandardRights("gPAS","BENUTZERNAME");
```
### Passwort ändern

Docker
```
docker exec -it gPAS-1.11.0-mysql mysql -ugras_user -pgras_password 
-e "use gras;call changePassword('BENUTZERNAME','NEUES_PASSWORT');"
```
SQL
```
use gras;
call changePassword("BENUTZERNAME","NEUES_PASSWORT");
```

### Nutzer aktivieren/deaktivieren
⚠️ *Hinweis: Diese Änderungen werden erst nach einem Neustart des Wildfly übernommen.*

Docker
```
docker exec -it gPAS-1.11.0-mysql mysql -ugras_user -pgras_password 
-e "use gras;call disableUser('BENUTZERNAME');"
```
SQL
```
call disableUser("BENUTZERNAME"); -- Benutzer deaktivieren
call enableUser("BENUTZERNAME"); -- Benutzer aktivieren
```
<div style="page-break-after: always;"></div>

## Erweiterte Rechte-Konfiguration
### Domain anlegen
⚠️ *Hinweis: Die Authentifizierungsdomain ist unabhängig von den Pseudonymisierungsdomänen.
Innerhalb der gRAS-Authentifizierung wird per Default die Parent Domain „ths“ genutzt, um Anmeldung von Nutzern für einen ausgewählte Authentifizierungsdomain (user@domain) zu ermöglichen. Die Individualisierung der Domänen ist möglich.*

SQL
```
use gras;
call createDomain('domainName', 'parent domain');
```

### Projekt anlegen
Innerhalb der gRAS-Authentifizierung wird mit dem Projekt das abzusichernde Werkzeug (konkret hier: gPAS) bezeichnet. Per Default wird hier entsprechend das Projekt „gpas“ genutzt. Die Individualisierung des Projektnamens ist möglich.

SQL
```
use gras;
call createProject('domainName', 'parent domain');
```

## Gruppe anlegen
Rechte werden stets nur Gruppen zugeordnet. Per Default werden für die Authentifizierung per gRAS im gPAS-Frontend die Gruppen gPAS-users und gPAS-admins genutzt. Anpassungen und Ergänzungen sind möglich.

SQL
```
-- createGroup(<projectName>, <groupName>, <description>)
CALL createGroup('gpas','gpas-users','this group is for users with basic right');
CALL createGroup('gpas','gpas-admins', 'this group is for users with extended right');
```

<div style="page-break-after: always;"></div>

### Rolle anlegen
Je Projekt/Werkzeug kann ein-und-derselbe Nutzer unterschiedliche Rollen einnehmen. Per Default werden für die Authentifizierung per gRAS im gPAS-Frontend die Rollen role.gpas.user und 
role.gpas.admin genutzt. Diese Rollen sind fest den jeweiligen Unterseiten des gPAS-Frontends zugeordnet und können nicht geändert werden. Das Ergänzen zusätzlicher Rollen ist möglich.

SQL
```
-- createRole(<projectName>, <roleName>, <description>)
CALL createRole('gpas', 'role.gpas.user', gPAS userspace');
CALL createRole('gpas', 'role.gpas.admin', gPAS adminspace');
```

### Zuordnung von Gruppen und Rollen
Die finalen Rechte erhält jeder Nutzer durch die Zuordnung von Gruppen (sind in der gRAS-Datenbank per Default in ADMIN und USER unterteilt) und Rollen (sind im Frontend definiert und eingebettet). Das Ergänzen zusätzlicher Zuordungen ist möglich.

SQL
```
-- createGroupRoleMapping(<projectName>, <groupName>, <roleName>)
CALL createGroupRoleMapping('gpas','gPAS-users','role.gpas.user');
CALL createGroupRoleMapping('gpas','gPAS-admins','role.gpas.admin');
```

## Lizenz ##
License: AGPLv3, https://www.gnu.org/licenses/agpl-3.0.en.html

Copyright: 2021 Trusted Third Party of the University Medicine Greifswald

Contact: https://www.ths-greifswald.de/kontakt/
