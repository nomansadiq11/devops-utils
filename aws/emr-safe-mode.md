# How to disable the EMR Sage Mode

## Sometimes EMR went in safe mode

### how to disable the safe mode

- [Follow the doc](https://aws.amazon.com/premiumsupport/knowledge-center/emr-namenode-turn-off-safemode/)

> SSH Master node

```bash
sudo -u hdfs hdfs dfsadmin -safemode leave

sudo -u hdfs hdfs fsck -delete

```
