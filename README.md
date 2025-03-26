# dotfiles

## Documentation

- [Quickly get set up with these dotfiles](#quickly-get-set-up-with-these-dotfiles)
- [Extra WSL 1 and WSL 2 steps](#extra-wsl-2-steps)
    - [Extra WSL 2 configurations](#extra-wsl-2-configurations)
    - [Extra 1Password configurations](#extra-1password-configurations)
- [Did you install everything successfully?](#did-you-install-everything-successfully)
- [FAQ](#faq)
    - [How to personalize these dotfiles?](#how-to-personalize-these-dotfiles)

### Quickly Get Set Up with These Dotfiles

There's an `./install` script you can run to automate installing everything.
That includes installing system packages such as tmux, zsh, etc. and
configuring a number of tools in your home directory.

It even handles cloning down this repo. You'll get a chance to pick the clone
location in the script as well as view and / or change any system packages that
get installed.

The install script is optimized for:

- Ubuntu 22.04 LTS+ (native or WSL)
- Debian 11+ (Debian 10 will work if you enable backports for tmux)

It will still work with other distros of Linux if you skip installing system
packages (more details are below).

**You can download and run the install script with this 1 liner:**

```sh
bash <(curl -sS https://raw.githubusercontent.com/sassdavid/dotfiles/main/install)
```

*If you're not comfortable blindly running a script on the internet, that's no
problem. You can view the [install
script](https://github.com/sassdavid/dotfiles/blob/main/install) to see exactly
what it does. Each section is commented. Sudo is only used to install system
packages. Alternatively you can look around this repo and reference the config
files directly without using any script.*

**You can also run the script without installing system packages:**

```sh
bash <(curl -sS https://raw.githubusercontent.com/sassdavid/dotfiles/main/install) --skip-system-packages
```

That above could be useful if you're using a non-Debian based distro of Linux,
in which case you'll need to install the [dependent system
packages](https://github.com/sassdavid/dotfiles/blob/main/install) on your own
beforehand. Besides that, everything else is supported since it's only dealing
with files in your home directory.

My set up targets zsh 5.0+ and tmux 3.0+. As long as you can meet
those requirements you're good to go.

### Extra WSL 2 steps

#### Extra WSL 2 configurations

In addition to the Linux side of things, there's a few config files that I have
in various directories of this dotfiles repo. These have long Windows paths.

It would be expected that you copy those over to your system while replacing
"sassd" with your Windows user name if you want to use those things, such as my
Microsoft Terminal `settings.json` file and others. Some of the paths may
also contain unique IDs too, so adjust them as needed on your end.

Some of these configs expect that you have certain programs or tools installed
on Windows.

Pay very close attention to the `c/Users/sassd/.wslconfig` file because it has
values in there that you will very likely want to change before using it.

> Add protection against WSL 2 using all your memory
> At the time of writing this commit there's a pending issue for WSL 2
> where it happily eats all of your memory over time.
>
>Details are at: [microsoft/WSL#4166](https://github.com/microsoft/WSL/issues/4166)
>
>I ran into this issue naturally starting and stopping Docker containers
> for half a day while doing my normal work. Before I knew it, the VM was
> using 11GB of memory (the default is to use 80% of your RAM).
>
>I'm not going to bikeshed on this by making a cronjob run the alias
> command on a schedule because I imagine this will be fixed in a hotfix
> at some point in the future.
>
>Just be mindful of this if you notice that the Vmmem process is using a
> ton of memory.
>
> [This is specific to WSL 2.](https://github.com/sassdavid/dotfiles/blob/main/.config/zsh/.aliases#L48) If the WSL 2 VM
> goes rogue and decides not to free up memory, this
> command will free
> your
> memory after about 20-30 seconds. Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643

Also, you should reboot to activate your `/etc/wsl.conf` file (the install
script created this). That will be necessary if you want to access your mounted
drives at `/c` or `/d` instead of `/mnt/c` or `/mnt/d`.

#### Extra 1Password configurations

If you want to use the 1Password SSH agent integration with WSL 2, you'll need to set up a few things.

First, you need to set up the 1Password SSH integration. You can find some details
at [1Password SSH agent integration](https://developer.1password.com/docs/ssh/get-started).

For more details especially for WSL 2,see
the [1Password SSH agent WSL 2 integration](https://developer.1password.com/docs/ssh/integrations/wsl) documentation.

I have configured a few aliases in my `.aliases` and `.zshrc` files to make it easier to use the 1Password SSH agent
integration:

- In my `.aliases` file, I have aliases for `ssh` and `ssh-add`.
- In my `.zshrc` file, I set `GIT_SSH_COMMAND` and `GIT_SSH` environment variables.
- In my `~/.gitconfig` file, I set `sshCommand`.

The above settings allow me to use the 1Password SSH agent integration with Git in WSL 2, pointing to my Windows OpenSSH
client (`/c/Program Files/OpenSSH/ssh.exe` and `/c/Program Files/OpenSSH/ssh-add.exe`).

### Did you install everything successfully?

Nice!

If you haven't done so already please close your terminal and open a new
one, then follow the step(s) below:

1. **Configure your git name and email**

   One of the things the install script did was copy a git ignored git config file
   into your home directory. You're meant to put in your name and email address so
   that your details are used when you make git commits.

   ```sh
   nvim ~/.gitconfig.user.personal
   nvim ~/.gitconfig.user.work
   nvim ~/.gitconfig.user.bitbucket
   ```

2. **(Optional) confirm that a few things work**

   ```sh
   # Check to make sure git is configured with your name and email.
   git config --list
   
   # Sanity check to see if you can run some of the tools we installed.
   tmux -V
   terraform -v
   kubectl version --client --output=yaml
   ```

Before you start customizing certain config files, take a look at the
[personalization question in the FAQ](#how-to-personalize-these-dotfiles).

### FAQ

#### How to personalize these dotfiles?

Chances are you'll want to personalize some of these files, such as various settings. Since this is a git repo you can
always do a `git pull` to get the
most up to date copy of these dotfiles, but then you may find yourself
clobbering over your own personal changes.

Since we're using git here, we have a few reasonable options.

For example, from within this dotfiles git repo you can run `git checkout -b
personalized` and now you are free to make whatever changes that you want on
your custom branch. When it comes time to pull down future updates you can run
a `git pull origin master` and then `git rebase master` to integrate any
updates into your branch.

Another option is to fork this repo and use that, then periodically pull and
merge updates. It's really up to you.

## Acknowledgements

This project has been developed based on the foundational work provided by
the [dotfiles repository](https://github.com/nickjj/dotfiles), originally created
by [Nick Janetakis](https://github.com/nickjj). I would like to acknowledge and thank Nick for making his repository
publicly available, which has greatly assisted in the development of my own version.

I am grateful for the opportunity to utilize such a well-structured framework as a starting point for my project. Thank
you to Nick and all contributors to the original repository for their valuable work.
