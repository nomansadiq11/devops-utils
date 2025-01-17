# How to disable the EMR Sage Mode

## Troubleshoot 1 EMR went in safe mode due to hdfs file system storage full

We can troubleshoot the safe mode <https://aws.amazon.com/premiumsupport/knowledge-center/emr-namenode-turn-off-safemode/>

> SSH Master node

```bash
# check safe mode status
hdfs dfsadmin -safemode get

# disable safemode
sudo -u hdfs hdfs dfsadmin -safemode leave

# Incase if hdfs file system full
sudo -u hdfs hdfs fsck -delete

```

## Troubleshoot 2 log disk full

> SSH Master node

```bash
# check safe mode status
hdfs dfsadmin -safemode get

# goto log directory and see the following file spark-history-server.out size
cd /mnt/var/log/spark/

# check the current folder size with each file size
du -sch *

# take backup of the file to S3 or somewhere and delete it
aws s3 cp spark-history-server.out s3://bucketname/

# remove the file
rm spark-history-server.out

# restart history server
systemctl restart spark-history-server

# check status history server
systemctl status spark-history-server

# disable safemode
sudo -u hdfs hdfs dfsadmin -safemode leave


```
