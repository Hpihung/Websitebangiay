<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.net.*, java.net.http.*, com.google.gson.*" %>
<html>
<head>
    <title>Gemini API Diagnostic Tool - Multi-Method Test</title>
    <style>
        body { font-family: 'Inter', sans-serif; padding: 30px; background: #f8f9fa; color: #333; }
        .card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 20px; }
        h2 { color: #6C5DD3; margin-top: 0; }
        pre { background: #2d3748; color: #fff; padding: 15px; border-radius: 8px; overflow-x: auto; font-size: 13px; }
        .success { color: #2ed573; font-weight: bold; }
        .error { color: #ff4757; font-weight: bold; }
        .info { color: #1e90ff; }
    </style>
</head>
<body>
    <div class="card">
        <h2>1. Active Key Info</h2>
        <%
            String envKey = System.getenv("GEMINI_API_KEY");
            String absolutePath = "c:/Users/Thinkbook/Downloads/bangiay (2)/bangiay/web/WEB-INF/gemini_key.txt";
            File absFile = new File(absolutePath);
            String realPath = request.getServletContext().getRealPath("/WEB-INF/gemini_key.txt");
            File realFile = realPath != null ? new File(realPath) : null;

            String apiKey = null;
            String source = "";
            if (envKey != null && !envKey.trim().isEmpty()) {
                apiKey = envKey.trim();
                source = "Environment Variable";
            } else if (absFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(absFile))) {
                    apiKey = br.readLine();
                    if (apiKey != null) apiKey = apiKey.trim();
                    source = "Absolute Path";
                } catch(Exception e) {}
            } else if (realFile != null && realFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(realFile))) {
                    apiKey = br.readLine();
                    if (apiKey != null) apiKey = apiKey.trim();
                    source = "Servlet Context Path";
                } catch(Exception e) {}
            }

            if (apiKey != null && !apiKey.isEmpty()) {
                String masked = apiKey.length() > 8 ? apiKey.substring(0, 8) + "..." + apiKey.substring(apiKey.length() - 4) : apiKey;
                out.println("<p><b>Loaded Key:</b> <span class='success'>" + masked + "</span> (" + apiKey.length() + " chars) from " + source + "</p>");
            } else {
                out.println("<p class='error'>No API Key loaded on disk.</p>");
            }
        %>
    </div>

    <% if (apiKey != null && !apiKey.isEmpty()) { 
        JsonObject requestBody = new JsonObject();
        JsonArray contents = new JsonArray();
        JsonObject contentObj = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject partObj = new JsonObject();
        partObj.addProperty("text", "Hello");
        parts.add(partObj);
        contentObj.add("parts", parts);
        contents.add(contentObj);
        requestBody.add("contents", contents);
        String jsonPayload = new Gson().toJson(requestBody);

        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(java.time.Duration.ofSeconds(8))
                .build();
    %>

    <!-- TEST 1: URL QUERY PARAMETER -->
    <div class="card">
        <h2>Method 1: URL Query Parameter (?key=...)</h2>
        <%
            try {
                String testUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;
                HttpRequest apiRequest1 = HttpRequest.newBuilder()
                        .uri(URI.create(testUrl))
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                        .build();

                HttpResponse<String> apiRes1 = client.send(apiRequest1, HttpResponse.BodyHandlers.ofString());
                out.println("<p><b>Response Code:</b> " + apiRes1.statusCode() + " " + 
                            (apiRes1.statusCode() == 200 ? "<span class='success'>OK</span>" : "<span class='error'>FAILED</span>") + "</p>");
                out.println("<pre>" + apiRes1.body().replace("<", "&lt;").replace(">", "&gt;") + "</pre>");
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- TEST 2: AUTHORIZATION BEARER HEADER -->
    <div class="card">
        <h2>Method 2: Authorization Bearer Header</h2>
        <%
            try {
                String testUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
                HttpRequest apiRequest2 = HttpRequest.newBuilder()
                        .uri(URI.create(testUrl))
                        .header("Content-Type", "application/json")
                        .header("Authorization", "Bearer " + apiKey)
                        .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                        .build();

                HttpResponse<String> apiRes2 = client.send(apiRequest2, HttpResponse.BodyHandlers.ofString());
                out.println("<p><b>Response Code:</b> " + apiRes2.statusCode() + " " + 
                            (apiRes2.statusCode() == 200 ? "<span class='success'>OK</span>" : "<span class='error'>FAILED</span>") + "</p>");
                out.println("<pre>" + apiRes2.body().replace("<", "&lt;").replace(">", "&gt;") + "</pre>");
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- TEST 3: X-GOOG-API-KEY HEADER -->
    <div class="card">
        <h2>Method 3: x-goog-api-key Header</h2>
        <%
            try {
                String testUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
                HttpRequest apiRequest3 = HttpRequest.newBuilder()
                        .uri(URI.create(testUrl))
                        .header("Content-Type", "application/json")
                        .header("x-goog-api-key", apiKey)
                        .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                        .build();

                HttpResponse<String> apiRes3 = client.send(apiRequest3, HttpResponse.BodyHandlers.ofString());
                out.println("<p><b>Response Code:</b> " + apiRes3.statusCode() + " " + 
                            (apiRes3.statusCode() == 200 ? "<span class='success'>OK</span>" : "<span class='error'>FAILED</span>") + "</p>");
                out.println("<pre>" + apiRes3.body().replace("<", "&lt;").replace(">", "&gt;") + "</pre>");
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- TEST 4: VERTEX AI API ENDPOINT -->
    <div class="card">
        <h2>Method 4: Vertex AI API Endpoint (Dynamic project-id lookup)</h2>
        <%
            try {
                // Dynamically test both project IDs found in user screenshots
                String[] projects = {"gen-lang-client-0419586743", "gen-lang-client-0714057898"};
                for (String proj : projects) {
                    out.println("<p class='info'>Testing Vertex AI with Project ID: <b>" + proj + "</b>...</p>");
                    String testUrl = "https://us-central1-aiplatform.googleapis.com/v1/projects/" + proj + "/locations/us-central1/publishers/google/models/gemini-1.5-flash:generateContent";
                    
                    HttpRequest apiRequest4 = HttpRequest.newBuilder()
                            .uri(URI.create(testUrl))
                            .header("Content-Type", "application/json")
                            .header("Authorization", "Bearer " + apiKey)
                            .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                            .build();

                    HttpResponse<String> apiRes4 = client.send(apiRequest4, HttpResponse.BodyHandlers.ofString());
                    out.println("<p><b>Response Code for " + proj + ":</b> " + apiRes4.statusCode() + " " + 
                                (apiRes4.statusCode() == 200 ? "<span class='success'>OK</span>" : "<span class='error'>FAILED</span>") + "</p>");
                    out.println("<pre>" + apiRes4.body().replace("<", "&lt;").replace(">", "&gt;") + "</pre>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error in Vertex AI test: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <% } %>
</body>
</html>
