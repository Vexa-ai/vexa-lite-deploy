#!/bin/bash
set -e

# Configuration
APP_NAME="vexa-lite"
DATABASE_URL="postgresql://postgres.pjvenernrdzkmpcisopl:CQC60hAD8bkjCMDe@aws-1-us-west-1.pooler.supabase.com:5432/postgres"
TRANSCRIBER_API_KEY="W5z0RXVG72-bF-pvA02LlIAL92yYqmrZyvgVyLuRZw0"

# Generate a secure admin token if not provided
if [ -z "$ADMIN_API_TOKEN" ]; then
  ADMIN_API_TOKEN=$(openssl rand -hex 32)
  echo "🔑 Generated ADMIN_API_TOKEN: $ADMIN_API_TOKEN"
else
  echo "🔑 Using provided ADMIN_API_TOKEN"
fi

echo "🚀 Deploying $APP_NAME to Fly.io..."
echo ""

# Set secrets in fly.io (sensitive values)
echo "🔐 Setting secrets..."
fly secrets set \
  DATABASE_URL="$DATABASE_URL" \
  ADMIN_API_TOKEN="$ADMIN_API_TOKEN" \
  TRANSCRIBER_API_KEY="$TRANSCRIBER_API_KEY" \
  -a "$APP_NAME"

# Deploy to fly.io
echo ""
echo "📦 Deploying application..."
fly deploy -a "$APP_NAME"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Configuration:"
echo "   App: $APP_NAME"
echo "   URL: https://$APP_NAME.fly.dev"
echo "   Admin API Token: $ADMIN_API_TOKEN"
echo ""
echo "💡 Save your ADMIN_API_TOKEN securely - you'll need it for API access!"

