# Kamal Makefile

This project provides a setup for deploying your Ruby on Rails application using Kamal. It includes a `Makefile` for common commands, a Ruby script for provisioning servers, and a `deploy.yml` template for Kamal configuration.

## Table of Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Provisioning Servers](#provisioning-servers)
- [Deployment](#deployment)
- [Available Makefile Commands](#available-makefile-commands)

## Requirements

- SSH access to the server with keys authentication.
- Ruby installed on your local machine.
- Kamal gem installed.

## Setup

1. Clone the repository:
```shell
git clone https://github.com/yourusername/yourproject.git
cd yourproject
```
2. Install dependencies:
```shell
bundle install
```
3. Customize the deploy.yml file located in config/ directory with your server and application details.

## Provisioning Servers

Use the provided provision Ruby script to prepare your servers for Kamal deployment.

1. Ensure your SSH keys are added:
```shell
ssh-add ~/path/to/your/ssh/key
```
2. Make the provision script executable:
```shell
chmod +x provision
```
3. Run the provision script:
```shell
./provision
```
This script will:

    Install essential packages.
    Add swap space.
    Prepare storage and Let's Encrypt directories.
    Install and configure Docker.
    Install and run fail2ban.
    Configure the firewall.

## Deployment

After provisioning, you can deploy your application using the Makefile commands.
Here some examples:
1. Edit credentials for the desired environment:
```shell
make credentials ENV=production
```
2. Show Kamal commands menu:
```shell
make kamal ENV=production
```
In order to executre the kamal commands in the menu, the environment files (deploy.environment.yml, env.environment.erb)
must exist otherwise commands will fail.

## Available Makefile Commands

The Makefile includes several commands to streamline your workflow:

    make credentials ENV=your_env - Edit Rails credentials for the specified environment.
    make rubocop - Run the Rubocop static code analyzer.
    make kamal ENV=your_env - Set up Kamal for the specified environment with options to provision components, setup environment, generate and push env file, build and deploy, manage accessories, trail application logs, and run Rails console.
    make kamal ENV=production ACS=your_accessory_name - Manage remote accessories.

## Conclusion

This setup aims to simplify the deployment process using Kamal. Customize the provided files as needed and follow the steps to provision your servers and deploy your application effectively.

Feel free to customize the placeholders (like `yourusername`, `yourproject`, `your_service`, `your_image_name`, `your_domain`, etc.) with the actual details of your project.
