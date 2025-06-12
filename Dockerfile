# Використовуємо аргумент для версії PHP, щоб легко оновити
ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli-alpine

# Встановлюємо системні залежності, необхідні для розширень PHP та Composer
# git, unzip: для Composer
# curl-dev: для розширення ext-curl
# icu-dev: для розширення ext-intl (часто корисне)
# libxml2-dev: для розширень ext-dom, ext-xml (можуть знадобитися Rector)
# oniguruma-dev: для розширення ext-mbstring (може знадобитися Rector)
# $PHPIZE_DEPS: для компіляції розширень PHP (включає bison, re2c тощо)
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    git \
    unzip \
    curl-dev \
    icu-dev \
    libxml2-dev \
    oniguruma-dev

# Встановлюємо необхідні PHP розширення
# json та tokenizer зазвичай вже вбудовані.
# composer.json вимагає ext-curl (який ми встановлюємо) та ext-json (який має бути вбудованим).
# mbstring, dom, xml - часто потрібні для Rector та інструментів статичного аналізу.
# intl - загалом корисне розширення.
RUN docker-php-ext-install -j$(nproc) \
    curl \
    intl \
    mbstring \
    dom \
    xml

# Перевірка, чи дійсно json, curl та tokenizer завантажені
RUN php -m | grep -i -E '^json$|^curl$|^tokenizer$' || \
    (echo "ПОМИЛКА: Розширення JSON, CURL або TOKENIZER відсутнє після спроби встановлення!" && \
     echo "Завантажені розширення:" && php -m && exit 1)

# Встановлюємо Composer глобально
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Встановлюємо робочу директорію всередині контейнера
WORKDIR /app

# Копіюємо composer.json та composer.lock (якщо він існує)
COPY composer.json composer.lock* ./

# Встановлюємо залежності вашого проєкту (з composer.json)
RUN composer install --no-interaction --no-scripts --prefer-dist --optimize-autoloader --no-dev

# Копіюємо решту коду вашого проєкту в робочу директорію контейнера
COPY . .

# Команда за замовчуванням при запуску контейнера - відкрити shell.
CMD ["sh"]