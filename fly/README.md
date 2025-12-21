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

The script will deploy the application

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

After deployment, your application will be available at the URL provided by Fly.io. You can find it by running:
```bash
fly status -a vexa-lite
```

The URL will typically be in the format: `https://your-app-name.fly.dev`


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

