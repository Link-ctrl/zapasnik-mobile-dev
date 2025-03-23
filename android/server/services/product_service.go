package services

import (
	"errors"

	"github.com/IvanAbramovichWork/family-inventory-app/app/models"
	"github.com/jmoiron/sqlx"
)

// ProductService представляет слой бизнес-логики для работы с продуктами
type ProductService struct {
	db *sqlx.DB
}

// NewProductService создает новый экземпляр ProductService
func NewProductService(db *sqlx.DB) *ProductService {
	return &ProductService{db: db}
}

// CreateProduct добавляет новый продукт в базу данных
func (s *ProductService) CreateProduct(product *models.Product) error {
	query := `INSERT INTO products (name, category, description) VALUES ($1, $2, $3) RETURNING id`
	err := s.db.QueryRow(query, product.Name, product.Category, product.Description).Scan(&product.Id)
	if err != nil {
		return err
	}
	return nil
}

// GetProductByID получает продукт по его ID
func (s *ProductService) GetProductByID(id string) (*models.Product, error) {
	var product models.Product
	query := `SELECT id, name, description, price, status FROM products WHERE id = $1`
	err := s.db.Get(&product, query, id)
	if err != nil {
		return nil, errors.New("product not found")
	}
	return &product, nil
}

func (s *ProductService) UpdateProduct(product *models.Product) error {
	query := `UPDATE products SET name = $1, category = $2, description = $3 WHERE id = $4`
	_, err := s.db.Exec(query, product.Name, product.Category, product.Description, product.Id)
	return err
}

func (s *ProductService) DeleteProduct(id string) error {
	query := `DELETE FROM products WHERE id = $1`
	_, err := s.db.Exec(query, id)
	return err
}
