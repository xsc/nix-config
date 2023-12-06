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

Adapt the file `user.nix` with your current data.

### 5. Install configuration

First-time installations require you to move the current `/etc/nix/nix.conf` out of the way.

```sh
[ -f /etc/nix/nix.conf ] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

If you're using a git repository, only files in the working tree will be copied
to the [Nix Store](https://zero-to-nix.com/concepts/nix-store). So it's
imperative you run `git add .`.

Then, run `bin/build`, which wraps a few Nix commands to build and deploy a new
Nix generation.

```sh
chmod +x bin/darwin-build && chmod +x bin/build && bin/build
```
