-- Create product_reviews table
CREATE TABLE IF NOT EXISTS public.product_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure a customer can only review a product once
    UNIQUE(product_id, customer_id)
);

-- Enable RLS
ALTER TABLE public.product_reviews ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view product reviews" 
    ON public.product_reviews FOR SELECT 
    USING (true);

CREATE POLICY "Authenticated users can submit reviews" 
    ON public.product_reviews FOR INSERT 
    WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Users can update their own reviews" 
    ON public.product_reviews FOR UPDATE 
    USING (auth.uid() = customer_id);

CREATE POLICY "Users can delete their own reviews" 
    ON public.product_reviews FOR DELETE 
    USING (auth.uid() = customer_id);

-- Indexes
CREATE INDEX idx_reviews_product_id ON public.product_reviews(product_id);
CREATE INDEX idx_reviews_customer_id ON public.product_reviews(customer_id);

-- View for average ratings
CREATE OR REPLACE VIEW v_product_ratings AS
SELECT 
    product_id,
    COUNT(id) as review_count,
    AVG(rating)::DECIMAL(2,1) as average_rating
FROM public.product_reviews
GROUP BY product_id;
