# Dotfiles & co

This repo contains my various dotfiles and configurations, meant to be deployed with ansible.

It evolved organically frow various sources, and many elements here are unreasonably complicated, or not considered good practice even by me.

Still, feel free to have a look around !

## Supported operating systems

Currently supported :

* Fedora

Previously supported, should likely still mostly work with minor tweaks (especially installed packages) :

* Ubuntu
* Manjaro (Arch)

Previously partially supported :

* MacOS (cf roles/deploy/tasks/desktop_mac.yml for details)

## Deployment instructions

### Ansible

Install homebrew

Install `pipx`

```
brew install pipx
pipx ensurepath
sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
```

Install ansible `pipx install --include-deps ansible`

* If you're not me, you're gonna have to at least change the inventory.yml file, and probably quite a bit in host_vars/group_vars
* Install ansible, likely the latest version with your OS package manager should be fine
* `ansible-playbook deploy.yml`
* RELEASE_BLOCKER where to clone the repo (since one of the first steps is to copy its content to ~/.globalrc)
* RELEASE_BLOCKER document ansible_hostname
* RELEASE_BLOCKER document have_root

### Manual

#### generic
- 1Password settings > Developer : Setup SSH Agent
- PyCharm settings > Backup and Sync : Enable Backup and Sync

#### macOS
- Finder settings > Advanced : Show all filename extensions
- Finder Menu bar > View : Show path bar, Show status bar
- iTerm2 settings > Profile > Terminal : Unlimited scroll back
- iTerm2 settings > Profile > Colors :
    - Foreground: c7c7c7
    - Background: 000000
    - Cursor: c7c7c7
    - Bold: ffffff
- iTerm2 settings > Profile > Advanced : set Semantic History to Run Command and set value to `/Applications/PyCharm.app/Contents/MacOS/pycharm --line \2 \1`
- iTerm2 settings > Profile > Keys > Key Mapping : Import preset > import files/antoine.itermkeymap
- System settings > Privacy and Security > Allow applications downloaded from anywhere
