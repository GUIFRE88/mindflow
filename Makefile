# Mindflow - Makefile
# Comandos úteis para gerenciar a aplicação Rails com Docker

.PHONY: help start stop restart build clean logs shell console db-create db-migrate db-reset test install

# Variáveis
COMPOSE = docker compose
RAILS = $(COMPOSE) run --rm web rails
BUNDLE = $(COMPOSE) run --rm web bundle

# Comando padrão
help: ## Mostra esta ajuda
	@echo "🚀 Mindflow - Comandos disponíveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

start: ## Inicia a aplicação (build + install + start)
	@echo "🚀 Iniciando Mindflow..."
	$(COMPOSE) up

dev: ## Inicia em modo desenvolvimento
	@echo "🔧 Iniciando em modo desenvolvimento..."
	$(COMPOSE) up

stop: ## Para todos os containers
	@echo "⏹️ Parando containers..."
	$(COMPOSE) down

restart: ## Reinicia a aplicação
	@echo "🔄 Reiniciando aplicação..."
	$(MAKE) stop
	$(MAKE) start

clean: ## Remove containers, volumes e imagens
	@echo "🧹 Limpando containers e volumes..."
	$(COMPOSE) down -v --remove-orphans
	docker system prune -f

logs: ## Mostra logs da aplicação
	@echo "📋 Mostrando logs..."
	$(COMPOSE) logs -f

logs-web: ## Mostra logs apenas do web
	@echo "📋 Mostrando logs do web..."
	$(COMPOSE) logs -f web

logs-db: ## Mostra logs apenas do banco
	@echo "📋 Mostrando logs do banco..."
	$(COMPOSE) logs -f db

shell: ## Abre shell no container web
	@echo "🐚 Abrindo shell..."
	$(COMPOSE) run --rm web bash

console: ## Abre console Rails
	@echo "💻 Abrindo console Rails..."
	$(RAILS) console

install: ## Instala dependências
	@echo "📚 Instalando dependências..."
	$(BUNDLE) install

# Comandos de banco de dados
db-create: ## Cria o banco de dados
	@echo "🗃️ Criando banco de dados..."
	$(RAILS) db:create

db-migrate: ## Executa migrações
	@echo "🔄 Executando migrações..."
	$(RAILS) db:migrate

db-reset: ## Reseta o banco (drop + create + migrate)
	@echo "🔄 Resetando banco de dados..."
	$(RAILS) db:drop
	$(RAILS) db:create
	$(RAILS) db:migrate

db-seed: ## Executa seeds
	@echo "🌱 Executando seeds..."
	$(RAILS) db:seed

db-status: ## Mostra status das migrações
	@echo "📊 Status das migrações..."
	$(RAILS) db:migrate:status

# Comandos de desenvolvimento
generate: ## Gera um novo componente (uso: make generate MODEL=User)
	@echo "⚡ Gerando $(MODEL)..."
	$(RAILS) generate $(MODEL)

destroy: ## Remove um componente (uso: make destroy MODEL=User)
	@echo "🗑️ Removendo $(MODEL)..."
	$(RAILS) destroy $(MODEL)

routes: ## Mostra rotas da aplicação
	@echo "🛣️ Mostrando rotas..."
	$(RAILS) routes

# Comandos de teste
test: ## Executa testes
	@echo "🧪 Executando testes..."
	$(RAILS) test

test-coverage: ## Executa testes com coverage
	@echo "🧪 Executando testes com coverage..."
	$(RAILS) test --coverage

test-env: ## Executa testes com ambiente de teste
	@echo "🧪 Executando testes com ambiente de teste..."
	docker compose -f docker-compose.test.yml run --rm web rails test

# Comandos de produção
production: ## Inicia em modo produção
	@echo "🚀 Iniciando em modo produção..."
	$(COMPOSE) -f docker-compose.yml -f docker-compose.prod.yml up

# Comandos de backup
backup: ## Faz backup do banco de dados
	@echo "💾 Fazendo backup do banco..."
	$(COMPOSE) exec db pg_dump -U postgres mindflow_development > backup_$(shell date +%Y%m%d_%H%M%S).sql

