# dotfiles

This readme along with an install script will help you get everything running
in a few minutes. It contains a bunch of configuration for the tools I
use.

## 🧬 Who Is This For?

This project is more than a few config files. **In 1 command and ~5 minutes it
can take a new or existing system and install / configure a number of tools
aimed at developers**. It will prompt or warn you if it's doing a destructive
action like overwriting a config file. You can run the idempotent [install
script](./install) multiple times to stay up to date.

There's too many things to list here but here's the highlights:

- Set you up for success with command line tools and workflows
  - Tweak out your shell (zsh)
  - Set up tmux
  - Fully configure Neovim
  - Install modern CLI tools
  - Install programming languages

**It supports Arch Linux, Debian, Ubuntu and macOS. It also supports WSL 2 for
any supported Linux distro.**

*If you don't plan to run the install script that's ok, everything is MIT
licensed. The code is here to look at.*

## 🧾 Documentation

- [Themes](#-themes)
- [Quickly Get Set Up](#-quickly-get-set-up)
- [FAQ](#-faq)
  - [How to personalize these dotfiles?](#how-to-personalize-these-dotfiles)
  - [How to theme custom apps?](#how-to-theme-custom-apps)
  - [How to add custom themes?](#how-to-add-custom-themes)
- [About the Author](#-about-the-author)

## 🎨 Themes

Since these dotfiles are constantly evolving and I tend to reference them in
videos, blog posts and other places I thought it would be a good idea to
include screenshots in 1 spot.

### Tokyonight Moon

todo

### Gruvbox Dark (Medium)

todo

I prefer using themes that have good contrast ratios and are clear to see in
video recordings. These dotfiles currently support easily switching between
both themes but you can use any theme you'd like.

If you want to see icons you'll need a "nerd font". There's hundreds of them on
<https://www.nerdfonts.com/font-downloads> with previews. I personally use
JetBrainsMono NF which these dotfiles install for you.

### Setting a theme

These dotfiles include a `dot-theme-set` script that you can run from your
terminal to set your theme to any of the themes listed above.

You can look in the [themes/](./themes/) directory to see which apps are themed.

If you don't like the included themes that's no problem. You can [add custom
themes](#how-to-add-custom-themes).

After installing these dotfiles you can switch themes with:

```sh
# Get a full list of themes by running: dot-theme-set --list
#
# Optionally you can skip adding a theme name and a random theme will be chosen.
dot-theme-set THEME_NAME
```

When switching themes most apps will update automatically, but if you have a
bunch of shells already open you can run the `SZ` (source zsh) alias to source new theme related configs.

*Not all terminals are supported, if yours didn't change then check [theming
custom apps](#how-to-theme-custom-apps).*

## ✨ Quickly Get Set Up

There's an `./install` script you can run to automate installing everything.
That includes installing system packages such as zsh, tmux, Neovim, etc. and
configuring a number of tools in your home directory.

It even handles cloning down this repo. You'll get a chance to pick the clone
location when running the script as well as view and / or change any system
packages that get installed before your system is modified.

### 🌱 On a fresh system?

We're in a catch-22 where this install script will set everything up for you
but to download and run the script to completion a few things need to exist on
your system first.

**It comes down to needing these packages, you can skip this step if you have
them**:

- `curl` to download the install script
- `bash 4+` since the install script uses modern Bash features
  - This is only related to macOS, all supported Linux distros are good to go out of the box

Here's 1 liners you can copy / paste once to meet the above requirements on all
supported platforms:

#### Arch Linux

```sh
# You can run this as root.
pacman -Syu --noconfirm curl
```

#### Debian / Ubuntu

```sh
# You can run this as root.
apt-get update && apt-get install -y curl
```

#### macOS

If you run `bash --version` and it says you're using Bash 3.X please follow
the instructions below:

```sh
# Curl is installed by default but bash needs to be upgraded, we can do that
# by brew installing bash. Once this command completes you can run the install
# script in the same terminal where you ran this command. Before running the
# install script `bash --version` should return a version > 3.X.

# OPTION 1: Using Apple silicon?
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && eval "$(/opt/homebrew/bin/brew shellenv)" \
  && brew install bash \
  && bash

# OPTION 2: Using an Intel CPU?
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && eval "$(/usr/local/bin/brew shellenv)" \
  && brew install bash \
  && bash

# The colors will look bad with the default macOS Terminal app. These dotfiles install: https://ghostty.org/
```

### ⚡️ Install script

**You can download and run the install script with this 1 liner:**

```sh
BOOTSTRAP=1 bash <(curl -sS https://raw.githubusercontent.com/sassdavid/dotfiles/main/install)
```

*If you're not comfortable blindly running a script on the internet, that's no
problem. You can view the [install script](./install) to see exactly what it
does. The bottom of the file is a good place to start. Sudo is only used to
install system packages. Alternatively you can look around this repo and
reference the config files directly without using any script.*

*Please understand if you run this script on your existing system and hit yes
to some of the prompts your config files will get overwritten. Always have good
backups!*

**You can also run the script without installing system packages:**

```sh
BOOTSTRAP=1 bash <(curl -sS https://raw.githubusercontent.com/sassdavid/dotfiles/main/install) --skip-system-packages
```

The above can be useful if you're using an unsupported distro of Linux in which
case you'll need to install the [dependent system packages](./install) on your
own beforehand. Besides that, everything else is supported since it's only
dealing with files in your home directory.

This set up targets zsh 5.0+, tmux 3.1+ and Neovim v0.11+. As long as you can
meet those requirements you're good to go. The install script will take care
of installing these for you unless you've skipped system packages.

🐳 **Try it in Docker without modifying your system:**

```sh
# Start a Debian container, we're passing IN_CONTAINER to be explicit we're in Docker.
docker container run --rm -it -e "IN_CONTAINER=1" -v "${PWD}:/app" -w /app debian:stable-slim bash

# Copy / paste all 3 lines into the container's prompt and run it.
#
# Since we can't open a new terminal in a container we'll need to manually
# launch zsh and source a few files. That's what the last line is doing.
apt-get update && apt-get install -y curl \
  && bash <(curl -sS https://raw.githubusercontent.com/sassdavid/dotfiles/main/install) \
  && zsh -c ". ~/.config/zsh/.zprofile && . ~/.config/zsh/.zshrc; zsh -i"
```

*Keep in mind with the Docker set up, unless your terminal is already
configured to use Tokyonight Moon then the colors may look off. That's because
your local terminal's config will not get automatically updated.*

**🚀 Keeping things up to date and tinkering**

Once you've installed these dotfiles you can run `cd "${DOTFILES_PATH}"` to
manage them.

Here's a few handy commands, you can run `./install --help` to see all of them:

- `./install`
  - Run the install script based on the local copy of your dotfiles
  - Keeps your system up to date or apply local changes
- `./install --skip-system-packages`
  - Run the install script like above but skip installing or updating packages
  - Helps regenerate symlinks, configs and everything else without modifying packages
- `./install --pull`
  - Pulls in the latest remote commits but doesn't run the install script
  - Lets you review any changes locally before the install script runs
- `./install --update`
  - Pulls in the latest remote commits and runs the install script
  - Shortcut to pull and run the install script together
- `./install --diff-config`
  - Compare your local `install-config` to the local `install-config.example`
  - Helps keep your git ignored `install-config` in sync with new options
- `./install --diff`
  - Compare what you have locally vs the latest remote commits
  - See what will change if you `--update` without modifying your git tree
- `./install --new-commits`
  - Show new remote commits that do not exist locally
  - Present a quick list of what's available to pull locally
- `./install --changelog`
  - Show all remote commits
  - Present a quick list of all commits to see what has changed

*There's also a `LOCAL=1` environment variable you can set when bootstrapping
or running the other install commands. This is handy for doing local tests
in containers without needing to commit, push and pull changes.*

### 🛠 Make it your own

If you just ran the install script and haven't done so already please close
your terminal and open a new one.

There's a few ways to customize these dotfiles ranging from forking this repo
to customizing [install-config](./install-config.example) which is git ignored.
The second option lets you adjust which packages and programming languages get
installed as well as configure a number of other things.

Before you start customizing other files, please take a look at the
[personalization question in the FAQ](#how-to-personalize-these-dotfiles).

### 🪟 Extra WSL 2 steps

In addition to the Linux side of things, there's a few config files that I have
in various directories of this dotfiles repo. These have long Windows paths and
are in the `mnt/c/` directory.

It would be expected that you copy those over to your system while replacing
"sassd" with your Windows user name if you want to use those things.  The
Microsoft Terminal config will automatically be copied over to your user's
path.

It's expected you're running WSL 2 with WSLg support to get clipboard sharing
to work between Windows and WSL 2. You can run `wsl.exe --version` from WSL 2
to check if WSLg is listed. Chances are you have it since it has been supported
since 2022! All of this should "just work". If clipboard sharing isn't working,
check your `.wslconfig` file in your Windows user's directory and make sure
`guiApplications=false` isn't set.

*If you see `^M` characters when pasting into Neovim, that's a Windows line
ending. That's because WSLg's clipboard feature doesn't seem to handle this
automatically. If you paste with `CTRL+SHIFT+v` instead of `p` it'll be ok. I
guess the Microsoft Terminal does extra processing to fix it for you.*

Pay very close attention to the `mnt/c/Users/sassd/.wslconfig` file because it
has values in there that you will very likely want to change before using it.

> [!TIP]
> This is a quote from one of Nick's message to a commit
>
> Add protection against WSL 2 using all your memory
>
> At the time of writing this commit there's a pending issue for WSL 2 where it happily eats all of your memory over time.
>
> Details are at: [microsoft/WSL#4166](https://github.com/microsoft/WSL/issues/4166)
>
> I ran into this issue naturally starting and stopping Docker containers for half a day while doing my normal work. Before I knew it, the VM was
> using 11GB of memory (the default is to use 80% of your RAM).
>
> I'm not going to bikeshed on this by making a cronjob run the alias command on a schedule because I imagine this will be fixed in a hotfix at some
> point in the future.
>
> Just be mindful of this if you notice that the Vmmem process is using a ton of memory.

Also, you should reboot or from PowerShell run `wsl --shutdown` and then
re-open your WSL instance to activate your `/etc/wsl.conf` file (the install
script created this).

You may have noticed I don't enable systemd within WSL 2. That is on purpose.
I've found it delays opening WSL 2 by ~10-15 seconds and also any systemd
services were delayed from starting by ~2 minutes.

#### 1Password SSH Agent Integration

To use the 1Password SSH agent with WSL 2, you need to configure your shell to use the Windows OpenSSH client. This setup allows Git and SSH commands
in WSL to work with 1Password.

1. Follow the official setup guides:
    - [Get started with 1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/)
    - [WSL 2 integration details](https://developer.1password.com/docs/ssh/integrations/wsl/)
2. Shell Configuration:
    - In your `~/.config/zsh/.zprofile.local`:
      ```sh
      export GIT_SSH="/mnt/c/Program\ Files/OpenSSH/ssh.exe"
      export GIT_SSH_COMMAND="/mnt/c/Program\ Files/OpenSSH/ssh.exe"
      ```
    - In your `~/.config/zsh/.aliases.local`:
      ```sh
      alias ssh="/mnt/c/Program\ Files/OpenSSH/ssh.exe"
      alias ssh-add="/mnt/c/Program\ Files/OpenSSH/ssh-add.exe"
      alias scp="/mnt/c/Program\ Files/OpenSSH/scp.exe"
      
      alias ssh2="/usr/bin/ssh"  # fallback to WSL SSH if needed
      ```
3. Git Configuration:
   ```
   [core]
   sshCommand = '/c/Program Files/OpenSSH/ssh.exe'
   ```

**These settings ensure that SSH and Git commands inside WSL 2 use the Windows-side OpenSSH client, which is required for 1Password's SSH agent to
function correctly.**

## 🔍 FAQ

### How to personalize these dotfiles?

The [install-config](./install-config.example) lets you customize a few things
but chances are you'll want to personalize more than what's there, such as
various Neovim settings. Since this is a git repo you can always do a `git
pull` to get the most up to date copy of these dotfiles, but then you may find
yourself clobbering over your own personal changes.

Since we're using git here, we have a few reasonable options.

For example, from within this dotfiles git repo you can run `git checkout -b
personalized` and now you are free to make whatever changes that you want on
your custom branch. When it comes time to pull down future updates you can run
a `git pull origin main` and then `git rebase main` to integrate any
updates into your branch.

Another option is to fork this repo and use that, then periodically pull and
merge updates. It's really up to you. By default these dotfiles will add an
`upstream` git remote that points to this repo.

### How to theme custom apps?

You'd add its theme file to each theme in [themes/](./themes) and update the
[install](./install) script's `set_theme` function to symlink the config. If
your app has no dedicated config file, you can copy what I did for the
Microsoft Terminal in `set_theme`.

Happy to assist in your issue / PR to answer questions if you want to
contribute your change.

### How to add custom themes?

1. Locate the [themes/](./themes) directory in this repo
2. Copy one of the existing themes' directory
3. Rename your directory, this will be your theme's name
4. Adjust all of the colors as you see fit

Switch to it by running `dot-theme-set NEW_THEME_NAME` and use the name you
picked in step 3.

If you added a theme with good contrast ratios please open a pull request to
get it added to this project.

## 👀 About the Author

I'm a Developer and DevOps Engineer with a degree in Computer Engineering, I am passionate about leveraging my technical expertise to design,
optimize, and maintain robust infrastructure solutions that drive impactful outcomes. You can read about everything I've learned along the way on my
site at
[https://davidsass.eu](https://davidsass.eu/).

## 🤝 Acknowledgements

This project has been developed based on the foundational work provided by
the [dotfiles repository](https://github.com/nickjj/dotfiles), originally created
by [Nick Janetakis](https://github.com/nickjj). I would like to acknowledge and thank Nick for making his repository
publicly available, which has greatly assisted in the development of my own version.

I am grateful for the opportunity to utilize such a well-structured framework as a starting point for my project. Thank
you to Nick and all contributors to the original repository for their valuable work.
