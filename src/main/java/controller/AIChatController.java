package controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.admin.AdminStatsDao;
import DTO.TopProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet("/ai-chat")
public class AIChatController extends HttpServlet {
    private final AdminStatsDao statsDao = new AdminStatsDao();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String message = request.getParameter("message");
            if (message == null) message = "";
            String userMsg = message.trim();
            String lowerMsg = userMsg.toLowerCase();

            JsonObject result = new JsonObject();
            JsonArray suggestions = new JsonArray();
            JsonArray productsArr = new JsonArray();

            // Try to get API Key for Google Gemini
            String apiKey = getApiKey(request);

            if (apiKey != null && !apiKey.isEmpty()) {
                // CALL DYNAMIC GEMINI AI
                String geminiReply = callGeminiAPI(userMsg, apiKey);
                if (geminiReply != null && !geminiReply.isEmpty()) {
                    boolean suggestHot = false;
                    int suggestSize = -1;

                    // Intercept system tags from Gemini
                    if (geminiReply.contains("[SUGGEST_HOT_PRODUCTS]")) {
                        suggestHot = true;
                        geminiReply = geminiReply.replace("[SUGGEST_HOT_PRODUCTS]", "").trim();
                    }

                    Pattern tagPattern = Pattern.compile("\\[SUGGEST_SIZE:\\s*(\\d+)\\]");
                    Matcher tagMatcher = tagPattern.matcher(geminiReply);
                    if (tagMatcher.find()) {
                        try {
                            suggestSize = Integer.parseInt(tagMatcher.group(1));
                        } catch (Exception e) {}
                        geminiReply = tagMatcher.replaceAll("").trim();
                    }

                    result.addProperty("reply", geminiReply);

                    // Fetch products if tags match
                    if (suggestHot || suggestSize > 0) {
                        try {
                            List<TopProductDTO> top = statsDao.getTop10Products(2026, null);
                            if (top != null) {
                                for (int i = 0; i < Math.min(4, top.size()); i++) {
                                    TopProductDTO p = top.get(i);
                                    JsonObject pObj = new JsonObject();
                                    pObj.addProperty("id", p.getProductId());
                                    pObj.addProperty("name", p.getName());
                                    pObj.addProperty("image", p.getImage());
                                    double rev = p.getTotalRevenue() != null ? p.getTotalRevenue().doubleValue() : 0;
                                    double sold = p.getTotalSold() > 0 ? p.getTotalSold() : 1;
                                    pObj.addProperty("price", String.format("%,.0f", rev / sold));
                                    productsArr.add(pObj);
                                }
                            }
                        } catch (Exception e) {}
                    }

                    suggestions.add("Tư vấn chọn size");
                    suggestions.add("Mẫu giày hot");
                    suggestions.add("Địa chỉ shop");

                    result.add("suggestions", suggestions);
                    result.add("products", productsArr);
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            }

            // FALLBACK: RULE-BASED SYSTEM IF GEMINI IS NOT CONFIGURED OR FAILS
            double numberVal = -1;
            boolean isFootLength = false;
            boolean isShoeSize = false;
            String numberStr = "";

            Pattern numPattern = Pattern.compile("(\\d+([.,]\\d+)?)");
            Matcher numMatcher = numPattern.matcher(lowerMsg);
            if (numMatcher.find()) {
                try {
                    numberStr = numMatcher.group(1);
                    String parsedStr = numberStr.replace(',', '.');
                    double val = Double.parseDouble(parsedStr);
                    numberVal = val;
                    
                    if (val >= 20.0 && val <= 30.0) {
                        isFootLength = true;
                    } else if (val >= 35.0 && val <= 47.0) {
                        isShoeSize = true;
                    }
                } catch (NumberFormatException e) {}
            }

            // 1. Dynamic Size Advice based on foot length
            if (isFootLength) {
                int suggestedSize;
                if (numberVal < 22.0) {
                    suggestedSize = 35;
                } else if (numberVal >= 22.0 && numberVal < 22.5) {
                    suggestedSize = 36;
                } else if (numberVal >= 22.5 && numberVal < 23.0) {
                    suggestedSize = 37;
                } else if (numberVal >= 23.0 && numberVal < 23.8) {
                    suggestedSize = 38;
                } else if (numberVal >= 23.8 && numberVal < 24.3) {
                    suggestedSize = 39;
                } else if (numberVal >= 24.3 && numberVal < 24.8) {
                    suggestedSize = 40;
                } else if (numberVal >= 24.8 && numberVal < 25.3) {
                    suggestedSize = 41;
                } else if (numberVal >= 25.3 && numberVal < 25.8) {
                    suggestedSize = 42;
                } else if (numberVal >= 25.8 && numberVal < 26.5) {
                    suggestedSize = 43;
                } else if (numberVal >= 26.5 && numberVal < 27.2) {
                    suggestedSize = 44;
                } else if (numberVal >= 27.2 && numberVal < 28.0) {
                    suggestedSize = 45;
                } else {
                    suggestedSize = 46;
                }

                result.addProperty("reply", String.format("Với chiều dài chân là %s cm, size giày phù hợp nhất với bạn là **size %d**. Bạn có muốn xem các mẫu giày hot đang có sẵn size này không?", numberStr, suggestedSize));
                suggestions.add("Sản phẩm còn size " + suggestedSize);
                suggestions.add("Bảng size chuẩn");
                suggestions.add("Mẫu giày hot");
            } 
            // 2. Query product list by specific shoe size
            else if (isShoeSize) {
                int sizeQuery = (int) numberVal;
                result.addProperty("reply", String.format("Dạ, đây là những mẫu giày hot bán chạy nhất đang có sẵn **size %d** tại H&M Sport Shoes. Mời bạn tham khảo:", sizeQuery));
                try {
                    List<TopProductDTO> top = statsDao.getTop10Products(2026, null);
                    if (top != null) {
                        for (int i = 0; i < Math.min(4, top.size()); i++) {
                            TopProductDTO p = top.get(i);
                            JsonObject pObj = new JsonObject();
                            pObj.addProperty("id", p.getProductId());
                            pObj.addProperty("name", p.getName());
                            pObj.addProperty("image", p.getImage());
                            double rev = p.getTotalRevenue() != null ? p.getTotalRevenue().doubleValue() : 0;
                            double sold = p.getTotalSold() > 0 ? p.getTotalSold() : 1;
                            pObj.addProperty("price", String.format("%,.0f", rev / sold));
                            productsArr.add(pObj);
                        }
                    }
                } catch (Exception e) {}
                suggestions.add("Tư vấn chọn size");
                suggestions.add("Mẫu giày hot");
                suggestions.add("Địa chỉ shop");
            }
            // 3. Size chart
            else if (lowerMsg.contains("bảng size") || lowerMsg.contains("size chuẩn") || lowerMsg.contains("bảng kích cỡ")) {
                result.addProperty("reply", "Dạ đây là bảng quy đổi chiều dài bàn chân sang size giày chuẩn của H&M Sport Shoes:\n" +
                        "• Size 38: Chân dài 23.0 - 23.5 cm\n" +
                        "• Size 39: Chân dài 23.8 - 24.2 cm\n" +
                        "• Size 40: Chân dài 24.3 - 24.7 cm\n" +
                        "• Size 41: Chân dài 24.8 - 25.2 cm\n" +
                        "• Size 42: Chân dài 25.3 - 25.7 cm\n" +
                        "• Size 43: Chân dài 25.8 - 26.4 cm\n" +
                        "• Size 44: Chân dài 26.5 - 27.1 cm\n" +
                        "• Size 45: Chân dài 27.2 - 28.0 cm\n\n" +
                        "Bạn có thể đo chiều dài từ gót chân đến đầu ngón chân dài nhất để chọn size chính xác nhất nhé!");
                suggestions.add("Mẫu giày hot");
                suggestions.add("Địa chỉ shop");
            }
            // 4. Ask for size consulting
            else if (lowerMsg.contains("size") || lowerMsg.contains("sz") || lowerMsg.contains("kích cỡ") || lowerMsg.contains("vừa")) {
                result.addProperty("reply", "Chào bạn! Để tư vấn size chính xác nhất, bạn hãy cho mình biết chiều dài bàn chân (cm) hoặc size giày bạn hay đi nhé.");
                suggestions.add("Chân dài 24cm");
                suggestions.add("Chân dài 25cm");
                suggestions.add("Bảng size chuẩn");
            }
            // 5. Gợi ý sản phẩm
            else if (lowerMsg.contains("hot") || lowerMsg.contains("gợi ý") || lowerMsg.contains("đẹp") || lowerMsg.contains("mẫu") || lowerMsg.contains("sale")) {
                result.addProperty("reply", "Đây là những mẫu giày đang cực hot tại H&M Sport Shoes. Tất cả đều là hàng chính hãng!");
                try {
                    List<TopProductDTO> top = statsDao.getTop10Products(2026, null);
                    if (top != null) {
                        for (int i = 0; i < Math.min(4, top.size()); i++) {
                            TopProductDTO p = top.get(i);
                            JsonObject pObj = new JsonObject();
                            pObj.addProperty("id", p.getProductId());
                            pObj.addProperty("name", p.getName());
                            pObj.addProperty("image", p.getImage());
                            double rev = p.getTotalRevenue() != null ? p.getTotalRevenue().doubleValue() : 0;
                            double sold = p.getTotalSold() > 0 ? p.getTotalSold() : 1;
                            pObj.addProperty("price", String.format("%,.0f", rev / sold));
                            productsArr.add(pObj);
                        }
                    }
                } catch (Exception e) {}
                suggestions.add("Giày chạy bộ");
                suggestions.add("Giày bóng rổ");
            }
            // 6. Mua hàng / Thanh toán
            else if (lowerMsg.contains("mua") || lowerMsg.contains("đặt") || lowerMsg.contains("thanh toán") || lowerMsg.contains("ship")) {
                result.addProperty("reply", "H&M miễn phí vận chuyển cho đơn từ 1 triệu đồng. Bạn có thể thanh toán COD hoặc chuyển khoản khi nhận hàng.");
                suggestions.add("Chính sách vận chuyển");
                suggestions.add("Địa chỉ shop");
            }
            // 7. Địa chỉ / Liên hệ
            else if (lowerMsg.contains("địa chỉ") || lowerMsg.contains("ở đâu") || lowerMsg.contains("shop")) {
                result.addProperty("reply", "Showroom H&M Sport Shoes: 136 Kim Giang, Hoàng Mai, Hà Nội. Mở cửa 8h-22h hàng ngày ạ!");
                suggestions.add("Liên hệ hotline");
            }
            // 8. Mặc định
            else {
                result.addProperty("reply", "Chào bạn, mình là trợ lý ảo H&M! Bạn cần hỗ trợ về chọn size, gợi ý mẫu giày hay thông tin cửa hàng ạ?");
                suggestions.add("Tư vấn sz");
                suggestions.add("Mẫu giày hot");
                suggestions.add("Địa chỉ shop");
            }

            result.add("suggestions", suggestions);
            result.add("products", productsArr);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            JsonObject err = new JsonObject();
            err.addProperty("reply", "Hệ thống đang bận. Bạn vui lòng thử lại sau nhé!");
            response.getWriter().write(gson.toJson(err));
        }
    }

    private String getApiKey(HttpServletRequest request) {
        System.out.println("[Gemini Debug] Searching for API key...");
        
        // 1. Try env variable
        String envKey = System.getenv("GEMINI_API_KEY");
        if (envKey != null && !envKey.trim().isEmpty()) {
            System.out.println("[Gemini Debug] Found API key in environment variables.");
            return envKey.trim();
        }

        // 2. Try absolute path to source web/WEB-INF/gemini_key.txt
        try {
            File sourceFile = new File("c:/Users/Thinkbook/Downloads/bangiay (2)/bangiay/web/WEB-INF/gemini_key.txt");
            if (sourceFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(sourceFile))) {
                    String line = br.readLine();
                    if (line != null && !line.trim().isEmpty()) {
                        System.out.println("[Gemini Debug] Found API key in absolute path web/WEB-INF/gemini_key.txt");
                        return line.trim();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[Gemini Debug] Error reading absolute WEB-INF key file: " + e.getMessage());
        }

        // 3. Try WEB-INF/gemini_key.txt from servlet context
        try {
            String webInfPath = request.getServletContext().getRealPath("/WEB-INF/gemini_key.txt");
            if (webInfPath != null) {
                File file = new File(webInfPath);
                if (file.exists()) {
                    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                        String line = br.readLine();
                        if (line != null && !line.trim().isEmpty()) {
                            System.out.println("[Gemini Debug] Found API key in deployed WEB-INF/gemini_key.txt");
                            return line.trim();
                        }
                    }
                }
            }
        } catch (Exception e) {}
        
        // 4. Try file in project root (gemini_key.txt)
        try {
            String path = request.getServletContext().getRealPath("/");
            if (path != null) {
                File rootDir = new File(path).getParentFile().getParentFile(); // go up from target/webshoes
                File file = new File(rootDir, "gemini_key.txt");
                if (file.exists()) {
                    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                        String line = br.readLine();
                        if (line != null && !line.trim().isEmpty()) {
                            System.out.println("[Gemini Debug] Found API key in project root gemini_key.txt");
                            return line.trim();
                        }
                    }
                }
            }
        } catch (Exception e) {}

        // 5. Try absolute root directory fallback
        try {
            File rootFile = new File("c:/Users/Thinkbook/Downloads/bangiay (2)/bangiay/gemini_key.txt");
            if (rootFile.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(rootFile))) {
                    String line = br.readLine();
                    if (line != null && !line.trim().isEmpty()) {
                        System.out.println("[Gemini Debug] Found API key in absolute project root gemini_key.txt");
                        return line.trim();
                    }
                }
            }
        } catch (Exception e) {}
        
        System.out.println("[Gemini Debug] No API key found in any location.");
        return null;
    }

    private String callGeminiAPI(String userMsg, String apiKey) {
        System.out.println("[Gemini Debug] Calling Gemini API endpoint...");
        try {
            String url;
            boolean useBearer = false;
            if (apiKey.startsWith("AQ.")) {
                url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
                useBearer = true;
                System.out.println("[Gemini Debug] OAuth Token detected (AQ. prefix). Using Bearer Header.");
            } else {
                url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;
                System.out.println("[Gemini Debug] API Key detected. Using query parameter.");
            }
            
            String systemInstruction = 
                "You are the 'H&M Sport Shoes AI Assistant', a helpful online consultant for our sport shoes shop.\n" +
                "Shop Info:\n" +
                "- Name: H&M Sport Shoes\n" +
                "- Address: 136 Kim Giang, Hoàng Mai, Hà Nội\n" +
                "- Working Hours: 8:00 AM - 10:00 PM daily\n" +
                "- Contact: 0367085888, email: hm_sport@gmail.com\n" +
                "- Shipping: Free shipping for orders from 1,000,000 VND. COD & Bank transfer accepted.\n" +
                "- Returns/Warranty: Support exchange or return for refund. Customer can request pickup or self-send to 136 Kim Giang.\n\n" +
                "Size Chart:\n" +
                "- Size 38: 23.0 - 23.5 cm\n" +
                "- Size 39: 23.8 - 24.2 cm\n" +
                "- Size 40: 24.3 - 24.7 cm\n" +
                "- Size 41: 24.8 - 25.2 cm\n" +
                "- Size 42: 25.3 - 25.7 cm\n" +
                "- Size 43: 25.8 - 26.4 cm\n" +
                "- Size 44: 26.5 - 27.1 cm\n" +
                "- Size 45: 27.2 - 28.0 cm\n\n" +
                "Rules:\n" +
                "1. Answer in Vietnamese, politely, naturally, and helpfully. Keep answers conversational, NOT programmatic.\n" +
                "2. If the user asks for shoe recommendations, hot models, sale, or best sellers, always include the tag `[SUGGEST_HOT_PRODUCTS]` at the end of your response.\n" +
                "3. If you recommend a specific size to the user based on their foot length, always include the tag `[SUGGEST_SIZE: X]` (where X is the size number, e.g., `[SUGGEST_SIZE: 40]`) at the end of your response so the system can show relevant product cards.\n" +
                "4. Keep answers relatively short and suitable for a chat widget.";

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject contentObj = new JsonObject();
            JsonArray parts = new JsonArray();
            JsonObject partObj = new JsonObject();
            partObj.addProperty("text", userMsg);
            parts.add(partObj);
            contentObj.add("parts", parts);
            contents.add(contentObj);
            requestBody.add("contents", contents);

            JsonObject systemInstructionObj = new JsonObject();
            JsonArray siParts = new JsonArray();
            JsonObject siPartObj = new JsonObject();
            siPartObj.addProperty("text", systemInstruction);
            siParts.add(siPartObj);
            systemInstructionObj.add("parts", siParts);
            requestBody.add("systemInstruction", systemInstructionObj);

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(java.time.Duration.ofSeconds(10))
                    .build();
                    
            java.net.http.HttpRequest.Builder requestBuilder = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(new Gson().toJson(requestBody)))
                    .timeout(java.time.Duration.ofSeconds(15));

            if (useBearer) {
                requestBuilder.header("Authorization", "Bearer " + apiKey);
            }

            HttpRequest request = requestBuilder.build();

            System.out.println("[Gemini Debug] Sending request to Google Generative Language API...");
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("[Gemini Debug] API response code: " + response.statusCode());
            if (response.statusCode() == 200) {
                JsonObject jsonResponse = new Gson().fromJson(response.body(), JsonObject.class);
                JsonArray candidates = jsonResponse.getAsJsonArray("candidates");
                if (candidates != null && candidates.size() > 0) {
                    JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                    JsonObject content = firstCandidate.getAsJsonObject("content");
                    JsonArray resParts = content.getAsJsonArray("parts");
                    if (resParts != null && resParts.size() > 0) {
                        String reply = resParts.get(0).getAsJsonObject().get("text").getAsString();
                        System.out.println("[Gemini Debug] Success! Reply length: " + reply.length());
                        return reply;
                    }
                }
            } else {
                System.out.println("[Gemini Debug] API Error Body: " + response.body());
            }
        } catch (Exception e) {
            System.out.println("[Gemini Debug] Exception calling API: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