# Comandos de monitoramento
ps: ## Mostra status dos containers
	@echo "📊 Status dos containers..."
	$(COMPOSE) ps

stats: ## Mostra estatísticas dos containers
	@echo "📈 Estatísticas dos containers..."
	docker stats

# Comandos de desenvolvimento avançado
lint: ## Executa linter
	@echo "🔍 Executando linter..."
	$(BUNDLE) exec rubocop

format: ## Formata código
	@echo "✨ Formatando código..."
	$(BUNDLE) exec rubocop -a

# Comandos de assets
assets-precompile: ## Precompila assets
	@echo "🎨 Precompilando assets..."
	$(RAILS) assets:precompile

assets-clean: ## Limpa assets compilados
	@echo "🧹 Limpando assets..."
	$(RAILS) assets:clobber

# Comandos de cache
cache-clear: ## Limpa cache
	@echo "🗑️ Limpando cache..."
	$(RAILS) tmp:clear

# Comandos de logs
log-tail: ## Segue logs em tempo real
	@echo "📋 Seguindo logs..."
	$(COMPOSE) logs -f --tail=100

# Comandos de rede
network-ls: ## Lista redes Docker
	@echo "🌐 Listando redes..."
	docker network ls

# Comandos de volume
volume-ls: ## Lista volumes Docker
	@echo "💾 Listando volumes..."
	docker volume ls

# Comandos de imagem
image-ls: ## Lista imagens Docker
	@echo "🖼️ Listando imagens..."
	docker images

# Comandos de sistema
system-info: ## Mostra informações do sistema
	@echo "💻 Informações do sistema..."
	@echo "Docker version: $$(docker --version)"
	@echo "Docker Compose version: $$(docker compose version)"
	@echo "Ruby version: $$(docker compose run --rm web ruby --version)"
	@echo "Rails version: $$(docker compose run --rm web rails --version)"

# Comandos de debug
debug: ## Abre container em modo debug
	@echo "🐛 Modo debug..."
	$(COMPOSE) run --rm web bash

# Comandos de atualização
update: ## Atualiza dependências
	@echo "⬆️ Atualizando dependências..."
	$(BUNDLE) update

# Comandos de limpeza avançada
deep-clean: ## Limpeza profunda (remove tudo)
	@echo "🧹 Limpeza profunda..."
	$(COMPOSE) down -v --remove-orphans
	docker system prune -af
	docker volume prune -f
	docker network prune -f

# Comandos de saúde
health: ## Verifica saúde da aplicação
	@echo "🏥 Verificando saúde da aplicação..."
	@curl -f http://localhost:3000 > /dev/null 2>&1 && echo "✅ Aplicação está funcionando" || echo "❌ Aplicação não está respondendo"

# Comandos de documentação
docs: ## Gera documentação
	@echo "📚 Gerando documentação..."
	$(RAILS) doc:generate

# Comandos de segurança
security: ## Verifica vulnerabilidades
	@echo "🔒 Verificando vulnerabilidades..."
	$(BUNDLE) exec bundle-audit

# Comandos de performance
benchmark: ## Executa benchmark
	@echo "⚡ Executando benchmark..."
	$(RAILS) benchmark

# Comandos de monitoramento avançado
monitor: ## Monitora aplicação
	@echo "📊 Monitorando aplicação..."
	watch -n 1 '$(MAKE) ps && echo "" && $(MAKE) stats'

# Comandos de desenvolvimento local
local-setup: ## Configura ambiente local
	@echo "🔧 Configurando ambiente local..."
	@echo "Instalando dependências locais..."
	gem install bundler
	bundle install

# Comandos de CI/CD
ci: ## Executa pipeline CI
	@echo "🔄 Executando pipeline CI..."
	$(MAKE) test
	$(MAKE) lint
	$(MAKE) security

