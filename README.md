# metatrader-setup
A metatrader installer on linux based on ansible

## Getting started

Must be run once on your computer to install ansible and other tools.
Bootstrap the installation by running the following command in your terminal:
```bash
$ bash <(curl -fsSL https://raw.githubusercontent.com/Sitemaboite/metatrader-setup/refs/heads/main/bootstrap.sh)
```
This command will make sure all custom development are up to date with source.


1. This will prompt you for a BECOME password : it is the password you usually use to install software on your computer (sudo password).
This will install locally all necessry tools to provision local or distant equipment.


2. You will be prompted for a github token. You can create one [here](https://github.com/settings/tokens) with the following permissions: 
- repo

3. You will enter a menu to pick a repository to be synced.

To run the playbook, you can use the following command:
```bash
$ /opt/metatrader-setup/launch.sh
```

You can also launch manually the playbook with the following command:
```bash
$ ansible-playbook /opt/metatrader-setup/setup.yml # For the full setup
$ ansible-playbook /opt/metatrader-setup/gh_setup.yml # For the sync only
```
