-- 1. Bảng Users 
CREATE TABLE `users` (
    `user_id` CHAR(36) PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(100),
    `avatar_url` VARCHAR(255),
    `is_online` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Conversations 
CREATE TABLE `conversations` (
    `conversation_id` CHAR(36) PRIMARY KEY,

    `user_one_id` CHAR(36) NOT NULL,
    `user_two_id` CHAR(36) NOT NULL,

    `last_message_content` TEXT,
    `last_message_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `fk_user_one` FOREIGN KEY (`user_one_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,

    CONSTRAINT `fk_user_two` FOREIGN KEY (`user_two_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,

    CONSTRAINT `unique_user_pair` UNIQUE (`user_one_id`, `user_two_id`)
);


-- 3. Bảng Messages
CREATE TABLE `messages` (
    `message_id` CHAR(36) PRIMARY KEY,
    `conversation_id` CHAR(36) NOT NULL,
    `sender_id` CHAR(36) NOT NULL,
    
    `content` TEXT, 
    `message_type` ENUM('text', 'image', 'file', 'call_log') DEFAULT 'text',
    `media_url` VARCHAR(255),
    
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,    -- Tính năng "Đã xem"
    
    FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`conversation_id`) ON DELETE CASCADE,
    FOREIGN KEY (`sender_id`) REFERENCES `users`(`user_id`)
);

-- 4. Bảng CallHistory 
CREATE TABLE `callHistory` (
    `call_id` CHAR(36) PRIMARY KEY,
    `caller_id` CHAR(36)  NOT NULL, -- Người gọi
    `receiver_id` CHAR(36)  NOT NULL, -- Người nghe
    
   `call_type` ENUM('audio', 'video') NOT NULL,
    `status` ENUM('missed', 'completed', 'rejected', 'busy') DEFAULT 'missed',
    
    `start_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `duration_seconds` INT DEFAULT 0, -- Thời lượng cuộc gọi (giây)
    
    FOREIGN KEY (`caller_id`) REFERENCES `users`(`user_id`),
    FOREIGN KEY (`receiver_id`) REFERENCES `users`(`user_id`)
);