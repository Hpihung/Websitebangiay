package model.user;

import org.jdbi.v3.core.mapper.reflect.ColumnName;
import java.time.LocalDateTime;

public class NewsletterSchedule {
    private int id;
    private String name;
    
    @ColumnName("scheduled_at")
    private String scheduledAt;
    
    private String status;
    
    @ColumnName("created_at")
    private LocalDateTime createdAt;

    public NewsletterSchedule() {}

    public NewsletterSchedule(int id, String name, String scheduledAt, String status, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.scheduledAt = scheduledAt;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(String scheduledAt) { this.scheduledAt = scheduledAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
