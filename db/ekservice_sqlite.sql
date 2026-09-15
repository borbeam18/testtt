PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS admin (
    admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT,
    status TEXT NOT NULL DEFAULT 'Active',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS owner (
    owner_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE,
    password TEXT,
    line_user_id TEXT UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    shop_name TEXT NOT NULL DEFAULT 'ร้านเอกเซอร์วิส',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS technician (
    tech_id INTEGER PRIMARY KEY AUTOINCREMENT,
    line_user_id TEXT UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    specialty TEXT,
    status TEXT NOT NULL DEFAULT 'ว่าง',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS customer (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    line_user_id TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    password TEXT,
    address TEXT,
    latitude REAL,
    longitude REAL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS services (
    service_id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_name TEXT NOT NULL,
    category TEXT,
    base_price NUMERIC NOT NULL DEFAULT 0,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'เปิดใช้งาน'
);

CREATE TABLE IF NOT EXISTS booking (
    booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    tech_id_1 INTEGER,
    tech_id_2 INTEGER,
    booking_date TEXT NOT NULL,
    booking_time TEXT NOT NULL,
    status_service TEXT NOT NULL DEFAULT 'รอรับงาน',
    problem_description TEXT,
    problem_photo_url TEXT,
    reschedule_reason TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON UPDATE CASCADE,
    FOREIGN KEY (tech_id_1) REFERENCES technician(tech_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (tech_id_2) REFERENCES technician(tech_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_booking_date ON booking(booking_date, booking_time);

CREATE TABLE IF NOT EXISTS expense (
    expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
    owner_id INTEGER NOT NULL,
    expense_type TEXT NOT NULL,
    amount NUMERIC NOT NULL,
    expense_date TEXT NOT NULL,
    note TEXT,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS job_material (
    material_id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL,
    material_name TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price NUMERIC NOT NULL DEFAULT 0,
    labor_cost NUMERIC NOT NULL DEFAULT 0,
    total_price NUMERIC GENERATED ALWAYS AS (quantity * unit_price + labor_cost) STORED,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS payment (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL,
    amount NUMERIC NOT NULL,
    slip_photo_url TEXT,
    payment_date TEXT,
    verify_status TEXT NOT NULL DEFAULT 'รอตรวจสอบ',
    verified_by INTEGER,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES owner(owner_id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT OR IGNORE INTO admin (admin_id, username, password, full_name, email, status, created_at) VALUES
(1, 'admin', '$2y$10$MaosTwyRl3jBfZIoIDv7POA83klMvwKD0Xfkw2JG9gyva1H1XQ1xC', 'ภควัฒน์ วันดี', 'borbeam18@gmail.com', 'Active', '2026-09-15 18:42:26');

INSERT OR IGNORE INTO owner (owner_id, username, password, line_user_id, full_name, phone, shop_name, created_at) VALUES
(1, 'owner', '$2y$10$fzUnUx8cWs9aJl2fT6IOReElMNheDdD/DBC/p5yjnXBDhvzbd3/8i', 'U4af4980000000000000000000000000', 'ณัฐพล วันดี', '081-234-5678', 'ร้านเอกเซอร์วิส', '2026-09-15 18:42:26');

INSERT OR IGNORE INTO technician (tech_id, line_user_id, full_name, phone, specialty, status, created_at) VALUES
(1, 'U9fe4471000000000000000000000000', 'วิชัย ช่างเก่ง', '086-111-2233', 'ไฟฟ้า, เครื่องปรับอากาศ', 'ว่าง', '2026-09-15 18:42:26'),
(2, 'U9fe4472000000000000000000000000', 'สมศักดิ์ ช่างมือทอง', '086-222-3344', 'ประปา, งานทั่วไป', 'ว่าง', '2026-09-15 18:42:26');

INSERT OR IGNORE INTO customer (customer_id, line_user_id, full_name, phone, email, password, address, latitude, longitude, created_at) VALUES
(1, 'U8bd23c1000000000000000000000000', 'สมหญิง รักดี', '089-876-5432', 'som@gmail.com', NULL, '12 ถ.นิมมานเหมินท์ ต.สุเทพ อ.เมือง จ.เชียงใหม่', 18.796143, 98.979263, '2026-09-15 18:42:26'),
(3, '', 'ภควัฒน์ วันดี', '096 695 3094', 'borbeam188@gmail.com', '$2y$10$tUx/cXM/UUYZv4CzoMfm.eTkDsODbZI6MdlGDn5tDBddRrQ0Ndhw.', '133 ถนน เจริญประเทศ', NULL, NULL, '2026-09-15 20:10:52');

INSERT OR IGNORE INTO services (service_id, service_name, category, base_price, description, status) VALUES
(1, 'ซ่อมเครื่องปรับอากาศ', 'แอร์', 500, 'ล้างทำความสะอาด ตรวจเช็คน้ำยา และซ่อมแซมเครื่องปรับอากาศ', 'เปิดใช้งาน'),
(2, 'ซ่อมระบบไฟฟ้า', 'ไฟฟ้า', 400, 'ตรวจเช็คและซ่อมแซมระบบไฟฟ้าภายในบ้าน', 'เปิดใช้งาน'),
(3, 'ซ่อมระบบประปา', 'ประปา', 350, 'ตรวจเช็คและซ่อมแซมท่อประปา ก๊อกน้ำ', 'เปิดใช้งาน');

INSERT OR IGNORE INTO booking (booking_id, customer_id, service_id, tech_id_1, booking_date, booking_time, status_service, problem_description, created_at) VALUES
(1, 1, 1, 1, '2026-10-15', '10:30:00', 'เสร็จสิ้น', 'แอร์มีน้ำหยดคอยล์เย็น', '2026-09-15 18:42:26');

INSERT OR IGNORE INTO expense (expense_id, owner_id, expense_type, amount, expense_date, note) VALUES
(1, 1, 'ค่าเน็ต', 800, '2026-09-15', '');