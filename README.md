# Docker Enterprise

Install Docker EE using Mirantis Launchpad

Download and install Mirantis Launchpad on the UCP Manager server using launchpad version 1.5.6:
```
wget https://get.mirantis.com/launchpad/v1.5.6/launchpad_linux_amd64_1.5.6
```
Rename the Launchpad Linux x64 file to "launchpad":
```
mv launchpad_linux_amd64_1.5.6 launchpad
```

Make the launchpad file executable:
```
chmod +x launchpad
```

View the Launchpad version number:
```
./launchpad version
```
Register the cluster:
``` 
./launchpad register

# When prompted, enter in your name, email, and company name.
Type "Y" to accept the license agreement.
```
## Generate Certificates for DTR

Generate a certificate using open SSL:
```
openssl genrsa -out ca.key 4096
```

Generate a public key for Docker Trusted Registry by including a simple subject "/OU=dtr/CN=DTR CA" and passing in the private key file ca.key:
```
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -subj "/OU=dtr/CN=DTR CA" -out ca.crt

# Disregard any warning message that may occur. 
```
Generate a server private key for the certificate:
```
openssl genrsa -out dtr.key 2048
```

Generate a public certificate for the server by creating a certificate signing request, passing in the private key dtr.key, and including a simple subject "/OU=dtr/CN=system:dtr" and output dtr.csr:
```
openssl req -new -sha256 -key dtr.key -subj "/OU=dtr/CN=system:dtr" -out dtr.csr
```
Add some certificate extension values by creating the file:
```
vi extfile.cnf
```

Specify the certificate extension values, substituting your provided public IP address for <DTR_PUBLIC_IP_SERVER>:
```
keyUsage = critical, digitalSignature, keyEncipherment
basicConstraints = critical, CA:FALSE
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = IP:<DTR_PUBLIC_IP_SERVER>, IP:10.0.1.103,IP:127.0.0.1
```

Save and exit the certificate extension file:

Generate the public certificate for the server, passing in the certificate signing request dtr.csr, the ca.crt certificate and ca.key key, the certificate extension configuration extfile.cnf, and output dtr.crt:
```
openssl x509 -req -in dtr.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dtr.crt -days 365 -sha256 -extfile extfile.cnf
```
    
Create the Cluster
Create a cluster configuration file:
```
vi cluster.yaml
```
For the DTR certificate data, copy in the contents of each respective certificate file. Ensure that the indentation is correct for the yaml format. Each new line of the certificate data should be indented equal to the |- at the top of each certificate section.
```
apiVersion: launchpad.mirantis.com/v1beta3

kind: DockerEnterprise
metadata:
  name: launchpad-ucp
spec:
  ucp:
    version: 3.5.3
    installFlags:
    - --admin-username=admin
    - --admin-password=secur1ty!
    - --default-node-orchestrator=kubernetes
    - --force-minimums
  dtr:
    version: 2.8.2
    installFlags:
    - --ucp-insecure-tls
    - |-
      --dtr-cert "<contents of dtr.crt>"
    - |-
      --dtr-key "<contents of dtr.key>"
    - |-
      --dtr-ca "<contents of ca.crt>"
  hosts:
  - address: <IP Address of Manager>
    privateInterface: eth0
    role: manager
    ssh:
      user: labsuser
      keyPath: /home/labsuser/.ssh/id_rsa
  - address: <IP Address of Worker>
    privateInterface: eth0
    role: worker
    ssh:
      user: labsuser
      keyPath: /home/labsuser/.ssh/id_rsa
  - address: <IP Address of DTR Node>
    privateInterface: eth0
    role: dtr
    ssh:
      user: labsuser
      keyPath: /home/labsuser/.ssh/id_rsa
```
Check the privateInterface to apply using ifconfig command. It can be eth0 or ens5. 

Save and exit this file:
    :wq

Then look at the certificate file:
```
cat dtr.crt
```
Copy the entire contents of this file, including the "BEGIN CERTIFICATE" and "END CERTIFICATE" lines. Edit the cluster.yaml file:
```
vi cluster.yaml
```

Paste in the entire contents into the dtr-cert "<contents of dtr.crt>" line, replacing the "contents of dtr.crt" placeholder between the quotes. Because this is a yaml file, the indentation will have to be fixed so that every line lines up with the --dtr-cert line.

Insert the data for the dtr-key and dtr-ca in the same way, using the cat command and copy-pasting the data into the cluster.yaml file:
```
vi cluster.yaml
```

Save and exit the cluster.yaml file:
    :wq

Then create the cluster itself using Launchpad:
```
./launchpad apply -c ./cluster.yaml

# It will take some time
```

To access your UCP instance, open a web browser and navigate to https:// followed by the public IP address of the UCP Manager server. You may have to manually allow the self-signed certificate on your browser.

Log in to the UCP login page using the user name and password supplied in your cluster.yaml file.

When asked to provide a license, select Skip For Now. From here, check that the UCP Manager interface appears and UCP is running.

Ensure that Docker Trusted Registry is also working by navigating to https:// followed by the public IP address of your DTR server. You may have to accept the self-signed certificate again.

On the Docker Trusted Registry login page, use the same credentials that you used to log in to UCP.
Select Skip For Now for the license.

Check the Docker Trusted Registry interface and see if your Docker EE cluster setup was successful.