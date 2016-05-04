# getnodebin

Very simple script to install node binary distributions on linux systems. 

## Requirements

Linux with standard tooling (wget).

Tested on debian.

## Usage

```
./install.sh <version> <target>
```

Eg.

```
./install.sh 6.0.0 /home/user/local
```

`<target>` defaults to `/usr/local`.

All downloaded versions can be found under `<target>/node_install` (eg `/usr/local/node_install`).
At any time, you can go there and reinstall any of the downoaded versions by running the `./deploy.sh`
script inside appropriate directory.

If you want multiple node versions, and don't want to mess with your `PATH` variable,
this is a reasonable way to do it. 

## Stability

I use this script personally, but it's not all that well tested at the moment. 
It's doing a lot of `rm`-s, so there's definitely a risk of data or time loss.

### USE AT YOUR OWN RISK!

## License

MIT