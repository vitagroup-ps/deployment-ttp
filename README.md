# TTP Local Deployment

This README describes how to run a local TTP setup and test the FHIR endpoints with `curl`. 

The full gPAS FHIR API specification can be found here: [gPAS FHIR Operations](https://www.ths-greifswald.de/wp-content/uploads/tools/fhirgw/ig/2025-1-0/ImplementationGuide-markdown-Pseudonymmanagement-Operations.html)

The full gICS FHIR API specification can be found here: [gICS FHIR Operations](https://www.ths-greifswald.de/wp-content/uploads/tools/fhirgw/ig/2025-1-0/ImplementationGuide-markdown-Einwilligungsmanagement-Operations.html)


# Using Docker-Compopse (folder docker)
## Prerequisites

- `docker` and `docker-compose`
- `jq` and `xq`

Add the following entries to your `/etc/hosts`:

```bash
127.0.0.1   keycloak
127.0.0.1   ttp
```

Create a folder for the MySQL database:

```bash 
mkdir ./db
```

Create docker images (only needed if new version should be released):

```bash
docker buildx build --platform linux/amd64,linux/arm64 --tag deployment-ttp:latest --tag deployment-ttp:2025.1 --tag ghcr.io/vitagroup-ps/deployment-ttp:latest --tag ghcr.io/vitagroup-ps/deployment-ttp:2025.1 .
```

Push docker images (only needed if new version should be released):

```bash
docker login ghcr.io -u YOUR_GITHUB_USERNAME # use Personal Access Token as password
docker push ghcr.io/vitagroup-ps/deployment-ttp:latest
docker push ghcr.io/vitagroup-ps/deployment-ttp:2025.1
```

## Start the environment

```bash
docker-compose up keycloak
docker-compose up ttp
```

> The `ttp-app` container sometimes fails on startup. If this happens, just start it again and it should work.


# Using Helm Chart (folder helm)
## Prerequisites

- `docker`
- `minikube`, `kubectl` and `helm`
- MySQL Operator dependency

Add the following entries to your `/etc/hosts`:

```bash
127.0.0.1   keycloak
127.0.0.1   ttp
```

Start `minikube` and enable ingress:

```bash
minikube start
minikube addons enable ingress
```

Add the dependencies (only needed if they do not exist yet):

```bash
helm repo add mysql-operator https://mysql.github.io/mysql-operator
helm repo update
```

All the following installations are executed in the namespace "ttp".

## MySQL Database (folder helm/mysql)
### Install MySQL Operator

```bash
helm dependency build
helm upgrade --install ttp-mysql ./ -f values-local.yaml -n ttp --create-namespace

kubectl get pods,deploy,sts,job,pvc,svc,ing -n ttp # check deployment progress
kubectl logs -f <podname> -n ttp # follow pod logs
```

### Check Access to MySQL Operator

The MySQL router should be accessible in the namespace `ttp` via `ttp-mysql.ttp.svc.cluster.local:3306`.

```bash
kubectl run -it --rm mysql-client --image=mysql:8.0 -n ttp --restart=Never -- \
  mysql -h ttp-mysql.ttp.svc.cluster.local -P 3306 -uroot -proot
```

Check if the demo data is created in gICS and gPAS:

```sql
USE gpas;
SELECT * FROM psn;

USE gics;
SELECT * FROM signer_id;
```


## TTP Keycloak (folder helm/keycloak)
### Install TTP Keycloak

```bash
helm upgrade --install ttp-keycloak ./ -f values-local.yaml -n ttp

kubectl get pods,deploy,sts,job,pvc,svc,ing -n ttp # check deployment progress
kubectl logs -f <podname> -n ttp # follow pod logs
```

The Keycloak should be accessible in the namespace `ttp` via `ttp-keycloak.ttp.svc.cluster.local:8091`.


## TTP Tools (folder helm/ttp)
### Install TTP Tools

Create the secrets containing the credentials to pull images from the GitHub Container Registry (GHCR):

```bash
kubectl create secret docker-registry ghcr-credentials \
  --docker-server=ghcr.io \
  --docker-username=<your-github-username> \
  --docker-password=<your-PAT-with-read:packages> \
  -n ttp
```

Install the image from GHCR:

```bash
helm upgrade --install ttp-app ./ -f values-local.yaml -n ttp

kubectl get pods,deploy,sts,job,pvc,svc,ing -n ttp # check deployment progress
kubectl logs -f <podname> -n ttp # follow pod logs
```

The TTP Tools should be accessible in the namespace `ttp` via `ttp-app.ttp.svc.cluster.local:8080`.

## Forward Ports to Host

In order to access the TTP and Keycloak from the host environment, you need to forward the ingress to the host system:

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80 8091:80
```


# Testing
## Keycloak

The admin console can be reached on `http://keycloak:8091/admin`.

Default user:
* Username: `admin`
* Password: `admin`

### Realm & Clients

The **`ttp`** realm is already configured, having three clients:
* `ttp-web` for the frontend
* `ttp-fhir` for the FHIR endpoint
    * Client ID: `ttp-fhir`
    * Client Secret: `lbJOPUKb2bzanUg7Bi5jbV17Kg6IZOvE`
* `ttp-soap` for the SOAP endpoint
    * Client ID: `ttp-soap`
    * Client Secret: `rlNJFPRVdMZStmzls9efPyMb2oGmRRNQ`

## gPAS Web

The gPAS web frontend can be reached on  `http://ttp:8080/gpas-web`.

Default user:
  * Username: `gpas-admin`
  * Password: `gpas-admin`

Three domains (MPI, pDR, and Study01) are preconfigured containing 4 pseudonyms each.

## gICS Web

The gICS web frontend can be reached on  `http://ttp:8080/gics-web`.

Default user:
  * Username: `gics-admin`
  * Password: `gics-admin`

One domain (MII) is preconfigured containing the consent of the 4 patients registered with pseudonyms in gPAS.

## Requests FHIR

### Obtain an Access Token via client_credentials flow

Use your `ttp-fhir` client’s credentials to get a token and export it using `jq`:

```bash
CLIENT_ID="ttp-fhir"
CLIENT_SECRET="lbJOPUKb2bzanUg7Bi5jbV17Kg6IZOvE"

ACCESS_TOKEN=$(
  curl -s -X POST "http://keycloak:8091/realms/ttp/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}" \
  | jq -r '.access_token'
)

echo "Token exported. Starts with: ${ACCESS_TOKEN:0:12}..."
```

### gPAS FHIR Endpoint Metadata

Test access to the gPAS FHIR endpoint by reading the CapabilityStatement:

```bash
curl -X GET "http://ttp:8080/ttp-fhir/fhir/gpas/metadata" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  | jq
```

### gPAS FHIR Endpoint Pseudonymization

Create pseudonyms in the gPAS domain `pDR` for the provided original values using the operation `$pseudonymizeAllowCreate` on the gPAS FHIR endpoint:

```bash
curl -X POST 'http://ttp:8080/ttp-fhir/fhir/gpas/$pseudonymizeAllowCreate' \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "resourceType": "Parameters",
    "parameter": [
      {
        "name": "target",
        "valueString": "pdr"
      },
      {
        "name": "original",
        "valueString": "mpi_0000000001"
      },
      {
        "name": "original",
        "valueString": "mpi_0000000002"
      },
      {
        "name": "original",
        "valueString": "mpi_0000000003"
      },
      {
        "name": "original",
        "valueString": "mpi_0000000004"
      }
    ]
  }' \
  | jq
```

## Requests SOAP
### Obtain an Access Token via client_credentials flow

Use your `ttp-soap` client’s credentials to get a token and export it using `jq`:

```bash
CLIENT_ID="ttp-soap"
CLIENT_SECRET="rlNJFPRVdMZStmzls9efPyMb2oGmRRNQ"

ACCESS_TOKEN=$(
  curl -s -X POST "http://keycloak:8091/realms/ttp/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}" \
  | jq -r '.access_token'
)

echo "Token exported. Starts with: ${ACCESS_TOKEN:0:12}..."
```

### gPAS SOAP Endpoint WSDL Definition

Test access to the gPAS SOAP endpoint by reading the WSDL definition:

```bash
curl -X GET "http://ttp:8080/gpas/gpasService?wsdl" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  | xq
```

### gPAS SOAP Endpoint Pseudonym Tree

Resolve the full pseudonym tree in gPAS for the provided pseudonym (without specifing the domain) using the operation `getPSNNetFor` on the gPAS SOAP endpoint:

```bash
curl -X POST 'http://ttp:8080/gpas/gpasService' \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/xml" \
  -d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psn="http://psn.ttp.ganimed.icmvc.emau.org/">
    <soapenv:Header/>
    <soapenv:Body>
      <psn:getPSNNetFor>
        <valueOrPSN>pdr_0000000001</valueOrPSN>
      </psn:getPSNNetFor>
    </soapenv:Body>
  </soapenv:Envelope>
  ' \
  | xq
```
