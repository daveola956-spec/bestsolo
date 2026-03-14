# BEST SOLO - Database Schema Documentation

## 1. Database Overview

### 1.1 Database Information
- **Database**: PostgreSQL (via Supabase)
- **Version**: 15+
- **Encoding**: UTF-8
- **Timezone**: Africa/Lagos (GMT+1)

### 1.2 Naming Conventions

| Object | Convention | Example |
|--------|------------|---------|
| Tables | snake_case, plural | users, products |
| Columns | snake_case | user_id, created_at |
| Primary Keys | id | id (UUID) |
| Foreign Keys | table_name_id | user_id, product_id |
| Indexes | idx_table_column | idx_users_email |
| Constraints | cktable_column | ck_products_price |
| Views | v_table_name | v_active_products |

---

## 2. Core Tables

### 2.1 Users Table

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'staff', 'owner')),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_role ON users(role);

-- RLS Policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Staff can view all users"
    ON users FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('staff', 'owner')
        )
    );
```

### 2.2 Categories Table

```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT,
    parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- Seed Categories
INSERT INTO categories (name, slug, description, display_order) VALUES
('Women''s Dresses', 'womens-dresses', 'Elegant dresses for women', 1),
('Shoes', 'shoes', 'Footwear for all occasions', 2),
('Bags', 'bags', 'Handbags, clutches and more', 3),
('Accessories', 'accessories', 'Jewelry, scarves and accessories', 4),
('Kids', 'kids-clothing', 'Clothing for children', 5),
('Watches', 'watches', 'Classic and modern timepieces', 6);
```

### 2.3 Products Table

```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    base_price DECIMAL(12, 2) NOT NULL,
    discount_price DECIMAL(12, 2),
    images JSONB DEFAULT '[]'::jsonb,
    sizes JSONB DEFAULT '[]'::jsonb,
    colors JSONB DEFAULT '[]'::jsonb,
    material VARCHAR(255),
    care_instructions TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    sku_prefix VARCHAR(20),
    meta_title VARCHAR(60),
    meta_description VARCHAR(160),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_is_featured ON products(is_featured);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_products_created ON products(created_at DESC);
CREATE INDEX idx_products_name_search ON products USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));
```

### 2.4 Product Variants Table

```sql
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    size VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    color_hex VARCHAR(7),
    price DECIMAL(12, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    barcode VARCHAR(100),
    weight_kg DECIMAL(6, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(product_id, size, color)
);

CREATE INDEX idx_variants_product ON product_variants(product_id);
CREATE INDEX idx_variants_sku ON product_variants(sku);
CREATE INDEX idx_variants_stock ON product_variants(stock);
```

---

## 3. Order Management Tables

### 3.1 Addresses Table

```sql
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    lga VARCHAR(100),
    postal_code VARCHAR(20),
    delivery_instructions TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_addresses_user ON addresses(user_id);
```

### 3.2 Delivery Methods Table

```sql
CREATE TABLE delivery_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    estimated_days_min INT,
    estimated_days_max INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO delivery_methods (name, slug, description, price, estimated_days_min, estimated_days_max) VALUES
('Standard Delivery', 'standard', 'Standard shipping delivery', 1500, 5, 7),
('Express Delivery', 'express', 'Fast delivery within 2-3 days', 3000, 2, 3),
('Same Day Delivery', 'same-day', 'Delivery within 24 hours', 5000, 0, 1),
('Store Pickup', 'pickup', 'Pick up from our store', 0, 0, 0);
```

### 3.3 Orders Table

```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(20) NOT NULL UNIQUE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    guest_email VARCHAR(255),
    guest_phone VARCHAR(20),
    guest_name VARCHAR(255),
    
    -- Shipping
    shipping_name VARCHAR(255) NOT NULL,
    shipping_phone VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_state VARCHAR(100) NOT NULL,
    shipping_lga VARCHAR(100),
    delivery_method_id UUID NOT NULL REFERENCES delivery_methods(id),
    
    -- Totals
    subtotal DECIMAL(12, 2) NOT NULL,
    delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(12, 2) NOT NULL,
    
    -- Payment
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('monnify', 'cod')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    payment_reference VARCHAR(100),
    monnify_transaction_id VARCHAR(100),
    paid_at TIMESTAMPTZ,
    
    -- Order Status
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'completed', 'cancelled')),
    status_notes TEXT,
    
    -- COD Specific
    cod_fee DECIMAL(10, 2) DEFAULT 0,
    
    -- Timestamps
    confirmed_at TIMESTAMPTZ,
    processed_at TIMESTAMPTZ,
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancelled_reason TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
```

### 3.4 Order Items Table

```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    variant_id UUID REFERENCES product_variants(id),
    product_name VARCHAR(255) NOT NULL,
    variant_details VARCHAR(255),
    size VARCHAR(50),
    color VARCHAR(50),
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    total DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
```

### 3.5 Order Status History Table

```sql
CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_status_history_order ON order_status_history(order_id);
```

---

## 4. Cart & Wishlist Tables

### 4.1 Cart Items Table

```sql
CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    session_id VARCHAR(100),
    product_id UUID NOT NULL REFERENCES products(id),
    variant_id UUID REFERENCES product_variants(id),
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, variant_id),
    UNIQUE(session_id, variant_id)
);