# Comandos de deploy
deploy: ## Deploy da aplicação
	@echo "🚀 Fazendo deploy..."
	$(MAKE) build
	$(MAKE) test
	$(MAKE) production

# Comandos de rollback
rollback: ## Rollback da aplicação
	@echo "⏪ Fazendo rollback..."
	$(COMPOSE) down
	$(COMPOSE) up -d

# Comandos de backup avançado
backup-full: ## Backup completo
	@echo "💾 Backup completo..."
	$(MAKE) backup
	@echo "Backup salvo em backup_$(shell date +%Y%m%d_%H%M%S).sql"

# Comandos de restore
restore: ## Restaura backup (uso: make restore FILE=backup.sql)
	@echo "🔄 Restaurando backup..."
	$(COMPOSE) exec -T db psql -U postgres mindflow_development < $(FILE)

# Comandos de desenvolvimento
dev-setup: ## Configura ambiente de desenvolvimento
	@echo "🔧 Configurando ambiente de desenvolvimento..."
	$(MAKE) install
	$(MAKE) db-create
	$(MAKE) db-migrate
	$(MAKE) db-seed

# Comandos de produção
build: ## Configura ambiente de produção
	@echo "🚀 Configurando ambiente de produção..."
	$(MAKE) build
	$(MAKE) db-create
	$(MAKE) db-migrate
	$(MAKE) assets-precompile

# Comandos de manutenção
maintenance: ## Entra em modo manutenção
	@echo "🔧 Modo manutenção..."
	$(COMPOSE) down
	$(COMPOSE) up -d db
	@echo "Banco de dados disponível para manutenção"

# Comandos de emergência
emergency: ## Modo emergência
	@echo "🚨 Modo emergência..."
	$(COMPOSE) down
	$(COMPOSE) up -d db
	@echo "Apenas banco de dados está rodando"

# Comandos de ambiente
env-setup: ## Configura arquivos de ambiente
	@echo "🔧 Configurando arquivos de ambiente..."
	@if [ ! -f .env.development ]; then cp .env.example .env.development; echo "✅ Criado .env.development"; fi
	@if [ ! -f .env.test ]; then cp .env.example .env.test; echo "✅ Criado .env.test"; fi
	@echo "📝 Edite os arquivos .env.development e .env.test conforme necessário"

env-check: ## Verifica arquivos de ambiente
	@echo "🔍 Verificando arquivos de ambiente..."
	@if [ -f .env.development ]; then echo "✅ .env.development existe"; else echo "❌ .env.development não encontrado"; fi
	@if [ -f .env.test ]; then echo "✅ .env.test existe"; else echo "❌ .env.test não encontrado"; fi
	@if [ -f .env.example ]; then echo "✅ .env.example existe"; else echo "❌ .env.example não encontrado"; fi

# Comandos de status
status: ## Status completo da aplicação
	@echo "📊 Status completo:"
	@echo "=================="
	$(MAKE) ps
	@echo ""
	$(MAKE) health
	@echo ""
	$(MAKE) system-info

# Comandos de ajuda avançada
help-all: ## Mostra todos os comandos disponíveis
	@echo "🚀 Mindflow - Todos os comandos disponíveis:"
	@echo "============================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# Comandos de exemplo
examples: ## Mostra exemplos de uso
	@echo "📚 Exemplos de uso:"
	@echo "==================="
	@echo "make start                    # Inicia a aplicação"
	@echo "make dev                      # Inicia em modo desenvolvimento"
	@echo "make stop                     # Para a aplicação"
	@echo "make restart                  # Reinicia a aplicação"
	@echo "make logs                     # Mostra logs"
	@echo "make shell                    # Abre shell no container"
	@echo "make console                  # Abre console Rails"
	@echo "make db-create                # Cria banco de dados"
	@echo "make db-migrate               # Executa migrações"
	@echo "make test                     # Executa testes"
	@echo "make generate MODEL=User      # Gera modelo User"
	@echo "make routes                   # Mostra rotas"
	@echo "make clean                    # Limpa containers e volumes"
	@echo "make help                     # Mostra esta ajuda"
