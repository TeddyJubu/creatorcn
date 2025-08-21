# Docker Setup for CreatorCN

This project includes a complete Docker containerization setup with both development and production configurations.

## Prerequisites

- Docker (v20.0+)
- Docker Compose (v2.0+)

## Quick Start

### Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd creatorcn
   ```

2. **Set up environment variables**
   ```bash
   cp .env.docker .env
   # Edit .env file with your actual values (optional for local development)
   ```

3. **Start the development environment**
   ```bash
   docker compose up -d
   ```

   This will:
   - Build the application in development mode
   - Start a PostgreSQL database
   - Run database migrations
   - Start the Next.js development server with hot reload
   - Make the app available at http://localhost:3000

4. **View logs**
   ```bash
   docker compose logs -f app
   ```

### Production

1. **Set up production environment variables**
   ```bash
   cp .env.docker .env
   # Edit .env file with your production values
   ```

2. **Deploy with production configuration**
   ```bash
   docker compose -f docker-compose.prod.yml up -d
   ```

   This will:
   - Build an optimized production image
   - Start PostgreSQL database
   - Start the application with Nginx reverse proxy
   - Make the app available at http://localhost (port 80)

## Available Commands

```bash
# Start development environment
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f [service-name]

# Rebuild and restart
docker compose up -d --build

# Production deployment
docker compose -f docker-compose.prod.yml up -d

# Remove all containers and volumes (destructive)
docker compose down -v --remove-orphans
```

## Services

### Development (`docker-compose.yml`)

- **app**: Next.js application in development mode with hot reload
- **db**: PostgreSQL 15 database with persistent volume

### Production (`docker-compose.prod.yml`)

- **app**: Optimized Next.js application build
- **db**: PostgreSQL 15 database with persistent volume
- **nginx**: Reverse proxy with security headers and compression

## Environment Variables

The application supports the following environment variables:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `BASE_URL` | Application base URL | `http://localhost:3000` | No |
| `DATABASE_URL` | PostgreSQL connection string | Auto-generated for Docker | No |
| `BETTER_AUTH_SECRET` | Secret key for authentication | `dev-secret` | Yes (prod) |
| `GITHUB_CLIENT_ID` | GitHub OAuth client ID | - | No |
| `GITHUB_CLIENT_SECRET` | GitHub OAuth secret | - | No |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID | - | No |
| `GOOGLE_CLIENT_SECRET` | Google OAuth secret | - | No |
| `GOOGLE_API_KEY` | Google AI API key | - | No |
| `GROQ_API_KEY` | Groq API key | - | No |
| `GOOGLE_FONTS_API_KEY` | Google Fonts API key | - | No |

## Database

The setup uses PostgreSQL as the database. In Docker mode:
- Development: PostgreSQL runs in a container with data persisted in a volume
- The application automatically runs database migrations on startup
- Database is accessible on `localhost:5432` (user: `postgres`, password: `postgres`)

## Health Check

The application includes a health check endpoint at `/api/health` that returns:

```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "version": "0.1.0"
}
```

## Volumes

- `pgdata`: PostgreSQL data persistence
- Development mode also mounts source code for hot reload

## Troubleshooting

### Port Already in Use
```bash
# Kill processes using the ports
sudo lsof -ti:3000,5432,80 | xargs kill -9
```

### Database Connection Issues
```bash
# Check if database is ready
docker compose exec db pg_isready -U postgres

# View database logs
docker compose logs db
```

### Permission Issues
```bash
# Fix file permissions (if needed)
sudo chown -R $USER:$USER .
```

### Clean Restart
```bash
# Stop and remove all containers/volumes
docker compose down -v --remove-orphans

# Rebuild everything
docker compose up -d --build
```

## Advanced Usage

### Custom Database Configuration

To use an external database (like Neon), update the `DATABASE_URL` in your `.env` file:

```env
DATABASE_URL=postgresql://user:password@host:port/database
```

And remove the `db` service from docker-compose.yml.

### SSL/HTTPS in Production

1. Add SSL certificates to `./certs/` directory
2. Update `nginx.conf` to include SSL configuration
3. Update environment variables to use `https://`

### Scaling

For production scaling, consider using Docker Swarm or Kubernetes:

```bash
# Docker Swarm example
docker stack deploy -c docker-compose.prod.yml creatorcn
```

## Development Workflow

1. Make changes to your code
2. Changes are automatically reflected (hot reload in development mode)
3. Database schema changes: `docker compose exec app npx drizzle-kit push`
4. View logs: `docker compose logs -f app`

## Security Notes

- Change `BETTER_AUTH_SECRET` in production
- Use strong passwords for database in production
- Consider using secrets management for sensitive environment variables
- The Nginx configuration includes basic security headers