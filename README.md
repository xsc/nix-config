# nix-config

[Source](https://github.com/dustinlyons/nixos-config)

## Installation

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install Nix

Thank you for the installer, [Determinate Systems](https://determinate.systems/)!

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. Checkout this Repository

Using whatever method you want, e.g. via a Nix shell that exposes `git`:

```sh
nix shell nixpkgs#git
git clone git@github.com:xsc/nix-config.git
```

### 4. Apply your current user info

Run this script to replace stub values with your username, full name, and email.

```sh
chmod +x bin/apply && bin/apply
```

### 5. Decide what packages to install

You can search for packages on the [official NixOS website](https://search.nixos.org/packages).

**Review these files**

- `darwin/casks`
- `darwin/packages`
- `darwin/home-manager`
- `shared/packages`

### 6. Optional: Setup secrets

If you are using the starter with secrets, there are a few additional steps.

#### 6a. Create a private Github repo to hold your secrets

In Github, create a private [`nix-secrets`](https://github.com/dustinlyons/nix-secrets-example) repository. You'll enter this name during installation.

#### 6b. Install keys

Before generating your first build, these keys must exist in your `~/.ssh` directory. Don't worry, we provide a few commands to help you.

| Key Name          | Platform      | Description                           |
| ----------------- | ------------- | ------------------------------------- |
| id_ed25519        | MacOS / NixOS | Used to download secrets from Github. |
| id_ed25519_agenix | MacOS / NixOS | Used to encrypt and decrypt secrets.  |

You must one run of these commands:

##### Copy keys from USB drive

This script auto-detects a USB drive connected to the current system.

> Keys must be named `id_ed25519` and `id_ed25519_agenix`.

```sh
nix run github:dustinlyons/nixos-config#copyKeys
```

##### Create new keys

```sh
nix run github:dustinlyons/nixos-config#createKeys
```

##### Check existing keys

If you're rolling your own, just check they are installed correctly.

```sh
nix run github:dustinlyons/nixos-config#checkKeys
```

### 7. Install configuration

First-time installations require you to move the current `/etc/nix/nix.conf` out of the way.

```sh
[ -f /etc/nix/nix.conf ] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

If you're using a git repository, only files in the working tree will be copied to the [Nix Store](https://zero-to-nix.com/concepts/nix-store).

So it's imperative you run `git add .`.

Then, run `bin/build`, which wraps a few Nix commands to build and deploy a new Nix generation.

```sh
chmod +x bin/darwin-build && chmod +x bin/build && bin/build
```
