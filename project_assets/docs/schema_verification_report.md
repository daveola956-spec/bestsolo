# BEST SOLO Database Schema Verification Report

This report compares the requested database schema expectations against the project's documentation (`docs/Database.md`) and the implemented Dart models (`lib/domain/models/`).

## 1. Expected Tables vs. Actual Design/Implementation

| Expected Table | Status in Docs | Status in Models | Notes |
| :--- | :--- | :--- | :--- |
| `categories` | ✔ Present | ✔ Present | `Category` model exists. |
| `products` | ✔ Present | ✔ Present | `Product` model exists. |
| `product_variants` | ✔ Present | ✔ Present | `ProductVariant` model exists. |
| `product_images` | ⚠ Missing | ✔ Present | Design uses a `JSONB images` column in `products`. The Dart model uses a separate `ProductImage` class list. **Inconsistency**. |
| `customers` | ❌ Missing | ❌ Missing | Design uses a unified `users` table with a `role = 'customer'`. No `Customer` Dart model; uses `AuthState`. |
| `orders` | ✔ Present | ✔ Present | `Order` model exists. |
| `order_items` | ✔ Present | ✔ Present | `OrderItem` model exists. |
| `shipping_addresses`| ⚠ Missing | ✔ Present | Design uses `addresses` table. Dart model uses `ShippingAddress`. **Naming inconsistency**. |
| `admin_users` | ❌ Missing | ❌ Missing | Design uses a unified `users` table with role `owner`/`staff`, plus `staff_profiles`. No `AdminUser` Dart model. |

## 2. Detailed Inconsistencies

### `product_images`
*   **Design (`Database.md`)**: The `products` table has an `images JSONB DEFAULT '[]'::jsonb` column. It does *not* have a separate `product_images` table.
*   **Implementation**: There is a Dart model `ProductImage` mapped from an `images` list.
*   **Result**: ⚠ **Warning**. While functional, the database is using a JSON column instead of an expected relational table.

### `customers`
*   **Design**: The user requested a check for a `customers` table. The design document utilizes a centralized `users` table with a `role VARCHAR(20)` column (customer, staff, owner).
*   **Implementation**: There is no `Customer` Dart model. The app currently uses the `AuthUser` / Supabase auth user for customer data.
*   **Result**: ❌ **Violation**. The requested `customers` table does not exist.

### `shipping_addresses`
*   **Design**: The design document defines an `addresses` table (linked to `users`).
*   **Implementation**: The Dart model is named `ShippingAddress` and expects a `shipping_addresses` JSON sub-object from Supabase.
*   **Result**: ⚠ **Warning**. The naming convention is inconsistent between the documented database (`addresses`) and the application logic mapping (`shipping_addresses`).

### `admin_users`
*   **Design**: The user requested a check for an `admin_users` table. The design document utilizes the `users` table (with role) and a `staff_profiles` table for extra details.
*   **Implementation**: There is no specific `AdminUser` Dart model.
*   **Result**: ❌ **Violation**. The requested `admin_users` table does not exist.

## 3. Relationships & Foreign Keys

*   ✔ `product_variants` correctly references `products(id) ON DELETE CASCADE`.
*   ✔ `orders` correctly references `users(id)` (acting as customers).
*   ✔ `order_items` correctly references `orders(id)` and `products(id)`.
*   ⚠ **Warning**: The `Order` Dart model has a `customerId` field mapping to `customer_id` in JSON, but the `Database.md` schema specifies `user_id` for the `orders` table.

## 4. Indexes

*   ✔ Indexes are well-defined in the `Database.md` design for critical lookups (e.g., `idx_products_category`, `idx_orders_user`).

## 5. Naming Conventions

*   ✔ Global naming conventions (`snake_case` for columns, `table_name_id` for FKs) are mostly followed in the design document.
*   ❌ **Violation**: The backend schema expects `user_id` in `orders`, but the frontend `Order.fromJson` expects `customer_id`.
*   ❌ **Violation**: The backend schema expects `addresses`, but the frontend `Order.fromJson` expects `shipping_addresses` (or `shipping_address_id`).

## Summary of Actionable Items

To align the Flutter models with the documented database schema (or vice versa), the following reconciling actions are required:

1.  Decide whether to use a unified `users` table or split into `customers`/`admin_users`. If unified is kept, update the frontend JSON mapping in `Order` from `customer_id` to `user_id`.
2.  Align the address table naming (`addresses` vs `shipping_addresses`).
3.  Clarify if product images should be a JSON array (current Database.md) or a separate table (requested).
