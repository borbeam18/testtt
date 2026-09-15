<?php
// api/logout.php
session_start();
session_destroy();
header('Location: /testtt/user/login.php');
exit;