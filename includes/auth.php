<?php
// includes/auth.php
require_once __DIR__ . '/../config/db.php';

function isLoggedIn(): bool
{
    return isset($_SESSION['user_id'], $_SESSION['role']);
}

function requireLogin(): void
{
    if (!isLoggedIn()) {
        header('Location: /testtt/user/login.php');
        exit;
    }
}

function requireRole(string ...$roles): void
{
    requireLogin();
    if (!in_array($_SESSION['role'], $roles, true)) {
        http_response_code(403);
        exit('Access denied: คุณไม่มีสิทธิ์เข้าถึงหน้านี้');
    }
}

function currentUser(): array
{
    return [
        'id' => $_SESSION['user_id'] ?? null,
        'role' => $_SESSION['role'] ?? null,
        'name' => $_SESSION['user_name'] ?? '',
    ];
}

function redirectToRoleHome(): void
{
    $map = [
        'admin' => '/testtt/admin/users.php',
        'owner' => '/testtt/owner/dashboard.php',
        'technician' => '/testtt/customer/dashboard.php',
        'customer' => '/testtt/customer/dashboard.php',
    ];
    $role = $_SESSION['role'] ?? '';
    header('Location: ' . ($map[$role] ?? '/testtt/user/login.php'));
    exit;
}
