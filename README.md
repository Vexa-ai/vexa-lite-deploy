# Vexa Lite - One-Click Deployment

Deploy Vexa Lite to your preferred platform in minutes. This repository contains deployment configurations for multiple services.

## 🚀 Quick Deploy Options

### Option 1: Fly.io (Recommended)

**Deploy in 2 commands:**

```bash
cd fly
chmod +x deploy.sh
./deploy.sh
```

**What you need:**
- [Fly.io CLI](https://fly.io/docs/hands-on/install-flyctl/) installed
- Fly.io account (free tier available)
- Database URL (Supabase, Neon, or any PostgreSQL)
- Transcription API key

**Setup:**
1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Login: `fly auth login`
3. Create `.env` file in `fly/` directory:
   ```bash
   DATABASE_URL=postgresql://user:pass@host:5432/dbname
   TRANSCRIBER_API_KEY=your-api-key
   ADMIN_API_TOKEN=your-secure-token  # Optional, will be auto-generated
   ```
4. Run `./deploy.sh`

**That's it!** Your app will be live at `https://vexa-lite.fly.dev`

📖 [Detailed Fly.io instructions](./fly/README.md)

---

### Option 2: Docker (Self-Hosted)

**Deploy in 1 command:**

```bash
docker run -d \
  --name vexa-lite \
  -p 8056:8056 \
  -e DATABASE_URL="postgresql://user:pass@host:5432/dbname" \
  -e TRANSCRIBER_API_KEY="your-api-key" \
  -e ADMIN_API_TOKEN="your-secure-token" \
  -e TRANSCRIBER_URL="https://transcription.vexa.ai/v1/audio/transcriptions" \
  -e DB_SSL_MODE="require" \
  vexaai/vexa-lite:latest
```

**Access:**
- API: `http://localhost:8056/docs`
- Health: `http://localhost:8056/`

---

### Option 3: Docker Compose

**Deploy with a single file:**

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  vexa-lite:
    image: vexaai/vexa-lite:latest
    ports:
      - "8056:8056"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - TRANSCRIBER_API_KEY=${TRANSCRIBER_API_KEY}
      - ADMIN_API_TOKEN=${ADMIN_API_TOKEN}
      - TRANSCRIBER_URL=https://transcription.vexa.ai/v1/audio/transcriptions
      - DB_SSL_MODE=require
    restart: unless-stopped
```

Create `.env` file:
```bash
DATABASE_URL=postgresql://user:pass@host:5432/dbname
TRANSCRIBER_API_KEY=your-api-key
ADMIN_API_TOKEN=$(openssl rand -hex 32)
```

Deploy:
```bash
docker compose up -d
```

---

### Option 4: Railway

**Deploy via Railway Dashboard:**

1. Go to [Railway](https://railway.app)
2. Click "New Project" → "Deploy from GitHub"
3. Select this repository
4. Add environment variables:
   - `DATABASE_URL` (Railway can provision PostgreSQL automatically)
   - `TRANSCRIBER_API_KEY`
   - `ADMIN_API_TOKEN` (generate with `openssl rand -hex 32`)
   - `TRANSCRIBER_URL=https://transcription.vexa.ai/v1/audio/transcriptions`
   - `DB_SSL_MODE=require`
5. Set Docker image: `vexaai/vexa-lite:latest`
6. Set port: `8056`
7. Deploy!

---

### Option 5: Render

**Deploy via Render Dashboard:**

1. Go to [Render](https://render.com)
2. Click "New" → "Web Service"
3. Connect your repository or use Docker image: `vexaai/vexa-lite:latest`
4. Configure:
   - **Name**: `vexa-lite`
   - **Environment**: `Docker`
   - **Docker Image**: `vexaai/vexa-lite:latest`
   - **Port**: `8056`
5. Add environment variables:
   - `DATABASE_URL` (Render can provision PostgreSQL)
   - `TRANSCRIBER_API_KEY`
   - `ADMIN_API_TOKEN`
   - `TRANSCRIBER_URL=https://transcription.vexa.ai/v1/audio/transcriptions`
   - `DB_SSL_MODE=require`
6. Deploy!

---

### Option 6: Google Cloud Run

**Deploy via gcloud CLI:**

```bash
gcloud run deploy vexa-lite \
  --image vexaai/vexa-lite:latest \
  --platform managed \
  --region us-central1 \
  --port 8056 \
  --set-env-vars="TRANSCRIBER_URL=https://transcription.vexa.ai/v1/audio/transcriptions,DB_SSL_MODE=require" \
  --set-secrets="DATABASE_URL=DATABASE_URL:latest,TRANSCRIBER_API_KEY=TRANSCRIBER_API_KEY:latest,ADMIN_API_TOKEN=ADMIN_API_TOKEN:latest" \
  --allow-unauthenticated
```

**Or via Console:**
1. Go to [Cloud Run](https://console.cloud.google.com/run)
2. Click "Create Service"
3. Select "Deploy one revision from an existing container image"
4. Image: `vexaai/vexa-lite:latest`
5. Port: `8056`
6. Add environment variables and secrets
7. Deploy!

---

### Option 7: AWS App Runner

**Deploy via AWS Console:**

1. Go to [AWS App Runner](https://console.aws.amazon.com/apprunner)
2. Click "Create service"
3. Source: "Container registry" → "Amazon ECR Public"
4. Image URI: `public.ecr.aws/vexaai/vexa-lite:latest` (or use Docker Hub)
5. Port: `8056`
6. Add environment variables:
   - `DATABASE_URL`
   - `TRANSCRIBER_API_KEY`
   - `ADMIN_API_TOKEN`
   - `TRANSCRIBER_URL=https://transcription.vexa.ai/v1/audio/transcriptions`
   - `DB_SSL_MODE=require`
7. Deploy!

---

## 📋 Required Environment Variables

All deployment methods require these variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string | ✅ Yes |
| `TRANSCRIBER_API_KEY` | API key for transcription service | ✅ Yes |
| `ADMIN_API_TOKEN` | Secret token for admin operations | ✅ Yes |
| `TRANSCRIBER_URL` | Transcription service endpoint | No (default provided) |
| `DB_SSL_MODE` | Database SSL mode | No (default: `require`) |

**Generate secure tokens:**
```bash
# Generate ADMIN_API_TOKEN
openssl rand -hex 32
```

## 🗄️ Database Setup

Vexa Lite requires PostgreSQL. Quick setup options:

### Supabase (Recommended)
1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Copy the connection string from Settings → Database
4. Use the **Session Pooler** connection string (port 5432)

### Neon
1. Go to [neon.tech](https://neon.tech)
2. Create a new project
3. Copy the connection string from the dashboard

### Railway/Render
Both platforms can automatically provision PostgreSQL databases. Just connect them to your Vexa Lite service.

## 🔑 Getting a Transcription API Key

1. Go to [vexa.ai/dashboard](https://vexa.ai/dashboard)
2. Sign up or log in
3. Navigate to API Keys
4. Create a new API key
5. Copy and use in your deployment

## 🧪 Verify Deployment

After deployment, verify your installation:

```bash
# Health check
curl https://your-app-url/

# API documentation
open https://your-app-url/docs
```

## 📚 Platform-Specific Guides

- [Fly.io Detailed Guide](./fly/README.md) - Complete Fly.io deployment instructions

## 🔧 Troubleshooting

### Database Connection Issues

**Error: "Circuit breaker open"**
- Wait 5-10 minutes for the circuit breaker to reset
- Verify you're using the Session Pooler connection string (not Direct)
- Check database credentials

**Error: "Connection refused"**
- Verify `DATABASE_URL` is correct
- Check database firewall allows your deployment platform's IPs
- Ensure `DB_SSL_MODE=require` for cloud databases

### Application Not Starting

1. Check logs:
   ```bash
   # Fly.io
   fly logs -a vexa-lite
   
   # Docker
   docker logs vexa-lite
   ```

2. Verify all environment variables are set:
   ```bash
   # Fly.io
   fly secrets list -a vexa-lite
   ```

3. Check health endpoint:
   ```bash
   curl https://your-app-url/
   ```

## 🆘 Need Help?

- 📖 [Vexa Documentation](https://docs.vexa.ai)
- 💬 [Discord Community](https://discord.gg/vexa)
- 🐛 [GitHub Issues](https://github.com/Vexa-ai/vexa/issues)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
