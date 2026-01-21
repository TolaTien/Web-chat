-- 1. Bảng Users 
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    avatar_url VARCHAR(255),
    is_online BOOLEAN DEFAULT FALSE,
    last_seen DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Conversations 
CREATE TABLE Conversations (
    conversation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_one_id INT NOT NULL,
    user_two_id INT NOT NULL,
    
    -- Lưu thông tin tin nhắn cuối để hiển thị ở danh sách chat cho nhanh (Preview)
    last_message_content TEXT, 
    last_message_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_one_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_two_id) REFERENCES Users(user_id) ON DELETE CASCADE,

    -- Ràng buộc quan trọng: Đảm bảo user_one luôn nhỏ hơn user_two để tránh trùng lặp
    -- Ví dụ: Chỉ lưu cặp (1, 5), không lưu thêm cặp (5, 1)
    CONSTRAINT check_users_order CHECK (user_one_id < user_two_id),
    -- Đảm bảo mỗi cặp chỉ có 1 conversation duy nhất
    UNIQUE KEY unique_pair (user_one_id, user_two_id)
);

-- 3. Bảng Messages (Tin nhắn)
CREATE TABLE Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL,
    
    content TEXT, 
    message_type ENUM('text', 'image', 'file', 'call_log') DEFAULT 'text',
    media_url VARCHAR(255),
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE, -- Tính năng thu hồi tin nhắn
    is_read BOOLEAN DEFAULT FALSE,    -- Tính năng "Đã xem"
    
    FOREIGN KEY (conversation_id) REFERENCES Conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id)
);

-- 4. Bảng CallHistory (Lịch sử cuộc gọi)
CREATE TABLE CallHistory (
    call_id INT AUTO_INCREMENT PRIMARY KEY,
    caller_id INT NOT NULL, -- Người gọi
    receiver_id INT NOT NULL, -- Người nghe
    
    call_type ENUM('audio', 'video') NOT NULL,
    status ENUM('missed', 'completed', 'rejected', 'busy') DEFAULT 'missed',
    
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    duration_seconds INT DEFAULT 0, -- Thời lượng cuộc gọi (giây)
    
    FOREIGN KEY (caller_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);