-- Create banners table
CREATE TABLE IF NOT EXISTS public.banners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    image_url TEXT NOT NULL,
    link TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view active banners" 
    ON public.banners FOR SELECT 
    USING (active = TRUE);

CREATE POLICY "Admin can manage banners" 
    ON public.banners FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() 
            AND role IN ('staff', 'owner')
        )
    );

-- Index for fast lookup
CREATE INDEX idx_banners_active ON public.banners(active);
