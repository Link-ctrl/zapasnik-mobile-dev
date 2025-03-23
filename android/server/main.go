package main

import (
	"log"

	"github.com/IvanAbramovichWork/family-inventory-app/app/config"
	"github.com/IvanAbramovichWork/family-inventory-app/app/database"
	"github.com/IvanAbramovichWork/family-inventory-app/app/handlers"
	"github.com/IvanAbramovichWork/family-inventory-app/app/services"
	"github.com/gin-gonic/gin"
)

func main() {
	// Загружаем конфигурацию
	cfg := config.NewConfig()

	// Инициализация базы данных
	db := database.InitDB(cfg)
	defer db.Close()

	// Создание сервисов
	userService := services.NewUserService(db)
	familyService := services.NewFamilyService(db)
	productService := services.NewProductService(db)
	// Создание хендлеров
	userHandler := handlers.NewUserHandler(userService)
	familyHandler := handlers.NewFamilyHandler(familyService)
	productHandler := handlers.NewProductHandler(productService)

	// Настройка маршрутов
	router := gin.Default()

	// Маршруты для пользователей
	userRoutes := router.Group("/users")
	{
		userRoutes.POST("/signup", userHandler.SignUp)
		userRoutes.POST("/login", userHandler.Login)
		userRoutes.GET("/:id", userHandler.GetUserByID)
	}
	// Семьи
	familyRoutes := router.Group("/families")
	{
		familyRoutes.POST("/", familyHandler.CreateFamily)
		familyRoutes.GET("/:id", familyHandler.GetFamily)
		familyRoutes.PUT("/:id", familyHandler.UpdateFamily)
		familyRoutes.DELETE("/:id", familyHandler.DeleteFamily)
	}

	// Продукты
	productRoutes := router.Group("/products")
	{
		productRoutes.POST("/", productHandler.CreateProduct)
		productRoutes.GET("/:id", productHandler.GetProductByID)
		productRoutes.PUT("/:id", productHandler.UpdateProduct)
		productRoutes.DELETE("/:id", productHandler.DeleteProduct)
	}

	router.Run(":8080")
	port := "8080" // Значение по умолчанию
	log.Printf("Starting server on port %s...", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}

}
