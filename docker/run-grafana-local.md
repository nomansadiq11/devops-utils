# How you can quickly run grafana locally

## Usecase

- sometimes we need to run grafana locally to test something, here is docker-compose file to run it locally

> docker-compose file

```yaml
version: '3.1'
volumes:
    grafana_data: {}

services:
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - TERM=linux
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,grafana-polystat-panel,vertica-grafana-datasource
```
