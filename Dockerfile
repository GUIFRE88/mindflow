FROM ruby:3.3.0

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Cria usuário com UID 1001
RUN useradd -m -u 1001 appuser

# Define o diretório de trabalho
WORKDIR /app

# Instala bundler
RUN gem install bundler

# Copia Gemfile e Gemfile.lock (se existir)
COPY Gemfile* ./

# Instala as gems
RUN bundle install

# Copia o restante do código da aplicação
COPY . .

# Configura permissões para o usuário
RUN chown -R appuser:appuser /app /usr/local/bundle

# Muda para o usuário appuser
USER appuser

# Expõe a porta 3000
EXPOSE 3000

# Comando padrão
CMD ["rails", "server", "-b", "0.0.0.0"]