CREATE INDEX idx_cart_user ON cart_items(user_id);
CREATE INDEX idx_cart_session ON cart_items(session_id);
```

### 4.2 Wishlist Table

```sql
CREATE TABLE wishlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, product_id)
);

CREATE INDEX idx_wishlist_user ON wishlist(user_id);
```

---

## 5. Payment Tables

### 5.1 Payment Transactions Table

```sql
CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'NGN',
    payment_method VARCHAR(20),
    monnify_transaction_id VARCHAR(100),
    monnify_payment_reference VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    gateway_response JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_payments_order ON payment_transactions(order_id);
CREATE INDEX idx_payments_monnify_id ON payment_transactions(monnify_transaction_id);
CREATE INDEX idx_payments_status ON payment_transactions(status);
```

---

## 6. Admin Management Tables

### 6.1 Staff Users Table

```sql
CREATE TABLE staff_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(50) UNIQUE,
    department VARCHAR(100),
    position VARCHAR(100),
    hire_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 6.2 Activity Logs Table

```sql
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    description TEXT,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_logs_user ON activity_logs(user_id);
CREATE INDEX idx_logs_action ON activity_logs(action);
CREATE INDEX idx_logs_created ON activity_logs(created_at DESC);
```

---

## 7. Marketing Tables

### 7.1 Discount Codes Table

```sql
CREATE TABLE discount_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(12, 2),
    max_uses INT,
    used_count INT DEFAULT 0,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_discounts_code ON discount_codes(code);
```

### 7.2 Applied Discounts Table

```sql
CREATE TABLE applied_discounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id),
    discount_code_id UUID NOT NULL REFERENCES discount_codes(id),
    discount_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 8. Notification Tables

### 8.1 Notifications Table

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    data JSONB,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
```

---

## 9. Database Functions & Triggers

### 9.1 Auto-generate Order Number

```sql
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
DECLARE
    year_str TEXT;
    count_this_year INT;
BEGIN
    year_str := TO_CHAR(NOW(), 'YY');
    
    SELECT COUNT(*) + 1 INTO count_this_year
    FROM orders
    WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM NOW());
    
    NEW.order_number := 'BS' || year_str || LPAD(count_this_year::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_order_number
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION generate_order_number();
```

### 9.2 Auto-generate SKU

```sql
CREATE OR REPLACE FUNCTION generate_variant_sku()
RETURNS TRIGGER AS $$
DECLARE
    product_sku TEXT;
BEGIN
    SELECT COALESCE(sku_prefix, 'BS') INTO product_sku
    FROM products
    WHERE id = NEW.product_id;
    
    NEW.sku := UPPER(product_sku) || '-' || 
               LEFT(NEW.size, 2) || '-' || 
               LEFT(NEW.color, 3) || 
               LPAD(NEW.id::TEXT, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_variant_sku
    BEFORE INSERT ON product_variants
    FOR EACH ROW
    EXECUTE FUNCTION generate_variant_sku();
```

### 9.3 Update Timestamp Trigger

