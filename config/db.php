<?php
// config/db.php

// พาธไฟล์ฐานข้อมูล SQLite (อยู่ในโฟลเดอร์ db/ ของโปรเจกต์)
define('DB_PATH', __DIR__ . '/../db/ekservice.db');
define('DB_SCHEMA_PATH', __DIR__ . '/../db/ekservice_sqlite.sql');

try {
    $pdo = new PDO(
        "sqlite:" . DB_PATH,
        null,
        null,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );

    // เปิดการบังคับใช้ Foreign Key (SQLite ปิดไว้เป็นค่าเริ่มต้น)
    $pdo->exec('PRAGMA foreign_keys = ON;');

    $hasTables = (bool) $pdo->query("SELECT 1 FROM sqlite_master WHERE type = 'table' LIMIT 1")->fetchColumn();
    if (!$hasTables) {
        $schema = file_get_contents(DB_SCHEMA_PATH);
        if ($schema === false || $pdo->exec($schema) === false) {
            throw new RuntimeException('ไม่สามารถสร้างโครงสร้างฐานข้อมูล SQLite ได้');
        }
    }

} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

// Helper: เริ่ม session ถ้ายังไม่มี
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}