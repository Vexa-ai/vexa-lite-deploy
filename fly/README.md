# Vexa Lite - Fly.io Deployment

This directory contains the configuration files for deploying Vexa Lite to Fly.io.

## Prerequisites

1. Install [Fly.io CLI](https://fly.io/docs/hands-on/install-flyctl/)
2. Login to Fly.io: `fly auth login`
3. Ensure you have a Fly.io account

## Configuration

This deployment uses:
- **Database**: Any PostgreSQL database (Supabase used as a working example, not required)
- **Transcription**: Remote transcription service - get API key from [https://staging.vexa.ai/dashboard/transcription](https://staging.vexa.ai/dashboard/transcription) or self-host your own Vexa transcription service
- **Image**: `vexaai/vexa-lite:latest`

Copy env.example and rename to .env 

fill out your values



## Quick Deploy

### Option 1: Using the deployment script

```bash
chmod +x deploy.sh
./deploy.sh
```

The script will deploy the backend application. To also deploy the frontend dashboard, set `DEPLOY_FRONTEND=true` in your `.env` file.

### Option 2: Manual deployment

1. **Initialize the app** (first time only):
   ```bash
   fly launch --no-deploy --image vexaai/vexa-lite:latest
   ```

2. **Set secrets**:
   ```bash
   fly secrets set \
     DATABASE_URL="postgresql://user:password@host:5432/database" \
     ADMIN_API_TOKEN="your-secure-token-here" \
     TRANSCRIBER_API_KEY="your-transcriber-api-key-here" \
     -a vexa-lite
   ```

3. **Deploy**:
   ```bash
   fly deploy -a vexa-lite
   ```

## Viewing Logs

```bash
fly logs -a vexa-lite
```

## Checking Status

```bash
fly status -a vexa-lite
```

## Accessing the Application

After deployment, your backend application will be available at the URL provided by Fly.io. You can find it by running:
```bash
fly status -a vexa-lite
```

The URL will typically be in the format: `https://vexa-lite.fly.dev`

### Frontend Dashboard (Optional)

If you deployed the frontend dashboard (by setting `DEPLOY_FRONTEND=true`), it will be available at:
```bash
fly status -a vexa-dashboard
```

The dashboard URL will typically be: `https://vexa-dashboard.fly.dev`

The dashboard automatically connects to your backend API and uses the same `ADMIN_API_TOKEN` for authentication.


## Updating Secrets

To update a secret:

```bash
fly secrets set ADMIN_API_TOKEN="new-token" -a vexa-lite
```

This will automatically restart your application with the new secret.


### SSH into the container
```bash
fly ssh console -a vexa-lite
```

### View secrets (values hidden)
```bash
fly secrets list -a vexa-lite
```

### Restart the application
```bash
fly apps restart -a vexa-lite
```

## Frontend Dashboard Deployment

The deployment script supports optionally deploying the Vexa Dashboard frontend alongside the backend.

### Enable Frontend Deployment

1. Add to your `.env` file:
   ```bash
   DEPLOY_FRONTEND=true
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

The script will:
- Deploy the backend to `vexa-lite` app
- Deploy the frontend to `vexa-dashboard` app
- Automatically configure the frontend to connect to your backend
- Use the same `ADMIN_API_TOKEN` for authentication

### Manual Frontend Deployment

If you prefer to deploy the frontend manually:

1. **Set secrets**:
   ```bash
   fly secrets set \
     VEXA_API_URL="https://vexa-lite.fly.dev" \
     VEXA_ADMIN_API_URL="https://vexa-lite.fly.dev" \
     VEXA_ADMIN_API_KEY="your-admin-api-token" \
     -a vexa-dashboard
   ```

2. **Deploy**:
   ```bash
   fly deploy -a vexa-dashboard --config fly-dashboard.toml
   ```

### Frontend Configuration

The frontend uses the following environment variables (set via Fly secrets):
- `VEXA_API_URL` - Backend API URL (defaults to `https://vexa-lite.fly.dev`)
- `VEXA_ADMIN_API_URL` - Admin API URL (can be same as `VEXA_API_URL`)
- `VEXA_ADMIN_API_KEY` - Admin API key (same as backend's `ADMIN_API_TOKEN`)

