# Vexa Lite - Fly.io Deployment

This directory contains the configuration files for deploying Vexa Lite to Fly.io.

## Prerequisites

1. Install [Fly.io CLI](https://fly.io/docs/hands-on/install-flyctl/)
2. Login to Fly.io: `fly auth login`
3. Ensure you have a Fly.io account

## Configuration

This deployment uses:
- **Database**: Supabase PostgreSQL (remote)
- **Transcription**: Remote transcription service
- **Image**: `vexaai/vexa-lite:latest`

### Environment Variables

Sensitive values are stored as Fly.io secrets (not in `fly.toml`):
- `DATABASE_URL` - PostgreSQL connection string
- `ADMIN_API_TOKEN` - Secret token for admin operations
- `TRANSCRIBER_API_KEY` - API key for transcription service

Non-sensitive values are in `fly.toml`:
- `DB_SSL_MODE` - Set to "require" for Supabase
- `TRANSCRIBER_URL` - Transcription service URL

## Quick Deploy

### Option 1: Using the deployment script

```bash
chmod +x deploy.sh
./deploy.sh
```

The script will:
1. Generate a secure `ADMIN_API_TOKEN` (or use one you provide)
2. Set all secrets in Fly.io
3. Deploy the application

### Option 2: Manual deployment

1. **Initialize the app** (first time only):
   ```bash
   fly launch --no-deploy --image vexaai/vexa-lite:latest
   ```

2. **Set secrets**:
   ```bash
   fly secrets set \
     DATABASE_URL="postgresql://postgres.pjvenernrdzkmpcisopl:CQC60hAD8bkjCMDe@aws-1-us-west-1.pooler.supabase.com:5432/postgres" \
     ADMIN_API_TOKEN="your-secure-token-here" \
     TRANSCRIBER_API_KEY="W5z0RXVG72-bF-pvA02LlIAL92yYqmrZyvgVyLuRZw0" \
     -a vexa-lite
   ```

   Generate a secure admin token:
   ```bash
   openssl rand -hex 32
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

After deployment, your application will be available at:
- `https://vexa-lite.fly.dev`

The API gateway runs on port 8056 (internal), exposed via Fly.io's HTTP service.

## Updating Secrets

To update a secret:

```bash
fly secrets set ADMIN_API_TOKEN="new-token" -a vexa-lite
```

This will automatically restart your application with the new secret.

## Scaling

To scale your application:

```bash
# Scale to 2 instances
fly scale count 2 -a vexa-lite

# Scale up memory/CPU
fly scale vm shared-cpu-2x --memory 2048 -a vexa-lite
```

## Troubleshooting

### Database Connection Issues

If you see "Circuit breaker open: Too many authentication errors":
1. **Wait 5-10 minutes** for Supabase's circuit breaker to reset
2. Verify your database credentials are correct in Supabase dashboard
3. Check that you're using the **Session Pooler** connection string (not Direct)
4. Verify the DB_* secrets are set correctly:
   ```bash
   fly secrets list -a vexa-lite
   ```

### Check application logs
```bash
fly logs -a vexa-lite
```

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



## Configuration Details

- **Internal Port**: 8056 (Vexa Lite API Gateway)
- **Region**: sjc (San Jose, US West) - adjust in `fly.toml` if needed
- **VM Size**: shared-cpu-1x, 512MB RAM (adjust in `fly.toml` if needed)
- **Health Check**: Configured to check `/health` endpoint

## Security Notes

- All sensitive credentials are stored as Fly.io secrets
- Database connection uses SSL (DB_SSL_MODE=require)
- HTTPS is enforced by Fly.io (force_https = true)
- Never commit secrets to version control

