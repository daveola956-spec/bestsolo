-- Create wishlists table
CREATE TABLE IF NOT EXISTS public.wishlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure a customer can only have a product in their wishlist once
    UNIQUE(customer_id, product_id)
);

-- Enable RLS
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own wishlist items" 
    ON public.wishlists FOR SELECT 
    USING (auth.uid() = customer_id);

CREATE POLICY "Users can add items to their own wishlist" 
    ON public.wishlists FOR INSERT 
    WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Users can remove items from their own wishlist" 
    ON public.wishlists FOR DELETE 
    USING (auth.uid() = customer_id);

-- Indexes
CREATE INDEX idx_wishlists_customer_id ON public.wishlists(customer_id);
CREATE INDEX idx_wishlists_product_id ON public.wishlists(product_id);
