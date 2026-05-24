# MySQL to Supabase (PostgreSQL) Migration Guide

## Overview
This document records the migration of the `RestaurantManagement` Java EE project from a local MySQL database to a cloud-hosted Supabase PostgreSQL instance.

The migration successfully replaced the previous data persistence layer while securely managing direct database connections from inside a GlassFish Application Server context.

---

## 1. Architecture Updates
The application no longer connects to `localhost` running MySQL. Instead, it utilizes Supabase’s Session Pooler:
- **Host**: `aws-1-eu-central-1.pooler.supabase.com`
- **Port**: `5432` 
- **Networking details**: The standard direct connection URL for the project provided an IPv6 address which is sometimes inaccessible from local development environments depending on ISP configurations. To bridge this, we configured the application to communicate over IPv4 using the built-in Supabase session pooler on port `5432`.

### Why the Pooler?
Connecting via Supavisor (the Session Pooler) natively proxy-handles IPv4 requests, resolving Java's typical `UnknownHostException` issues that surface when IPv6 routing is disabled on the host machine.

---

## 2. Dependency Management
The project shifted its backend driver architecture entirely:
- **Removed**: `mysql-connector-java` (MySQL Driver)
- **Added**: `org.postgresql:postgresql:42.7.3` (Postgres JDBC Driver)

All dependencies have been natively installed to both the local Maven repository and within the `glassfish/lib` folder to ensure JNDI connection availability.

---

## 3. Configuration Map
Various layers of the application required connection string updates:

### Environment Variables (`.env`)
Maintains connection definitions for standard fallback properties and Supabase App specifics (Excluded from Git control).

### GlassFish Administration config (`glassfish-resources.xml`)
We established a server-layer DataSource that provides enterprise pooling for Java components without hardcoding configuration into JARs. 
- **Pool Name**: `restaurant_pool` (`org.postgresql.ds.PGSimpleDataSource`)
- **JNDI Source**: `jdbc/restaurantDB`

### EclipseLink Validation (`persistence.xml`)
Both standard meta inf (`src/main/resources/META-INF/persistence.xml`) and web module structures (`src/main/webapp/WEB-INF/persistence.xml`) were reconfigured to default to the configured GlassFish data pool:
- `transaction-type` set from `RESOURCE_LOCAL` to **`JTA`**.
- `<jta-data-source>jdbc/restaurantDB</jta-data-source>` enforces centralized connection controls.
- Defined target platforms via EclipseLink properties: `org.eclipse.persistence.platform.database.PostgreSQLPlatform`.

---

## 4. Code Refactoring Notes (SQL Syntax Changes)
Direct JDBC requests in the `DashboardDAO` classes embedded MySQL-specific function requests which inherently break on PostgreSQL execution layers. We applied the following global code syntax refactoring:

#### Date and Time Functions Refactored
1. `CURDATE()` rewritten to `CURRENT_DATE`.
2. MySQL shorthand extractions (e.g., `YEAR(order_date)` and `MONTH(...)`) translated cleanly to ANSI equivalents:
   - `EXTRACT(YEAR FROM order_date)`
   - `EXTRACT(MONTH FROM order_date)`

#### Identifiers
Some case-sensitive configurations and schema mappings within standard Java controllers such as `OrderServlet` mapped INSERT columns and table values precisely to strictly aligned formatting limits inherent in PostgreSQL table definition.

---

## 5. Deployment Step-By-Step Validation
If deploying freshly on a new machine, follow these instructions to validate components:

1. Copy the Postgres JDBC `42.7.3` driver `JAR` file into `<glassfish-dir>/glassfish/lib`.
2. Open terminal in the `RestaurantManagement` directory.
3. Deploy the GlassFish resources if missing: 
   `asadmin add-resources src/main/webapp/WEB-INF/glassfish-resources.xml`
4. Assemble application via Maven:
   `mvn clean package`
5. Deploy WAR to server:
   `asadmin deploy --force=true target/RestaurantManagement-1.0-SNAPSHOT.war`
