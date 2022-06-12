## Reset Password of MySQL
1. Stop mysql:
```
sudo systemctl stop mysqld
```


2. Set the mySQL environment option
```
sudo systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
```

3. Start mysql usig the options you just set
```
sudo systemctl start mysqld
```

4. Login as root
```
mysql -u root
```

5. Update the root user password with these mysql commands
```
UPDATE mysql.user SET
authentication_string =
PASSWORD('hadoop') WHERE User = 'root' AND Host = 'localhost';
```

```
FLUSH PRIVILEGES;
```

```
quit
```


6. Stop mysql
```
sudo systemctl stop mysqld
```

7. Unset the mySQL envitroment option so it starts normally next time
```
sudo systemctl unset-environment MYSQLD_OPTS
```

8. Start mysql normally:
```
sudo systemctl start mysqld
```

Try to login using your new password:
```
mysql -u root -p
```

Exit
```
\q
```