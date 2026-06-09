<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JDBIConnector" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Migration - Review System v2</title>
    <style>
        body { font-family: monospace; padding: 30px; background: #1a1a2e; color: #eee; }
        h2 { color: #a78bfa; }
        .ok { color: #4ade80; }
        .err { color: #f87171; }
        .info { color: #93c5fd; }
        pre { background: #16213e; padding: 14px; border-radius: 8px; overflow-x: auto; }
    </style>
</head>
<body>
<h2>🔧 Review System Migration V2</h2>
<%
    StringBuilder log = new StringBuilder();
    boolean allOk = true;

    String[] statements = {
        // Add status column (safe - IF NOT EXISTS not supported for ADD COLUMN in older MySQL, use try/catch)
        "ALTER TABLE reviews ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'VISIBLE'",
        // Create review_replies table
        "CREATE TABLE IF NOT EXISTS review_replies (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "review_id INT NOT NULL, " +
            "admin_id INT NOT NULL, " +
            "content TEXT NOT NULL, " +
            "created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE" +
        ")",
        // Create review_reports table
        "CREATE TABLE IF NOT EXISTS review_reports (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "review_id INT NOT NULL, " +
            "user_id INT NOT NULL, " +
            "reason TEXT, " +
            "created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE" +
        ")"
    };

    try {
        JDBIConnector.getJdbi().useHandle(handle -> {
            for (String sql : statements) {
                try {
                    handle.execute(sql);
                    log.append("<span class='ok'>✅ OK: </span><span class='info'>").append(sql.substring(0, Math.min(60, sql.length()))).append("...</span>\n");
                } catch (Exception e) {
                    String msg = e.getMessage();
                    if (msg != null && (msg.contains("Duplicate column") || msg.contains("already exists"))) {
                        log.append("<span class='ok'>⚡ SKIP (already exists): </span><span class='info'>").append(sql.substring(0, Math.min(60, sql.length()))).append("...</span>\n");
                    } else {
                        log.append("<span class='err'>❌ ERROR: ").append(msg).append("</span>\n");
                    }
                }
            }
        });
    } catch (Exception ex) {
        allOk = false;
        log.append("<span class='err'>❌ DB Connection Error: ").append(ex.getMessage()).append("</span>\n");
    }
%>

<pre><%= log.toString() %></pre>

<% if (allOk) { %>
<p class="ok" style="font-size:18px;">✅ Migration hoàn tất! Bạn có thể xóa file này.</p>
<p><a href="<%= request.getContextPath() %>/admin/reviews" style="color:#a78bfa;">→ Đến trang Admin Reviews</a></p>
<% } %>
</body>
</html>
