# 🌟 RefStarsBot - Полная установка за одну команду

## Быстрая установка

### Для локального тестирования:

```bash
git clone https://github.com/svod011929/RefStarsBot.git
cd RefStarsBot
bash install.sh
```

### Для серверной установки на VPS (через curl):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/svod011929/RefStarsBot/main/install.sh)
```

---

## Что установит скрипт

✅ Проверит Python 3.10+  
✅ Создаст виртуальное окружение  
✅ Установит все зависимости из requirements.txt  
✅ Создаст .env файл из примера  
✅ Для серверной установки: настроит systemd сервис  

---

## После установки

### Локальная установка:

1. Отредактируйте `.env` файл с вашими токенами:
   ```bash
   nano .env
   ```

2. Активируйте виртуальное окружение:
   ```bash
   source venv/bin/activate
   ```

3. Запустите бота:
   ```bash
   python main.py
   ```

### Серверная установка:

1. Отредактируйте `.env` файл:
   ```bash
   sudo nano /home/botuser/RefStarsBot/.env
   ```

2. Запустите бота:
   ```bash
   sudo systemctl start refstarbot.service
   ```

3. Проверьте статус:
   ```bash
   sudo systemctl status refstarbot.service
   ```

4. Смотрите логи:
   ```bash
   sudo journalctl -u refstarbot.service -f
   ```

---

## Требуемые токены

### 🤖 Telegram Bot Token
- Напишите [@BotFather](https://t.me/botfather)
- Получите токен

### 🔑 Flyer API Token
- https://flyerservice.io
- Создайте бота
- Скопируйте API ключ

### 📱 SubGram Token (опционально)
- https://subgram.ru
- Создайте интеграцию

---

## Переменные окружения

Заполните `.env` файл:

```env
BOT_TOKEN=123456789:ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefgh
FLYER_TOKEN=your_flyer_api_key
DB_HOST=localhost
DB_USER=bot_user
DB_PASSWORD=secure_password
DB_NAME=refstarbot_database
```

---

## Решение проблем

### Скрипт требует sudo на локальной машине

Это нормально для серверной установки. Для локальной используйте:

```bash
bash install.sh
```

Без sudo.

### Python3 не найден

Установите Python:
```bash
sudo apt install python3 python3-pip python3-venv
```

### Ошибка при установке зависимостей

Убедитесь что вы в виртуальном окружении:
```bash
source venv/bin/activate
pip install -r requirements.txt
```

---

## Дополнительная информация

- [README.md](README.md) - Основная документация
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) - Развёртывание на VPS
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Решение проблем
- **GitHub**: https://github.com/svod011929/RefStarsBot

---

## Другие проекты автора

Посетите [портфолио](https://github.com/svod011929) для других интересных проектов:
- 🔐 [BuryatVPN](https://github.com/svod011929/buryatvpn) - Сервис VPN с Telegram ботом
- 🖥️ [KDS Server Panel](https://github.com/svod011929/KDS_Server_Panel) - Управление серверами через Telegram
- 💰 [CryptoBot Parser](https://github.com/svod011929/kds_parser_cryptobot) - Автопарсер крипто чеков

---

**Готовы? Начните установку прямо сейчас!** 🚀
