-- Add is_public column to videos table
ALTER TABLE videos
ADD COLUMN is_public BOOLEAN DEFAULT false;

-- Drop existing policies
DROP POLICY IF EXISTS "Videos are viewable by everyone" ON videos;
DROP POLICY IF EXISTS "Users can insert their own videos" ON videos;
DROP POLICY IF EXISTS "Users can update their own videos" ON videos;
DROP POLICY IF EXISTS "Users can delete their own videos" ON videos;

-- Create new RLS policies
CREATE POLICY "Videos are viewable by everyone" ON videos
  FOR SELECT USING (
    is_public = true 
    OR auth.uid() = user_id
  );

CREATE POLICY "Users can insert their own videos" ON videos
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own videos" ON videos
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own videos" ON videos
  FOR DELETE USING (auth.uid() = user_id);