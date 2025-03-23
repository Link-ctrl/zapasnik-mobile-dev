package handlers

import (
	"net/http"

	"github.com/IvanAbramovichWork/family-inventory-app/app/models"
	"github.com/IvanAbramovichWork/family-inventory-app/app/services"
	"github.com/gin-gonic/gin"
)

type ProductHandler struct {
	ProductService *services.ProductService
}

// NewProductHandler создает новый экземпляр ProductHandler
func NewProductHandler(service *services.ProductService) *ProductHandler {
	return &ProductHandler{ProductService: service}
}

// CreateProduct создает новый продукт
func (h *ProductHandler) CreateProduct(c *gin.Context) {
	var product models.Product
	if err := c.ShouldBindJSON(&product); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	if err := h.ProductService.CreateProduct(&product); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create product"})
		return
	}

	c.JSON(http.StatusCreated, product)
}

// GetProductByID получает данные продукта по ID
func (h *ProductHandler) GetProductByID(c *gin.Context) {
	productID := c.Param("id")
	product, err := h.ProductService.GetProductByID(productID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
		return
	}

	c.JSON(http.StatusOK, product)
}

func (h *ProductHandler) UpdateProduct(c *gin.Context) {
	var product models.Product
	if err := c.ShouldBindJSON(&product); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}
	if err := h.ProductService.UpdateProduct(&product); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update product"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Product updated successfully"})
}

func (h *ProductHandler) DeleteProduct(c *gin.Context) {
	productID := c.Param("id")
	if err := h.ProductService.DeleteProduct(productID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete product"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Product deleted successfully"})
}
