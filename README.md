# getnodebin

Very simple script to install node binary distributions on linux systems.
It doesn't mess with your environment at all. All it does is download node binaries where you tell it and switches between them.

Super simple and lightweight alternative for nvm.

## Requirements

Linux with standard tooling (wget).

Tested on debian. Not tested on Mac at all and likely won't work.

## Installation

Just clone this repo somewhere.

```bash
mkdir -p ~/local
cd ~/local
git clone https://github.com/panta82/getnodebin.git
cd getnodebin
# execute commands described below
```

## Usage examples

```bash
./install 10.0.0          # install 10.0.0 to ~/local
./install LTS             # install whatever is the current LTS to ~/local
sudo ./install current    # install whatever is the current stable version to /usr/bin/local
./install lts ~/test      # install current LTS to ~/test

./versions                # list all installed versions
./activate 8.11.1         # activate previously installed version 8.11.1
```

Note that in order for unprivileged installations to work, you'll need to configure your PATH to include `~/local/bin`.
If you are not sure what this means, open `~/.bashrc` in your editor and add the following to the end of it:

```bash
PATH="$HOME/local/bin:$PATH"
```

Then restart your terminal.

## Stability

Pretty stable so far. This is just a personal tool though, so...

### USE AT YOUR OWN RISK!

## License

MIT
