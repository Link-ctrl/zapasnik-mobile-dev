-- Таблица Users
CREATE TABLE Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    password_hash TEXT,
    role TEXT
);

-- Таблица Families
CREATE TABLE Families (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица FamilyMembers
CREATE TABLE FamilyMembers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    family_id INTEGER,
    user_id INTEGER,
    role TEXT,
    FOREIGN KEY (family_id) REFERENCES Families(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Таблица Products
CREATE TABLE Products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    category TEXT,
    description TEXT,
    photo_url TEXT,
    barcode TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица Inventory
CREATE TABLE Inventory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    family_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    expiration_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (family_id) REFERENCES Families(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);

-- Таблица Transactions
CREATE TABLE Transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    family_id INTEGER,
    product_id INTEGER,
    user_id INTEGER,
    action TEXT,
    quantity INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (family_id) REFERENCES Families(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Таблица Notifications
CREATE TABLE Notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    product_id INTEGER,
    message TEXT,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);