```sql
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_categories_timestamp
    BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_products_timestamp
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_product_variants_timestamp
    BEFORE UPDATE ON product_variants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_orders_timestamp
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

---

## 10. Views

### 10.1 Active Products View

```sql
CREATE OR REPLACE VIEW v_active_products AS
SELECT 
    p.*,
    c.name AS category_name,
    c.slug AS category_slug,
    COUNT(DISTINCT pv.id) AS variant_count,
    SUM(pv.stock) AS total_stock,
    MIN(pv.price) AS min_price,
    MAX(pv.price) AS max_price
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN product_variants pv ON p.id = pv.product_id AND pv.is_active = TRUE
WHERE p.is_active = TRUE AND c.is_active = TRUE
GROUP BY p.id, c.id;
```

### 10.2 Order Summary View

```sql
CREATE OR REPLACE VIEW v_order_summary AS
SELECT 
    o.id,
    o.order_number,
    o.user_id,
    u.full_name AS customer_name,
    u.email AS customer_email,
    o.total,
    o.status,
    o.payment_status,
    o.payment_method,
    o.created_at,
    COUNT(oi.id) AS item_count
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, u.id;
```

---

## 11. Row Level Security (RLS) Policies

### 11.1 Products RLS

```sql
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active products"
    ON products FOR SELECT
    USING (is_active = TRUE);

CREATE POLICY "Staff can manage products"
    ON products FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('staff', 'owner')
        )
    );
```

### 11.2 Orders RLS

```sql
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
    ON orders FOR SELECT
    USING (
        user_id = auth.uid() 
        OR guest_email = (SELECT email FROM users WHERE id = auth.uid())
    );

CREATE POLICY "Staff can view all orders"
    ON orders FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('staff', 'owner')
        )
    );

CREATE POLICY "Staff can update orders"
    ON orders FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('staff', 'owner')
        )
    );
```

### 11.3 Cart RLS

```sql
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own cart"
    ON cart_items FOR ALL
    USING (user_id = auth.uid());

CREATE POLICY "Guests can manage session cart"
    ON cart_items FOR ALL
    USING (session_id = current_setting('app.session_id', TRUE));
```

---

## 12. Seed Data

### 12.1 Admin User

```sql
-- Password: Admin@123 (hash generated)
INSERT INTO users (
    email,
    password_hash,
    full_name,
    phone,
    role,
    is_verified,
    is_active
) VALUES (
    'admin@bestsolo.com',
    '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'BEST SOLO Admin',
    '+2348000000000',
    'owner',
    TRUE,
    TRUE
);
```

### 12.2 Sample Categories

```sql
INSERT INTO categories (name, slug, description, display_order, is_active) VALUES
('Women''s Dresses', 'womens-dresses', 'Elegant dresses for women', 1, TRUE),
('Shoes', 'shoes', 'Footwear for all occasions', 2, TRUE),
('Bags', 'bags', 'Handbags, clutches and more', 3, TRUE),
('Accessories', 'accessories', 'Jewelry, scarves and accessories', 4, TRUE),
('Kids Clothing', 'kids-clothing', 'Clothing for children', 5, TRUE),
('Watches', 'watches', 'Classic and modern timepieces', 6, TRUE);

-- Subcategories
INSERT INTO categories (name, slug, description, parent_id, display_order) VALUES
('Casual Dresses', 'casual-dresses', 'Casual day dresses', (SELECT id FROM categories WHERE slug = 'womens-dresses'), 1),
('Formal Dresses', 'formal-dresses', 'Formal evening dresses', (SELECT id FROM categories WHERE slug = 'womens-dresses'), 2),
('Heels', 'heels', 'High heels and pumps', (SELECT id FROM categories WHERE slug = 'shoes'), 1),
('Sneakers', 'sneakers', 'Casual sneakers', (SELECT id FROM categories WHERE slug = 'shoes'), 2);
```

---

## 13. Database Maintenance

### 13.1 Vacuum & Analyze

```sql
-- Schedule weekly maintenance
VACUUM (VERBOSE, ANALYZE) users;
VACUUM (VERBOSE, ANALYZE) products;
VACUUM (VERBOSE, ANALYZE) orders;
```

### 13.2 Index Maintenance

```sql
-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE schemaname = 'public';
```

---

## 14. Migration Strategy

### 14.1 Version Control
- All schema changes in `/supabase/migrations/`
- Version format: `001_initial_schema.sql`
- Never modify migrations after merging

### 14.2 Deployment Process
1. Create migration in development
2. Test in staging environment
3. Apply to production with Supabase CLI
4. Verify with health checks
