# Docker Enterprise

Install Docker EE using Mirantis Launchpad

Pre-Requistic
1. Atleast 2 Ec2 machine, t2.large of Ubuntu 20.04 LTS image, one for Manager and 2 worker. AWS AMI Image - ami-09cc6a8fafaecf851
2. One worker will used for Docker registry

Generate Keys
```
ssh-keygen
```
Authorized_keys for master and worker node
```
touch .ssh/authorized_keys
```
```
chmod -R 700 .ssh
```
```
cat .ssh/id_rsa.pub
```

###  Add the content of public key into authorized_keys
```
vi .ssh/authorized_keys
```
Follow same for all the worker nodes.

Check the connection to worker node
```
ssh ubuntu@<ip-address>
```

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
```
When prompted, enter in your name, email, and company name. Type "Y" to accept the license agreement.

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
<br>

## Create the Cluster
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
  - address: <PRIVATE IP Address of Manager>
    privateInterface: eth0
    role: manager
    ssh:
      user: ubuntu
      keyPath: /home/ubuntu/.ssh/id_rsa
  - address: <PRIVATE IP Address of Worker>
    privateInterface: eth0
    role: worker
    ssh:
      user: ubuntu
      keyPath: /home/ubuntu/.ssh/id_rsa
  - address: <PRIVATE IP Address of DTR Node>
    privateInterface: eth0
    role: dtr
    ssh:
      user: ubuntu
      keyPath: /home/ubuntu/.ssh/id_rsa
```
Check the privateInterface to apply using ifconfig command. It can be eth0 or ens5. 

Save and exit this file:
    :wq

Below steps we will need to perform if we are installing DTR as well.
****

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

*****
<br><br><br>

Now we are ready to launch our configuration
```
./launchpad apply -c ./cluster.yaml

# It will take some time, around 10 - 15 mins
```

To access your UCP instance, open a web browser and navigate to https:// followed by the public IP address of the UCP Manager server. You may have to manually allow the self-signed certificate on your browser.

Log in to the UCP login page using the user name and password supplied in your cluster.yaml file.

When asked to provide a license, select Skip For Now. From here, check that the UCP Manager interface appears and UCP is running.

Ensure that Docker Trusted Registry is also working by navigating to https:// followed by the public IP address of your DTR server. You may have to accept the self-signed certificate again.

On the Docker Trusted Registry login page, use the same credentials that you used to log in to UCP.
Select Skip For Now for the license.

Check the Docker Trusted Registry interface and see if your Docker EE cluster setup was successful.



# Setting up Kubectl

kubectl is a command line tool to access kubernetes cluster.

Install kubectl on machine
```
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
```

```
sudo mv ./kubectl /usr/local/bin/kubectl
```
```
sudo chmod 777 /usr/local/bin/kubectl
```
```
sudo kubectl version --client
```

Download the client bundle from UCP. Navigate to Admin-->My Profile --> Client Bundle --> Download

Extract the zip file, you will find kube.yaml. 
```
mkdir ~/.kube
```
```
cd .kube
```
Copy the kube.yaml content to .kube/config file 
```
vi config
```
```
kubectl --insecure-skip-tls-verify get pods
```

```
kubectl exec --insecure-skip-tls-verify nginx-pod -- cat /etc/hostname
```
```
kubectl delete pod --insecure-skip-tls-verify nginx-pod
```


# Create a nginx service on Kubernetes and access it using a pod

Create a service on kubernetes
Navigate to Kubernetes--> Create

Add below Yaml to create a deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

Create a service 
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
Check the IP address of Pod created as part of deployment. Navigate to Kubernetes--> Pod --> click on Pod

Create a endpoint
```
apiVersion: v1
kind: Endpoints
metadata:
  name: nginx-service-endpoint
subsets:
  - addresses:
      - ip: <pod_ip_1>
      - ip: <pod_ip_2>
    ports:
      - port: 80
```
Replace <pod_ip_1>, <pod_ip_2> with the IP addresses of your Nginx pods.

Create a pod to access the nginx service

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-client-pod
spec:
  containers:
  - name: nginx-client
    image: curlimages/curl:latest
    command: ["sleep", "infinity"]
```

Access nginx using service Ip address. Navigate to Kubenetes-->Pod--> click on pod nginx-client-pod.

Click on exec icon on top right and open a sh terminal
```
curl nginx-service

or 

curl <ipaddress of nginx service>
```


# Storage


Create a /mnt/data directory and navigate to it
```
sudo mkdir /mnt/data
```
```
cd /mnt/data
```

Create a Persistent Volume
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 3Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```

Create Persistent Volume Claim
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

Check the status of Persistent Volume, it will be 'Bound'. As soon as you delete PVC, it will change to 'Release'.


# ConfigMap and Secrets

Create a configmap
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-configmap
data:
  key1: value1
  key2: value2
```

Create Secret

```
apiVersion: v1
kind: Secret
metadata:
  name: example-secret
type: Opaque
data:
  username: dXNlcm5hbWU=  # base64-encoded "username"
  password: cGFzc3dvcmQ=  # base64-encoded "password"
```

Create a POD, which uses confgmap and secret as Env variable
```
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
      - name: CONFIG_KEY1
        valueFrom:
          configMapKeyRef:
            name: example-configmap
            key: key1
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: example-secret
            key: username
```

Navigate to the Pod and execute command
```
env
```
It will list down all the environment variables and we can find variable as CONFIG_KEY1 and SECRET_USERNAME.



