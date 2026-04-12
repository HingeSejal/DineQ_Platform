import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class TestRegex {
    public static void main(String[] args) throws Exception {
        System.out.println("Registering user:");
        System.out.println(post("http://localhost:8080/register", "username=newuser_A&password=Test@123"));
        
        System.out.println("\nLogging in user:");
        System.out.println(post("http://localhost:8080/auth", "username=newuser_A&password=Test@123"));
    }

    private static String post(String urlStr, String params) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        byte[] out = params.getBytes(StandardCharsets.UTF_8);
        
        try(OutputStream os = conn.getOutputStream()) {
            os.write(out);
        }
        
        System.out.println("Response Code: " + conn.getResponseCode());
        
        InputStream is = (conn.getResponseCode() >= 400) ? conn.getErrorStream() : conn.getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            if (line.contains("alert-error")) {
                sb.append("FOUND ERROR IN HTML: ").append(line.trim()).append("\n");
            }
        }
        return sb.toString();
    }
}
