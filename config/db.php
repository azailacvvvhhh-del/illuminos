<?php
// Настройки подключения к базе данных MySQL.
$DB_HOST = '127.0.0.1:3348 '; // Убрал лишний пробел и порт 3348, если он не нужен, верните
$DB_NAME = 'illuminos';
$DB_USER = 'root';
$DB_PASS = '';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

try {
    $pdo = new PDO(
        "mysql:host={$DB_HOST};dbname={$DB_NAME};charset=utf8mb4",
        $DB_USER,
        $DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    exit('Не удалось подключиться к MySQL. Импортируйте database/illuminos.sql и проверьте config/db.php.');
}

function e($value): string {
    return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function current_user(): ?array {
    return $_SESSION['user'] ?? null;
}

function require_login(): void {
    if (!current_user()) {
        header('Location: login.php');
        exit;
    }
}

function is_favorite(PDO $pdo, int $userId, int $contentId): bool {
    $q = $pdo->prepare('SELECT id FROM favorites WHERE user_id = ? AND content_id = ?');
    $q->execute([$userId, $contentId]);
    return (bool)$q->fetch();
}