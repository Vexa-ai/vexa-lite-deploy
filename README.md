<p align="left">
  <img src="assets/logodark.svg" alt="Vexa Logo" width="40"/>
</p>

# Vexa Lite - One-Click Deployment

**For end users:** Quick deployment configurations for **Vexa Lite** on your platform of choice, with a variety of open-source user interfaces to choose from.

> 📖 **Main Repository**: This repository provides deployment configurations. For core Vexa documentation, architecture details, and full feature set, see the [main Vexa repository](https://github.com/Vexa-ai/vexa).

## What is Vexa Lite?

**Vexa Lite** is a stateless, single-container version of Vexa designed for end users who want:
- **Quick deployment** on any platform (Fly.io, Railway, Render, etc.)
- **No GPU required** - transcription runs externally - though you can self host
- **Choose your UI** - pick from open-source interfaces like [Vexa Dashboard](https://github.com/Vexa-ai/Vexa-Dashboard)
- **Production-ready** - stateless, scalable, serverless-friendly

**Vexa Lite** is built from the [main Vexa repository](https://github.com/Vexa-ai/vexa) and packaged as `vexaai/vexa-lite:latest`.

> 💻 **For developers**: If you're developing Vexa or need the full stack with all services, see the [Docker Compose deployment guide](https://github.com/Vexa-ai/vexa/blob/main/docs/deployment.md).

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

## Quick Links

- **[Main Vexa Repository](https://github.com/Vexa-ai/vexa)** - Core API, services, and full documentation
- **[Vexa Lite Deployment Guide](https://github.com/Vexa-ai/vexa/blob/main/docs/vexa-lite-deployment.md)** - Complete setup examples and configuration reference (all 4 deployment configurations)
- **[Vexa Dashboard](https://github.com/Vexa-ai/Vexa-Dashboard)** - Open-source web UI for managing your Vexa instance

> 📖 **This repository provides platform-specific deployment configs**. For complete deployment examples with all configuration options (local/remote database, local/remote transcription), see the [Vexa Lite Deployment Guide](https://github.com/Vexa-ai/vexa/blob/main/docs/vexa-lite-deployment.md).

## User Interfaces

After deploying Vexa Lite, you can choose from a variety of open-source user interfaces:

- **[Vexa Dashboard](https://github.com/Vexa-ai/Vexa-Dashboard)** - Full-featured web UI with meeting management, real-time transcripts, AI assistant, and user management
- More UIs coming soon...

All UIs connect to your Vexa Lite API instance via REST and WebSocket.

## 🚀 Quick Deploy - Fly.io

Deploy Vexa Lite to Fly.io in minutes. See [detailed Fly.io deployment instructions](./fly/README.md) for step-by-step setup.

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

Deploy your own Vexa transcription service and use its API key. See the [Vexa deployment documentation](https://github.com/Vexa-ai/vexa/blob/main/docs/deployment.md) for self-hosting instructions.

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

- 📖 [Main Vexa Documentation](https://github.com/Vexa-ai/vexa/tree/main/docs) - Complete guides and API reference
- 📖 [Vexa Lite Deployment Guide](https://github.com/Vexa-ai/vexa/blob/main/docs/vexa-lite-deployment.md) - Detailed setup examples
- 💬 [Discord Community](https://discord.gg/Ga9duGkVz9)
- 🐛 [GitHub Issues](https://github.com/Vexa-ai/vexa/issues)

## Related Projects

- **[Vexa](https://github.com/Vexa-ai/vexa)** - Main repository with core API and services
- **[Vexa Dashboard](https://github.com/Vexa-ai/Vexa-Dashboard)** - Web interface for managing Vexa instances

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
