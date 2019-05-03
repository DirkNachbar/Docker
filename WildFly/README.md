# WildFly 16 Docker image with Oracle JDBC Driver 18.3

This is an example Dockerfile with [WildFly application server](http://wildfly.org/) with adding Oracle JDBC Driver 18.3 and creating a sample DataSource testDS

## Build the WildFly 16 Image

To build the image use:

Align in the oracle-driver.cli file the settings for your to be created DataSource. Following Parameters needs to be aligned:
* `--name` DataSource Name
* `--jndi-name` JNDI Lookup Name for your DataSource
* `--user-name` Oracle User for the Database Connection
* `--password` Password of the Oracle User
* `--initial-pool-size` Initial Size of your DataSource
* `--max-pool-size` Max Size of your DataSource
* `--min-pool-size` Minimal Size of your DataSource
* `--connection-url` JDBC Connection URL definition, Format = `jdbc:oracle:thin:@<database-servername>:<Listener Port>/<DB-ServiceName>`
* `--check-valid-connection-sql` Any verification SQL for Connection tests, usually with Oracle `select 1 from dual`

```
data-source add --name=testDS --driver-name="oracle" --jndi-name="java:/jdbc/testDS" --statistics-enabled="true" --user-name="soe" --password="soe" --initial-pool-size="25" --max-pool-size="50" --min-pool-size="20" --connection-url="jdbc:oracle:thin:@oraxe18c:1521/XEPDB1" --check-valid-connection-sql="select 1 from dual"
```

Now build the image:
In case you don't provide the `--build-arg WILDFLY_ADMIN_PW=<your admin password>`, the admin user will be created with the default password `admin`

```
docker build [--build-arg WILDFLY_ADMIN_PWD=<your admin password>] -t wildfly .
```

## Run the WildFly 16 Container

To run the WildFly Container with the Oracle JDBC Driver 18.3 simply execute:

```
docker run -d --name wildfly [--network0<your bridged network>] -p <Your Host Port>:8080 -p <Your Host Port>:9990 wildfly
```


