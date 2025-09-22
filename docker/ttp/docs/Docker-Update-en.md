![context](https://user-images.githubusercontent.com/12081369/49164555-a27e5180-f32f-11e8-8725-7b97e35134b5.png)

Current Version: 2025.1.0 (Juli 2025)<br/>
Current Docker-Version of TTP-FHIR-Gateway: 2025.1.0 (June 2025), Details from [ReleaseNotes](https://www.ths-greifswald.de/ttpfhirgw/releasenotes/2025-1-0)

# Updating the THS tools via Docker

## Background

**The following example shows how to update the Docker container from gPAS. Basically, all THS tools (E-PIX, gPAS, gICS, Dispatcher) are updated in the same way **.

In the example, the existing and running instance of gPAS is referred to as `<gpas-old>`. The existing version (`<old-version>`) is to be saved and an update to a new version of gPAS (`<gpas-new>`, `<new-version>`) is to be carried out without changing the existing data in the MySQL database.

The following command can be used to check whether the instances of gPAS are running:
```
docker ps -a
```

## Action instruction

### Download new tool version from the THS website

Download and unzip the current version from [ths-greifswald.de/gpas](https://www.ths-greifswald.de/gpas), copy it to the host system and ensure that the appropriate permissions are set to execute the files.

```
CHMOD -R 755 /PATH
```

### Back up the current Docker configuration

To back up the current status of the gPAS configuration (Wildfly scripts, etc.) on the host system, back up the corresponding folder via TAR archive:

```
tar czf backup-gpas-2022-03-31.tgz <gpas-old>/
```


### Backing up the existing database

To additionally back up the existing database, a MySQL dump is triggered via the Docker console and the resulting export file is stored in the file system of the host.

```
sudo docker exec gpas-<old-version>-mysql /usr/bin/mysqldump -u gpas_user -p gpas > backup-gpas-<old-version>-2022-03-31.sql
```

The name of the existing MySQL instance must be adjusted accordingly.

### Updating the database

The database update scripts for all versions can be found in the Docker directory under *`<gpas-new>/update_scripts`*. The update scripts must be copied into the Docker container, whereby only the scripts that affect the version between `<gpas-old>` and `<gpas-new>` are required.

```
docker cp <gpas-new>/update_scripts/ gpas-<old-version>-mysql:/update-files/
```

Depending on the version from which gPAS is to be updated, the relevant SQL scripts must be run *chronologically*.

**Example:** For an update from version 1.10.0 to 1.12.0, the scripts *update_database_gpas_1.10.x-1.11.0.sql* and *update_database_gpas_1.11.x-2.12.0.sql* must therefore be executed.

To do this, connect to the existing database via MySQL client and run the update scripts one after the other. This can be realized via *docker* (adjust usernames and passwords if necessary).

**Example:**

```
docker exec -it gpas-1.10.0-mysql /usr/bin/mysql -u gpas_user -p -e "USE gpas; $(cat gpas-new/standard/update_database_gpas_1.10.x-1.11.0.sql)"
docker exec -it gpas-1.10.0-mysql /usr/bin/mysql -u gpas_user -p -e "USE gpas; $(cat gpas-new/standard/update_database_gpas_1.11.x-2.12.0.sql)"
```

### Update the deployments and wildfly configuration

Now shut down the database container

```
docker gpas-<old-version>-mysql down
```

#### Updating the deployments

Delete the deployments in the `<gpas-old>` directory on the host system and copy the new deployments into it

```
rm -f <gpas-old>/deployments/* 
cp -R <gpas-new>/deployments/ <gpas-old>/deployments/
```

#### Update the name of the MySQL container

```
sudo docker rename gpas-<old-version>-mysql gpas-<new-version>-mysql
```

#### Updating the JBOSS configuration scripts

The old files can be saved or deleted and the new ones must be imported:

```
mv <gpas-old>/jboss <gpas-old>/jboss-<old-version>
cp -R <gpas-new>/jboss/ <gpas-old>/jboss
```

These files are used to configure JBOSS according to the specifications in the `*.env` files.

#### Updating the environment variables for the JBOSS configuration scripts

In the current version, the corresponding `*.env` files are located in the `./envs` subfolder. In older versions, these were located directly in the root directory of the Docker package. If such a version is to be updated, the `*.env` files must first be moved to the `./envs` subfolder:

```
mkdir <gpas-old>/envs
mv <gpas-old>/*.env <gpas-old>/envs/
```

This folder should also be backed up:

```
cp -R <gpas-old>/envs <gpas-old>/envs-<old-version>
```

Now the list of new and renamed `ENV` variables in the `README_gICS.md` in the root directory of the Docker package must be studied in order to adapt the `*.env` files accordingly if necessary. **Attention**: the names of the `*.env` files may also have been changed. This must be adapted in any case.

**Alternatively**, you can manually transfer the adaptations of the old `*.env` files to the new ones with a little more effort in order to maintain the greatest possible similarity between the adapted and delivered `*.env` files. To do this, the old customized files must be backed up and the new ones imported:

```
mv <gpas-old>/envs <gpas-old>/envs-<old-version>
cp -R <gpas-new>/envs/ <gpas-old>/envs
```

All manual adjustments to the old files must then be transferred to the new `*.env` files. This requires a great deal of attention. We recommend the use of a graphical diff tool (e.g. [devart Code Compare Free](https://www.devart.com/codecompare/featurematrix.html)). For future updates, it is helpful not to change the existing skeletons, examples and comments, but to add your own lines and mark them with an easily retrievable comment.

#### Updating the Docker Compose configuration

The old customized file must be saved and the new one imported:

```
mv <gpas-old>/docker-compose.yml <gpas-old>/docker-compose-<old-version>.yml
cp <gpas-new>/docker-compose.yml <gpas-old>/docker-compose.yml
```

The adjustments to the old `docker-compose.yml` (especially for ports and volumes) will probably have to be transferred to the new one (preferably using a graphical diff tool again).

#### Updating the documentation files

Finally, it is also recommended to transfer the updated documentation files:

```
rm -f <gpas-old>/*.md 
cp <gpas-new>/*.md <gpas-old>/
rm -f <gpas-old>/docs/* 
cp -R <gpas-new>/docs/ <gpas-old>/docs/
```

#### Customize the owner user

```
chown 999 <gpas-new>/sqls
chown 1000 <gpas-new>/deployments
chown 1000 <gpas-new>/logs
chown 1000 <gpas-new>/jboss
```

### Starting the updated container

Start the updated container using the following command (-d to start the container in the background):

```
docker-compose up -d
```

Check the success of the update by calling the web frontend at [http://IPADDRESS:8080/gpas-web](http://ipaddress:8080/gpas-web).

## In the event of an error: restoring the database

In the event of an error, the previous database can be restored (provided the instructions have been followed). Adjust user name and password if necessary.

```
docker exec -it gpas-<new-version>-mysql /usr/bin/mysql -u gpas_user -p -e "USE gpas; $(cat backup-gpas-2022-03-31.sql)"
```

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