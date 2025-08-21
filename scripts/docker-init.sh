#!/bin/sh
set -e

echo "🚀 CreatorCN Docker Init Script"

# Simple connection test using node
echo "⏳ Waiting for database to be ready..."
while ! timeout 1 bash -c "echo > /dev/tcp/db/5432" 2>/dev/null; do
  echo "   Database not ready, waiting..."
  sleep 2
done
echo "✅ Database is ready!"

# Check if we're in development mode
if [ "$NODE_ENV" = "development" ]; then
  echo "🔧 Development mode detected"
  
  # Run database migrations
  echo "📊 Running database migrations..."
  npx drizzle-kit push --verbose
  echo "✅ Database migrations completed!"
  
  # Start development server
  echo "🏃 Starting development server..."
  exec npm run dev
else
  echo "🏭 Production mode detected"
  
  # For production, we assume migrations are handled separately
  # or the app handles them internally
  
  # Start production server
  echo "🚀 Starting production server..."
  exec node server.js
fi