# Vesta WordPress Helper

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

This will give the commands:  
`v-install-wp`  
`v-remove-wp`  

To remove, simply run `sudo ./setup.sh --remove`  

## Usage Examples

### Installation
`sudo v-install-wp [site] [database] [db_user] [password]`

In VestaCP, add a new website `site.com`.  
Create a new database, or use an exiting one.  
You will require the following details:  
1. Website name: `site.com`
2. Database name: `sitecom_default`
3. Database user: `sitecom_user`
4. Database password: `p4assw0rd1`

`sudo v-install-wp site.com sitecom_default sitecom_user p4assw0rd1`

### Removal
_Note: This will remove the site with a specified table prefix from the database. This is only necessary if you have multiple sites using one database. If not, you can simply delete the database from within
 VestaCP._

`sudo v-remove-wp [site]`  
Will search for the site specified, and read `wp-config.php` to determine the database and table prefix. If not found, it will prompt the user to specify these details.  

It will generate an SQL query to drop the matching tables, and prompt the user for confirmation before continuing:
```
user@ubuntu:~/vestahelper$ sudo v-remove-wp site.com
Searching for site
Reading database and prefix
Prefix: wp_G50G_
Database: sitecom_default
Generating drop sequence
====================
Commands to execute:
====================
DROP TABLE sitecom_default.wp_G50G_commentmeta;
DROP TABLE sitecom_default.wp_G50G_comments;
DROP TABLE sitecom_default.wp_G50G_links;
DROP TABLE sitecom_default.wp_G50G_options;
DROP TABLE sitecom_default.wp_G50G_postmeta;
DROP TABLE sitecom_default.wp_G50G_posts;
DROP TABLE sitecom_default.wp_G50G_term_relationships;
DROP TABLE sitecom_default.wp_G50G_term_taxonomy;
DROP TABLE sitecom_default.wp_G50G_termmeta;
DROP TABLE sitecom_default.wp_G50G_terms;
DROP TABLE sitecom_default.wp_G50G_usermeta;
DROP TABLE sitecom_default.wp_G50G_users;
--------------------
Continue? [Y|n]: y

```
This will not make any changes to `public_html`.  

## License

[MIT](https://github.com/jaketreacher/vestawphelper/blob/master/LICENSE.md)