# Vesta WordPress Helper v 0.2.0

## Synopsis

A bash script that will download WordPress and configure permissions in the desired website's directory.

## Requirements
[VestaCP](https://vestacp.com)

## Setup

```
git clone https://github.com/jaketreacher/vestawphelper.git
cd vestawphelper
sudo ./setup.sh
```

This will give the command:  
`v-install-wp`  

To remove, simply run `sudo ./setup.sh --remove`  
Or, delete the file from `/usr/local/sbin/v-install-wp` 

## Usage

```
usage: sudo v-install-wp WEBSITE [--no-backup] [--help]

Vesta WP Helper: Installer

positional arguments:
  WEBSITE               The site you want to install WordPress.

optional arguments:
  --no-backup           Delete public_html rather than making a backup.
  --help                Display this message.
``` 

### Example
#### Installation
1. Login to VestaCP.  
2. Create a new user `user0`.  
3. Create a new website `mysite.com` for `user0`.  
4. SSH into the server.  
5. Run the command `sudo v-install-wp mysite.com --no-backup`. 
    - This will create the following:
        - Database: `user0_mysite.com`
        - User: `user0_[random]` _(4 characters)_
        - Password: `[random]` _(10 characters)_
6. Open `mysite.com` in your browser to create an admin for WordPress.  

#### Removal
1. Login to VestaCP.  
2. Remove the site `mysite.com`  
3. Remove the database `user0_mysite.com`.

## License

Copyright (c) Jake Treacher. All rights reserved.  
Licensed under the [MIT](https://github.com/jaketreacher/vestawphelper/blob/master/LICENSE.txt) License.  
