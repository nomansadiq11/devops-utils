# Quick Postgress

Export data in csv using `psql`

```psql
\copy (SELECT * FROM your_table) TO '/tmp/output.csv' CSV HEADER;
```
