<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="dao.admin.AdminStatsDao" %>
<%@ page import="DTO.TopProductDTO" %>
<%@ page import="java.util.*" %>
<%
    AdminStatsDao statsDao = new AdminStatsDao();
    Gson gson = new Gson();
    
    String message = request.getParameter("message");
    if (message == null) message = "";
    String msgLower = message.toLowerCase().trim();
    
    JsonObject result = new JsonObject();
    JsonArray suggestions = new JsonArray();
    JsonArray productsArr = new JsonArray();
    String aiReply = "";

    // --- LOCAL INTELLIGENCE ENGINE (Bản Free cực kỳ thông minh) ---
    
    // 1. Chào hỏi & Lịch sự
    if (msgLower.matches(".*(chào|hi|hello|hey|ê|bot|ai).*")) {
        aiReply = "Xin chào! Mình là Trợ lý ảo của H&M Sport Shoes. Mình có thể giúp bạn chọn size giày, gợi ý mẫu mới hoặc kiểm tra đơn hàng ạ!";
    }
    
    // 2. Tư vấn Size (Xử lý số đo chính xác)
    else if (msgLower.matches(".*\\d+.*")) {
        double cm = 0;
        try {
            String numeric = msgLower.replaceAll("[^0-9.]", "");
            if (!numeric.isEmpty()) cm = Double.parseDouble(numeric);
        } catch(Exception e) {}

        if (cm > 0) {
            if (cm < 22) aiReply = "Số đo " + cm + "cm hơi nhỏ, có lẽ bạn đang tìm giày trẻ em? H&M hiện có sẵn các size từ 36 trở lên ạ.";
            else if (cm >= 22 && cm < 23) aiReply = "Với chân dài " + cm + "cm, bạn đi Size 36 hoặc 37 là vừa đẹp nhé.";
            else if (cm >= 23 && cm < 24) aiReply = "Chân bạn " + cm + "cm thì Size 38 sẽ rất thoải mái ạ.";
            else if (cm >= 24 && cm < 25) aiReply = "Với số đo " + cm + "cm, mình khuyên bạn chọn Size 39 hoặc 40 tùy mẫu giày.";
            else if (cm >= 25 && cm < 26) aiReply = "Kích thước " + cm + "cm tương ứng với Size 40-41 của H&M bạn nhé.";
            else if (cm >= 26 && cm < 27) aiReply = "Chân dài " + cm + "cm thì Size 42 là lựa chọn hoàn hảo nhất.";
            else if (cm >= 27 && cm < 28) aiReply = "Với chân " + cm + "cm, bạn nên chọn Size 43 hoặc 44 để đi lại êm ái.";
            else if (cm >= 28 && cm < 29) aiReply = "Số đo " + cm + "cm thì Size 45 sẽ là kích cỡ chuẩn cho bạn.";
            else if (cm >= 29) aiReply = "Chân dài " + cm + "cm thuộc size lớn, bạn nên chọn Size 46 hoặc 47 (nếu có sẵn) ạ.";
        }
    }
    
    // 3. Chính sách Vận chuyển & Thanh toán
    if (aiReply.isEmpty()) {
        if (msgLower.matches(".*(ship|giao hàng|vận chuyển|phí|bao lâu).*")) {
            aiReply = "H&M miễn phí vận chuyển cho đơn hàng từ 1.000.000đ. Thời gian giao hàng dự kiến từ 2-4 ngày làm việc trên toàn quốc ạ.";
        } else if (msgLower.matches(".*(thanh toán|cod|tiền|chuyển khoản|bank|momo).*")) {
            aiReply = "Bạn có thể thanh toán linh hoạt qua COD (nhận hàng trả tiền), chuyển khoản ngân hàng hoặc ví Momo. Shop luôn sẵn sàng hỗ trợ bạn!";
        } else if (msgLower.matches(".*(đổi trả|hoàn hàng|trả hàng|lỗi|hỏng|không vừa|vỡ).*")) {
            aiReply = "Đừng lo lắng! H&M hỗ trợ đổi trả/hoàn hàng trong vòng 7 ngày nếu sản phẩm có lỗi hoặc bạn đi không vừa size. Hãy giữ nguyên tem mác bạn nhé!";
        }
    }

    // 4. Địa chỉ & Liên hệ
    if (aiReply.isEmpty()) {
        if (msgLower.contains("địa chỉ") || msgLower.contains("ở đâu") || msgLower.contains("shop") || msgLower.contains("cửa hàng")) {
            aiReply = "Showroom H&M Sport Shoes tọa lạc tại: 136 Kim Giang, Hoàng Mai, Hà Nội. Mở cửa từ 8:00 đến 22:00 hàng ngày.";
        } else if (msgLower.contains("số điện thoại") || msgLower.contains("hotline") || msgLower.contains("liên hệ")) {
            aiReply = "Bạn có thể gọi hotline: 0367.085.888 để được hỗ trợ gấp ạ!";
        }
    }

    // 5. Gợi ý sản phẩm
    if (msgLower.contains("hot") || msgLower.contains("gợi ý") || msgLower.contains("đẹp") || msgLower.contains("mẫu") || msgLower.contains("giày")) {
        if (aiReply.isEmpty()) aiReply = "Dưới đây là những mẫu giày đang bán chạy nhất tại shop. Bạn tham khảo xem có ưng ý mẫu nào không nhé!";
        try {
            List<TopProductDTO> top = statsDao.getTop10Products(2026);
            if (top != null) {
                for (int i = 0; i < Math.min(3, top.size()); i++) {
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

    // 6. Mặc định nếu không khớp gì
    if (aiReply.isEmpty()) {
        aiReply = "Chào bạn! Mình có thể giúp gì cho bạn về chọn size giày, gợi ý mẫu mới hoặc thông tin vận chuyển không ạ?";
    }

    result.addProperty("reply", aiReply);
    suggestions.add("Tư vấn size");
    suggestions.add("Mẫu giày hot");
    suggestions.add("Địa chỉ shop");
    suggestions.add("Chính sách ship");

    result.add("suggestions", suggestions);
    result.add("products", productsArr);
    out.print(gson.toJson(result));
%>
