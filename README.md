# metatrader-setup
A metatrader installer on linux based on ansible

## Getting started

```bash
$ bash <(curl -fsSL https://raw.githubusercontent.com/Sitemaboite/metatrader-setup/refs/heads/main/bootstrap.sh)
```

1. This will prompt you for a BECOME password : it is the password you usually use to install software on your computer (sudo password).
This will install locally all necessry tools to provision local or distant equipment.


2. You will be prompted for a github token. You can create one [here](https://github.com/settings/tokens) with the following permissions: 
- repo

3. You will enter a menu to pick a repository to be synced.
