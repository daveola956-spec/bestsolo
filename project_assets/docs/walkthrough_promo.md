# Promo Codes Walkthrough

I have implemented a flexible promo code system for BEST SOLO, allowing users to apply discounts during checkout.

## Changes Made

### 1. Database & Domain
- **Database**: Created `promo_codes` table with support for:
  - Percentage or Fixed discounts.
  - Expiry dates.
  - Maximum usage limits.
  - Automatic usage tracking (`used_count`).
- **Models**: Created `PromoCode` model with validation logic and discount calculation methods.
- **Order Model**: Updated the `Order` model to include a `discountAmount` field, ensuring discounts are recorded in the database.

### 2. Infrastructure & State Management
- **Service**: Implemented `SupabasePromoService` for validating codes and incrementing usage.
- **BLoC**: Created `PromoBloc` to manage the lifecycle of a promo code during a checkout session (Initial -> Loading -> Applied/Error).
- **Dependency Injection**: Registered all components and provided `PromoBloc` globally.

### 3. UI Integration
- **Checkout Screen**: 
  - Added a new "Order Summary" section with a promo code input.
  - Real-time validation with loading indicators.
  - Visual feedback for applied codes (green checkmark, "Remove" button).
  - Dynamic price summary that shows Subtotal, Discount (if any), and the final Total.
  - Automatic usage increment upon successful order placement.

## Verification Results

### Manual Verification
- **Valid Codes**: Entering a valid code (e.g., `PERCENT10` or `FIXED500`) correctly updates the total.
- **Invalid Codes**: Entering a non-existent code shows a clear error message.
- **Expired/Maxed Codes**: The BLoC correctly detects expired or fully used codes and informs the user.
- **Removal**: Users can remove an applied code to use a different one or none.
- **Persistence**: The discount is correctly passed to the `Order` object and stored in the database's `discount_amount` column.
