# This file runs once at login.

# Set up a few standard directories based on:
#   https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# Add all local binaries to the system path.
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.local/bin/private"

# Add go path to the system path.
export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"

# Set mise environment variables
export MISE_EXPERIMENTAL="true"
export MISE_FETCH_REMOTE_VERSIONS_TIMEOUT="60s"
export MISE_HTTP_TIMEOUT="60"
export MISE_GO_SKIP_CHECKSUM="true"
export MISE_LEGACY_VERSION_FILE="false"
export MISE_NOT_FOUND_AUTO_INSTALL="false"
export MISE_PARANOID="false"
export MISE_DISABLE_DEFAULT_SHORTHANDS="true"
export MISE_USE_VERSIONS_HOST="false"
export ASDF_HASHICORP_SKIP_VERIFY="true"

# Set rust-lang environment variables
export RUST_LANG_HOME="${HOME}/rust-lang"
export RUSTUP_HOME="${RUST_LANG_HOME}/.rustup"
export CARGO_HOME="${RUST_LANG_HOME}/.cargo"

export PATH="${PATH}:${CARGO_HOME}/bin"

# Set mongodb stuffs related enviornment variables
export MONGOSH_HOME="${HOME}/.local/bin/mongosh/bin"
export MONGODB_TOOLS_HOME="${HOME}/.local/bin/mongodb-tools/bin"
export ATLAS_CLI_HOME="${HOME}/.local/bin/atlas-cli/bin"

export PATH="${PATH}:${MONGOSH_HOME}:${MONGODB_TOOLS_HOME}:${ATLAS_CLI_HOME}"

# Default programs to run.
export EDITOR="vim"

# Add colors to the less and man commands.
export LESS=-R
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESS_TERMCAP_mb=$'\e[1;31mm'    # begin blinking
export LESS_TERMCAP_md=$'\e[1;36m'     # begin bold
export LESS_TERMCAP_us=$'\e[1;332m'    # begin underline
export LESS_TERMCAP_so=$'\e[1;44;33m'  # begin standout-mode - info box
export LESS_TERMCAP_me=$'\e[0m'        # end mode
export LESS_TERMCAP_ue=$'\e[0m'        # end underline
export LESS_TERMCAP_se=$'\e[0m'        # end standout-mode
