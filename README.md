# Useful Scripts


## Upload
This script is used for quick uploading and sharing of files.
It prints a QR code of the share link to allow for quick and easy sharing to a phone

### Usage
```sh
upload <file>
```

### Dependencies
- curl
- qrencode

### Installation
```sh
sudo apt install curl qrencode
sudo wget -O /usr/local/bin/upload https://git.woodburn.au/nathanwoodburn/scripts/raw/branch/main/upload
sudo chmod +x /usr/local/bin/upload
```

## Copy
This script is used for copying the contents of a file to the clipboard.

### Usage
```sh
copy <file>
```

### Dependencies
- xclip

### Installation
```sh
sudo apt install xclip
sudo wget -O /usr/local/bin/copy https://git.woodburn.au/nathanwoodburn/scripts/raw/branch/main/copy
sudo chmod +x /usr/local/bin/copy
```