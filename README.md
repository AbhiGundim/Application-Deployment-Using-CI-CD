### Application Deployment Using CI-CD

Implementing a DevOps Lifecycle involves several key components, including configuration management, source code management, continuous integration, continuous deployment, and monitoring. Below is a detailed guide on setting up each part of the DevOps lifecycle, based on your requirements.

### 1. Environment Setup and Configuration Management with Ansible

#### Setting up the Instances
You need three Ubuntu instances on AWS. Follow these steps:
- Launch three instances using the Ubuntu Server 22.04 LTS AMI.
- Select t2.micro as the instance type.
- Configure security groups to allow SSH and HTTP traffic.
- Create a new key-pair, download it, and keep it secure.

#### Installing Ansible
On your master instance:
1. Update packages:
   ```bash
   sudo apt update
   ```
2. Install Ansible:
   ```bash
   sudo apt install ansible -y
   ```
3. Check Ansible version to ensure it is installed:
   ```bash
   ansible --version
   ```

#### Configuring SSH Access
1. Generate an SSH key:
   ```bash
   ssh-keygen
   ```
2. Copy the public key to the slave instances to allow passwordless SSH:
   ```bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@<Slave-Instance-IP>
   ```

#### Setting up Ansible Hosts
1. Edit the `/etc/ansible/hosts` file to add your slave instances under a group:
   ```ini
   [slaves]
   slave1 ansible_host=<Slave1-IP>
   slave2 ansible_host=<Slave2-IP>
   ```

#### Running Ansible Playbooks
1. Create a playbook `play.yaml` to configure both master and slave machines:
   ```yaml
   - name: Configure Master
     hosts: localhost
     become: true
     tasks:
       - name: Install Jenkins
         script: master.sh

   - name: Configure Slaves
     hosts: slaves
     become: true
     tasks:
       - name: Setup Docker and Java
         script: slave.sh
   ```
2. Execute the playbook:
   ```bash
   ansible-playbook play.yaml
   ```

### 2. Git Workflow Implementation

Set up a Git workflow using branches like `develop` for development and `master` for production. Implement branch policies and review strategies using GitHub's branch protection rules.

### 3. Continuous Integration and Deployment with Jenkins

#### Jenkins Setup
1. Install Jenkins on the master instance using the `master.sh` script provided above.
2. Access Jenkins by navigating to `http://<Master-IP>:8080` and unlock it using the initial admin password found at `/var/lib/jenkins/secrets/initialAdminPassword`.
3. Install suggested plugins and set up an admin user.

#### Configuring Nodes
1. Add your slave instances as nodes in Jenkins for distributed builds.
2. Configure each slave with appropriate labels to control job execution locations.

#### Creating Jobs
1. Create three jobs in Jenkins:
   - **Job1**: Triggered on push to `develop`. Builds the Docker image and runs tests.
   - **Job2**: Triggered on push to `master`. Builds the Docker image, runs tests, and pushes the image to production.
   - **Job3**: Additional jobs as required for deployment or further testing.

#### Docker and Pipeline Configuration
1. Ensure the `Dockerfile` is in the repository and is configured to use `hshar/webapp` as the base image.
2. Use Jenkins pipelines (either scripted or declarative) to define the CI/CD process, including checkout, build, test, and deploy stages.

![dev1](https://github.com/AbhiGundim/Application-Deployment-Using-CI-CD/assets/124610756/93978a50-2d2b-4016-a95f-b79652c7d224)

![dev2](https://github.com/AbhiGundim/Application-Deployment-Using-CI-CD/assets/124610756/a2b25bc1-f07f-4dcb-80d2-68b9fe6c3592)


### 4. Monitoring and Logging

Set up monitoring and logging tools like Prometheus, Grafana, and ELK Stack to monitor the applications and infrastructure.

