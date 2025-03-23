# Используем базовый образ Go
FROM golang:1.23

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем go.mod и go.sum и устанавливаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем весь проект
COPY . .

# Компилируем Go приложение
RUN go build -o server .

# Указываем порт
EXPOSE 8080

# Команда запуска сервера
CMD ["./server"]
