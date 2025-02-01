# dotfiles
This repository neatly collects my dotfiles and setup scripts in a single place. It is primarily meant for systems running >Linux Mint 22, my distribution of choice.

## Seup script
Within the `.scripts` folder there is a file called "setup.sh" that can be runned to automatically install packages and dotfiles.

```sh
# Get install script
$ wget https://github.com/TheWilley/dotfiles/blob/master/.scripts/setup.sh

# Make script executable
$ chmod +x setup.sh

# Run script - it's important that "sudo" is used
sudo bash setup.sh
```
