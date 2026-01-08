# How to make curl command via Jshell

## Ussecase

 I want to test curl request using `java` code due to some issue so I found we can run jshell and run below script to test the command.

```java

import javax.net.ssl.HttpsURLConnection;
import java.net.URL;

URL url = new URL("{url}");
HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.connect();
System.out.println("Response code: " + conn.getResponseCode());

```

or create in tmp location

```sh
cat <<EOF > TestTLS.java
import javax.net.ssl.HttpsURLConnection;
import java.net.URL;

public class TestTLS {
  public static void main(String[] args) throws Exception {
    URL url = new URL("{url}");
    HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
    conn.connect();
    System.out.println("OK: " + conn.getResponseCode());
  }
}
EOF

javac TestTLS.java
java TestTLS

```
