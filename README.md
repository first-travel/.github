# Flowatik Travel Agency Platform

Multi-tenant SaaS for travel agencies. Backend: Laravel 11. Frontend: React 18 + Vite.

## Quick start

Prerequisites: Docker Desktop, GNU Make, Git. macOS or Linux (Windows: WSL2).

    git clone <repo>
    cd flowatik
    ./infrastructure/scripts/bootstrap.sh
    make up
    make fresh

Open <http://acme.flowatik.localhost> in a browser.

Full setup: [docs/local-setup/getting-started.md](docs/local-setup/getting-started.md)
Architecture: [docs/superpowers/specs/2026-06-08-platform-foundation-design.md](docs/superpowers/specs/2026-06-08-platform-foundation-design.md)

## Commands

| Command | What it does |
|---|---|
| `make up`      | start all services |
| `make down`    | stop all services |
| `make fresh`   | drop, recreate, migrate, seed |
| `make test`    | backend + frontend tests |
| `make lint`    | backend + frontend lint |
| `make check`   | run everything CI would run |
| `make shell`   | shell into the backend container |

## License

Proprietary.
