-- ============================================================
-- BEST SOLO — Supabase Row-Level Security (RLS) Policies
-- ============================================================
-- Apply these policies in the Supabase Dashboard:
--   Database → Tables → [table] → Policies
-- Or run in the SQL Editor.
-- ============================================================

-- ── Enable RLS on all sensitive tables ──────────────────────
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- ORDERS
-- ============================================================
-- Customers can only view their own orders.
CREATE POLICY "Customers: view own orders"
  ON orders FOR SELECT
  USING (auth.uid() = customer_id);

-- Customers can create orders for themselves.
CREATE POLICY "Customers: create own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = customer_id);

-- Admins (owner/staff) can view and update all orders.
CREATE POLICY "Admins: full order access"
  ON orders FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
        AND role IN ('owner', 'staff')
    )
  );

-- ============================================================
-- ORDER ITEMS
-- ============================================================
CREATE POLICY "Customers: view own order items"
  ON order_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
        AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Customers: insert own order items"
  ON order_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
        AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Admins: full order item access"
  ON order_items FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
        AND role IN ('owner', 'staff')
    )
  );

-- ============================================================
-- WISHLIST
-- ============================================================
CREATE POLICY "Customers: manage own wishlist"
  ON wishlist FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- PRODUCT REVIEWS
-- ============================================================
-- Anyone authenticated can read reviews.
CREATE POLICY "Public: read reviews"
  ON product_reviews FOR SELECT
  USING (true);

-- Users can only insert/update/delete their own reviews.
CREATE POLICY "Customers: manage own reviews"
  ON product_reviews FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- ADDRESSES (shipping_addresses)
-- ============================================================
CREATE POLICY "Customers: manage own addresses"
  ON addresses FOR ALL
  USING (auth.uid() = customer_id)
  WITH CHECK (auth.uid() = customer_id);

-- ============================================================
-- BANNERS
-- ============================================================
-- Public can read active banners.
CREATE POLICY "Public: read active banners"
  ON banners FOR SELECT
  USING (active = true);

-- Only admins can manage banners.
CREATE POLICY "Admins: manage banners"
  ON banners FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
        AND role IN ('owner', 'staff')
    )
  );

-- ============================================================
-- PROMO CODES
-- ============================================================
-- Authenticated users can read active promo codes (for validation).
CREATE POLICY "Authenticated: read active promos"
  ON promo_codes FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND is_active = true
  );

-- Only admins can create or manage promo codes.
CREATE POLICY "Admins: manage promo codes"
  ON promo_codes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
        AND role IN ('owner', 'staff')
    )
  );

-- ============================================================
-- PRODUCTS (Public read, admin write)
-- ============================================================
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public: read products"
  ON products FOR SELECT USING (true);

CREATE POLICY "Admins: manage products"
  ON products FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
        AND role IN ('owner', 'staff')
    )
  );
