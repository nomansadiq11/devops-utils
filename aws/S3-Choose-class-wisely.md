# Choose S3 Storage Class Wisely

## Scenarios

Its very important to choose your S3 bucket Storage class, I have the following learning

- If you objects are smaller like under 128KB, then keep in standard class which is cost effective. Otherwise you can archive object together and store cold storage
- If you have objects size more then 128kb, then use S3 INT class which automatically look your object and store in cold storage.
