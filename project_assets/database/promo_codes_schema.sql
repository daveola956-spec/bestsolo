-- Create promo_codes table
CREATE TABLE IF NOT EXISTS public.promo_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
    discount_value DECIMAL(10, 2) NOT NULL,
    expiry_date TIMESTAMPTZ,
    max_usage INT,
    used_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.promo_codes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view valid promo codes" 
    ON public.promo_codes FOR SELECT 
    USING (
        (expiry_date IS NULL OR expiry_date > NOW()) AND 
        (max_usage IS NULL OR used_count < max_usage)
    );

-- Index for fast code lookup
CREATE INDEX idx_promo_codes_code ON public.promo_codes(code);
