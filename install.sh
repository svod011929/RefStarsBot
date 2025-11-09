#!/bin/bash

# ============================================
# RefStarsBot - Скрипт установки
# Одна команда для полной установки
# ============================================

set -e  # Выход при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функции
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}       🌟 RefStarsBot - Установка и конфигурация        ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Главная установка
main() {
    print_header
    
    # Проверка OS
    print_info "Проверка операционной системы..."
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 не установлен"
        print_info "Установите Python3: sudo apt install python3 python3-pip python3-venv"
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_success "Python $PYTHON_VERSION найден"
    
    # Выбор типа установки
    print_info "Выберите тип установки:"
    echo "1) Локальная установка (для разработки)"
    echo "2) Серверная установка (production на VPS)"
    read -p "Выберите (1 или 2): " INSTALL_TYPE
    
    case $INSTALL_TYPE in
        1)
            install_local
            ;;
        2)
            install_server
            ;;
        *)
            print_error "Неверный выбор"
            exit 1
            ;;
    esac
}

# Локальная установка
install_local() {
    print_info "Начало локальной установки..."
    
    # Переменные
    PROJECT_DIR=$(pwd)
    VENV_DIR="$PROJECT_DIR/venv"
    
    # Создание виртуального окружения
    print_info "Создание виртуального окружения..."
    python3 -m venv "$VENV_DIR"
    print_success "Виртуальное окружение создано"
    
    # Активация
    source "$VENV_DIR/bin/activate"
    
    # Обновление pip
    print_info "Обновление pip..."
    pip install --upgrade pip setuptools wheel
    print_success "pip обновлён"
    
    # Установка зависимостей
    print_info "Установка зависимостей (это может занять 2-3 минуты)..."
    pip install -r requirements.txt
    print_success "Зависимости установлены"
    
    # Создание .env файла
    if [ ! -f .env ]; then
        print_info "Создание .env файла..."
        cp .env.example .env
        print_success ".env файл создан"
        print_warning "ВАЖНО: Заполните .env файл перед запуском!"
        print_info "nano .env"
    else
        print_warning ".env файл уже существует"
    fi
    
    # Проверка БД
    print_info "Проверка базы данных..."
    python3 main.py --check-db
    
    # Завершение
    print_success "Локальная установка завершена! ✨"
    print_info "Для запуска выполните:"
    echo "  source venv/bin/activate"
    echo "  python main.py"
}

# Серверная установка
install_server() {
    print_info "Начало серверной установки (production)..."
    
    # Переменные
    BOT_USER="botuser"
    BOT_DIR="/home/$BOT_USER/RefStarsBot"
    VENV_DIR="$BOT_DIR/venv"
    
    # Проверка прав
    if [ "$EUID" -ne 0 ]; then
        print_error "Серверная установка требует прав администратора (sudo)"
        exit 1
    fi
    
    # Обновление системы
    print_info "Обновление системы..."
    apt update && apt upgrade -y
    print_success "Система обновлена"
    
    # Установка зависимостей
    print_info "Установка системных пакетов..."
    apt install -y python3.10 python3.10-venv build-essential libpq-dev git curl wget nano
    print_success "Системные пакеты установлены"
    
    # Создание пользователя
    if ! id "$BOT_USER" &>/dev/null; then
        print_info "Создание пользователя $BOT_USER..."
        useradd -m -s /bin/bash "$BOT_USER"
        print_success "Пользователь $BOT_USER создан"
    else
        print_info "Пользователь $BOT_USER уже существует"
    fi
    
    # Создание директории
    print_info "Создание директории $BOT_DIR..."
    mkdir -p "$BOT_DIR"
    cd "$BOT_DIR"
    
    # Клонирование репозитория (если нужно)
    if [ ! -f main.py ]; then
        print_info "Клонирование репозитория..."
        git clone https://github.com/YOUR_USERNAME/RefStarsBot.git . 2>/dev/null || \
        print_warning "Не удалось клонировать. Пожалуйста, загрузьте файлы вручную"
    fi
    
    # Создание виртуального окружения
    print_info "Создание виртуального окружения..."
    su - "$BOT_USER" -c "cd $BOT_DIR && python3 -m venv $VENV_DIR"
    print_success "Виртуальное окружение создано"
    
    # Установка зависимостей
    print_info "Установка зависимостей..."
    su - "$BOT_USER" -c "cd $BOT_DIR && source $VENV_DIR/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"
    print_success "Зависимости установлены"
    
    # Создание .env файла
    if [ ! -f "$BOT_DIR/.env" ]; then
        print_info "Создание .env файла..."
        cp "$BOT_DIR/.env.example" "$BOT_DIR/.env"
        chmod 600 "$BOT_DIR/.env"
        print_success ".env файл создан"
        print_warning "ВАЖНО: Заполните $BOT_DIR/.env перед запуском!"
    fi
    
    # Создание systemd сервиса
    print_info "Создание systemd сервиса..."
    cat > /etc/systemd/system/refstarbot.service <<EOF
[Unit]
Description=RefStarsBot Telegram Bot Service
After=network.target

[Service]
Type=simple
User=$BOT_USER
WorkingDirectory=$BOT_DIR
ExecStart=$VENV_DIR/bin/python $BOT_DIR/main.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=refstarbot

[Install]
WantedBy=multi-user.target
EOF
    
    chmod 644 /etc/systemd/system/refstarbot.service
    systemctl daemon-reload
    print_success "Systemd сервис создан"
    
    # Установка прав
    print_info "Установка прав доступа..."
    chown -R "$BOT_USER:$BOT_USER" "$BOT_DIR"
    chmod 700 "$BOT_DIR"
    print_success "Права установлены"
    
    # Завершение
    print_success "Серверная установка завершена! ✨"
    print_info "Следующие шаги:"
    echo "1. Отредактируйте .env файл:"
    echo "   nano $BOT_DIR/.env"
    echo ""
    echo "2. Включите автозапуск:"
    echo "   systemctl enable refstarbot.service"
    echo ""
    echo "3. Запустите бота:"
    echo "   systemctl start refstarbot.service"
    echo ""
    echo "4. Проверьте статус:"
    echo "   systemctl status refstarbot.service"
    echo ""
    echo "5. Смотрите логи:"
    echo "   journalctl -u refstarbot.service -f"
}

# Запуск
main
