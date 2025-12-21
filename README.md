<p align="left">
  <img src="assets/logodark.svg" alt="Vexa Logo" width="40"/>
</p>

# Vexa Lite - One-Click Deployment

Deployment configurations for Vexa Lite - a lightweight API for real-time meeting transcription. See the [main Vexa repository](https://github.com/Vexa-ai/vexa) for project details and documentation.

<p align="left">
  <strong>🚀 Fly.io</strong>
  <span style="color: #999;">   Railway</span>
  <span style="color: #999;">   Render</span>
  <span style="color: #999;">   Google Cloud Run</span>
  <span style="color: #999;">   AWS</span>
  <span style="color: #999;">   Docker</span>
</p>

<p align="left">
  <img height="24" src="assets/google-meet.svg" alt="Google Meet" style="margin-right: 8px; vertical-align: middle;"/>
  <strong>Google Meet</strong>
    
  <img height="24" src="assets/microsoft-teams.svg" alt="Microsoft Teams" style="margin-right: 8px; vertical-align: middle;"/>
  <strong>Microsoft Teams</strong>
    
  <span style="color: #999;">Zoom (coming soon)</span>
</p>

## What is Vexa?

**Vexa** is an open-source, self-hostable API for real-time meeting transcription. This repository provides one-click deployment configurations to get Vexa Lite running on your preferred platform in minutes. No complex setup required - just configure your environment variables and deploy.

## 🚀 Quick Deploy - Fly.io

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
- Transcription API key - get it from [https://staging.vexa.ai/dashboard/transcription](https://staging.vexa.ai/dashboard/transcription) or self-host your own Vexa transcription service 

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

### Other Providers
Many cloud providers offer managed PostgreSQL databases. Just ensure your connection string is in the format: `postgresql://user:password@host:port/database`

## 🔑 Getting a Transcription API Key

**Option 1: Use Vexa Transcription Service**

1. Go to [https://staging.vexa.ai/dashboard/transcription](https://staging.vexa.ai/dashboard/transcription)
2. Sign up or log in
3. Navigate to API Keys
4. Create a new API key
5. Copy and use in your deployment

**Option 2: Self-Host Your Own Transcription Service**

Deploy your own Vexa transcription service and use its API key. See the [Vexa documentation](https://github.com/Vexa-ai/vexa) for self-hosting instructions.

## 🧪 Verify Deployment

After deployment, verify your installation:

```bash
# Health check
curl https://your-app-url/

# API documentation
open https://your-app-url/docs
```

## 🤝 Contributing

We'd love your help adding more deployment options! This repository currently supports Fly.io, but we want to make Vexa Lite easy to deploy on any platform.

### How to Contribute a New Deployment Option

1. **Create a new directory** for your platform (e.g., `railway/`, `render/`, `docker/`, etc.)
2. **Add deployment files**:
   - Configuration files (e.g., `railway.toml`, `render.yaml`, `docker-compose.yml`)
   - Deployment script (e.g., `deploy.sh`) if applicable
   - README with step-by-step instructions
3. **Update the main README** to include your platform in the Quick Deploy section
4. **Submit a pull request** with:
   - Clear instructions
   - Example `.env` file (without secrets)
   - Troubleshooting tips

### Example Structure

```
vexa-lite-deploy/
├── fly/
│   ├── deploy.sh
│   ├── fly.toml
│   ├── .env.example
│   └── README.md
├── railway/          # Your new platform
│   ├── railway.toml
│   ├── deploy.sh
│   └── README.md
└── README.md          # Update this to include your platform
```

### Platforms We'd Love to See

- Railway
- Render
- Google Cloud Run
- AWS App Runner / ECS / Lambda
- DigitalOcean App Platform
- Heroku
- Vercel
- Netlify
- Azure Container Apps

- And more!

**Ready to contribute?** Open an issue or submit a PR! 🚀

## 🆘 Need Help?

- 📖 [Vexa Documentation](https://docs.vexa.ai)
- 💬 [Discord Community](https://discord.gg/vexa)
- 🐛 [GitHub Issues](https://github.com/Vexa-ai/vexa/issues)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
