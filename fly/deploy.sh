#!/bin/bash
set -e

# Load environment variables from .env file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
  echo "📄 Loading environment variables from .env file..."
  set -a  # automatically export all variables
  source "$SCRIPT_DIR/.env"
  set +a
else
  echo "⚠️  Warning: .env file not found. Using defaults or environment variables."
fi

# Configuration
APP_NAME="vexa-lite"

# Use values from .env or fallback to defaults
if [ -z "$DATABASE_URL" ]; then
  echo "❌ ERROR: DATABASE_URL not set. Please set it in .env file or as environment variable."
  exit 1
fi

if [ -z "$TRANSCRIBER_API_KEY" ]; then
  echo "❌ ERROR: TRANSCRIBER_API_KEY not set. Please set it in .env file or as environment variable."
  exit 1
fi

# Generate a secure admin token if not provided
if [ -z "$ADMIN_API_TOKEN" ]; then
  ADMIN_API_TOKEN=$(openssl rand -hex 32)
  echo "🔑 Generated ADMIN_API_TOKEN: $ADMIN_API_TOKEN"
else
  echo "🔑 Using ADMIN_API_TOKEN from .env file"
fi

echo "🚀 Deploying $APP_NAME to Fly.io..."
echo ""

# Check if app exists, create if it doesn't
echo "🔍 Checking if app exists..."
if fly status -a "$APP_NAME" &>/dev/null; then
  echo "✅ App already exists"
else
  echo "📦 App doesn't exist. Creating app..."
  # Create the app (will fail if it already exists, which is fine)
  fly apps create "$APP_NAME" 2>/dev/null || {
    echo "   App may already exist or creation failed. Continuing..."
  }
fi

# Set secrets in fly.io (sensitive values)
echo ""
echo "🔐 Setting secrets..."
echo "   Using DATABASE_URL from .env file"
echo "   Database host: $(echo "$DATABASE_URL" | sed -E 's|.*@([^:]+):.*|\1|')"

# Use fly secrets set with proper quoting for special characters
fly secrets set \
  "DATABASE_URL=$DATABASE_URL" \
  "ADMIN_API_TOKEN=$ADMIN_API_TOKEN" \
  "TRANSCRIBER_API_KEY=$TRANSCRIBER_API_KEY" \
  -a "$APP_NAME"

# Check for stuck machines before deploying
echo ""
echo "🔍 Checking for stuck machines..."
# Check machine status and look for stopped machines
if fly machines list -a "$APP_NAME" 2>/dev/null | grep -q "stopped"; then
  echo "⚠️  Found stopped machines. Attempting cleanup..."
  # Get stopped machine IDs (second column in the table)
  STOPPED_MACHINES=$(fly machines list -a "$APP_NAME" 2>/dev/null | grep "stopped" | awk '{print $1}' | head -5 || true)
  
  if [ -n "$STOPPED_MACHINES" ]; then
    for MACHINE_ID in $STOPPED_MACHINES; do
      # Skip header rows or invalid IDs
      if [ -n "$MACHINE_ID" ] && [ "$MACHINE_ID" != "ID" ] && [ ${#MACHINE_ID} -gt 5 ]; then
        echo "   Destroying machine: $MACHINE_ID"
        fly machines destroy "$MACHINE_ID" -a "$APP_NAME" --force 2>/dev/null || true
      fi
    done
    echo "⏳ Waiting 10 seconds for cleanup and rate limit cooldown..."
    sleep 10
  fi
else
  echo "✅ No stuck machines found"
fi

# Deploy to fly.io with retry logic
echo ""
echo "📦 Deploying application..."
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if fly deploy -a "$APP_NAME" --ha=false; then
    break
  else
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
      WAIT_TIME=$((RETRY_COUNT * 10))
      echo "⚠️  Deployment failed. Waiting ${WAIT_TIME}s before retry ($RETRY_COUNT/$MAX_RETRIES)..."
      sleep $WAIT_TIME
    else
      echo "❌ Deployment failed after $MAX_RETRIES attempts"
      exit 1
    fi
  fi
done

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Configuration:"
echo "   App: $APP_NAME"
echo "   URL: https://$APP_NAME.fly.dev"
echo "   Admin API Token: $ADMIN_API_TOKEN"
echo ""
echo "💡 Save your ADMIN_API_TOKEN securely - you'll need it for API access!"

