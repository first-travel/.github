COMPOSE := docker compose -f infrastructure/docker/docker-compose.yml
SERVICE ?= app

.PHONY: help up down restart logs shell fresh seed test lint check build-fe \
        backend-test backend-lint backend-analyse frontend-test frontend-lint frontend-build frontend-typecheck

help:
	@echo "Flowatik developer commands"
	@echo "  make up        — start all services (visit http://acme.flowatik.localhost)"
	@echo "  make down      — stop all services"
	@echo "  make restart   — restart app + worker + scheduler"
	@echo "  make logs      — tail logs (SERVICE=app make logs)"
	@echo "  make shell     — shell into the app container"
	@echo "  make fresh     — drop, recreate, migrate, seed (DB)"
	@echo "  make seed      — re-seed without dropping"
	@echo "  make test      — backend + frontend tests"
	@echo "  make lint      — backend + frontend lint"
	@echo "  make check     — run everything CI would run"
	@echo "  make build-fe  — production frontend build"

# ─── Lifecycle ─────────────────────────────────────────────────────────
up:
	$(COMPOSE) up -d
	@echo ""
	@echo "▶ http://acme.flowatik.localhost"
	@echo "▶ http://wanderlust.flowatik.localhost"
	@echo "▶ Mailhog UI:  http://localhost:8025"

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart app worker scheduler

logs:
	$(COMPOSE) logs -f --tail=200 $(SERVICE)

shell:
	$(COMPOSE) exec app bash

# ─── Database ──────────────────────────────────────────────────────────
fresh:
	$(COMPOSE) exec app php artisan migrate:fresh --seed

seed:
	$(COMPOSE) exec app php artisan db:seed

# ─── Backend ───────────────────────────────────────────────────────────
backend-test:
	$(COMPOSE) exec app composer test

backend-lint:
	$(COMPOSE) exec app composer fmt:check

backend-analyse:
	$(COMPOSE) exec app composer analyse

# ─── Frontend ──────────────────────────────────────────────────────────
frontend-test:
	$(COMPOSE) exec frontend npm run test

frontend-lint:
	$(COMPOSE) exec frontend npm run lint

frontend-build:
	$(COMPOSE) exec frontend npm run build

frontend-typecheck:
	$(COMPOSE) exec frontend npm run type-check

build-fe: frontend-build

# ─── Composites ────────────────────────────────────────────────────────
test: backend-test frontend-test

lint: backend-lint frontend-lint

check: backend-lint backend-analyse backend-test frontend-lint frontend-typecheck frontend-test frontend-build
	@echo ""
	@echo "✓ All checks passed."
