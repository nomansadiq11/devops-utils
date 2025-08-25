# Install Wordpress on EC2 or Virtual Machine

## Findings

Make sure you are using correct version of the PHP installed (server/machine) and wordpress, both should be compatible
install only require dependancy

## How to troubleshoot

- Check the httpd/nginx logs
- Check the access logs
- Check the slowness of the website, website could be slow due to installed plugins
- Remove plugins one by one and see the performance
- Rename the plugins folder, this will deactive all the plugins, so later you can enable plugins one by one and see, which plugin causing slowness

## Containerization

- we can run wordpress on Kubernetes
- locally we can use docker for development [docker-compose](docker-compose.yaml)

## Useful Links

[https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview](https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview)

[https://bitlaunch.io/blog/how-to-install-lemp-stack-on-ubuntu-20-04/](https://bitlaunch.io/blog/how-to-install-lemp-stack-on-ubuntu-20-04/)

[https://make.wordpress.org/cli/handbook/guides/installing/](https://make.wordpress.org/cli/handbook/guides/installing/)
