# Change Log

## 0.2.0 (2017-09-03)
**Updated**  
- `v-install-wp [site]`  
    - Automatically create a new database rather than sharing an existing one.
    - Automatically generate:
        - database name
        - database user
        - database password

**Removed**  
- `v-remove-wp`
    - Since database is not shared, there is no need to remove tables.

    

## 0.1.0 (2017-08-30)
- `v-install-wp [site] [database] [db_user] [password]`  
    - Installs WordPress into the specified site.  
    - Uses an existing databases.  
    - Automatically generates a table prefix.

- `v-remove-wp [site]`  
    - Removes tables from the databases - since one database hosts multiple installations.  