# RDS connect from powerbi

## how to connect RDS postgres from powerbi - 1

- Step 1: Download the Npgsql client for windows machine and install it
- Step 2: download certificate for windows corresponding your region [https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.RegionCertificates](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.RegionCertificates) and import it
- Step 3: Open powerbi or restart after these configuration and connect with your postgres

## how to connect RDS postgres from powerbi - 2

- Step 1: In aws rds parameter group disable the ssl parameter to 1 to 0
- Step 2: restart the aws rds
- step 3: connect to postgres using power bi
