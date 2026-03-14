-- ============================================================================
-- BEST SOLO — Supabase Users Role Migration
-- ============================================================================
-- Run this script in the Supabase SQL Editor to verify and enforce the
-- 'role' column on the 'users' table.
-- ============================================================================

-- 1. Ensure the 'role' column exists with the correct default and NOT NULL constraints.
-- If the column doesn't exist, this will create it. If it does, we will alter it below.
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'customer' NOT NULL;

-- 2. In case the column already existed but wasn't NOT NULL, update existing NULLs.
UPDATE public.users
SET role = 'customer'
WHERE role IS NULL;

-- Add the NOT NULL constraint if it wasn't there
ALTER TABLE public.users
ALTER COLUMN role SET NOT NULL;

-- Set the default value if it wasn't there
ALTER TABLE public.users
ALTER COLUMN role SET DEFAULT 'customer';

-- 3. Enforce the allowed values via a CHECK constraint.
-- Safe drop before adding to allow idempotency (re-running the script safely).
ALTER TABLE public.users
DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE public.users
ADD CONSTRAINT users_role_check 
CHECK (role IN ('customer', 'staff', 'owner'));

-- ============================================================================
-- Optional: Re-syncing auth.users metadata to public.users (if using trigger)
-- Ensure any trigger that creates users automatically applies 'customer' 
-- unless overridden. Your existing insert trigger should handle this natively
-- since the table column defaults to 'customer'.
-- ============================================================================
