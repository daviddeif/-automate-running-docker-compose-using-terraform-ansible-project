# automate-running-docker-compose-using-terraform-ansible-project
the project consists of 
-This Terraform script creates an AWS VPC with a public subnet and internet gateway. It also provisions two EC2 instances, a control instance, and a managed instance. The control instance runs an Ansible playbook to configure the managed instance. The script uses various Terraform resources such as `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_route_table`, `aws_route`, `aws_route_table_association`, and `aws_instance`. It also includes  remote-exec & file provisioners to execute commands such as uploading files, automate installing Ansible on the managed instance and running Ansible on the EC2 instances then automate running ansible playbook on it.

This playbook installs Docker, Docker Compose, and runs a Docker Compose project. Here's a brief summary of what each task does:

1. Install Python 3 and pip using the `dnf` module.
2. Uninstall the `requests` RPM package using the `dnf` module, if it's installed.
3. Install the `requests` module using pip.
4. Install Docker using the `yum` module.
5. Install Docker Compose using pip.
6. Download and install the latest version of Docker Compose binary from the GitHub release page using the `get_url` module.
7. Start the Docker daemon using the `systemd` module.
8. Copy the `docker-compose.yml` file from the source directory to the target directory using the `copy` module.
9. Run the Docker Compose project using the `docker_compose` module.
10. check the screenshot for running application.

