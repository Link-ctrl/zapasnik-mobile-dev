package services

import (
	"database/sql"
	"errors"

	"github.com/IvanAbramovichWork/family-inventory-app/app/models"
	"github.com/jmoiron/sqlx"
	"golang.org/x/crypto/bcrypt"
)

type UserService struct {
	db *sqlx.DB
}

// NewUserService создаёт новый экземпляр UserService
func NewUserService(db *sqlx.DB) *UserService {
	return &UserService{db: db}
}

// SignUp регистрирует нового пользователя
func (s *UserService) SignUp(user *models.User) error {
	// Хэшируем пароль
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)

	// SQL-запрос для добавления пользователя
	query := `INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id`
	err = s.db.QueryRow(query, user.Name, user.Email, user.Password).Scan(&user.Id)
	if err != nil {
		return err
	}

	return nil
}

// Login аутентифицирует пользователя
func (s *UserService) Login(email, password string) (*models.User, error) {
	var user models.User

	// SQL-запрос для получения пользователя по email
	query := `SELECT id, name, email, password FROM users WHERE email = $1`
	err := s.db.QueryRow(query, email).Scan(&user.Id, &user.Name, &user.Email, &user.Password)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	// Проверка пароля
	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil {
		return nil, errors.New("invalid password")
	}

	// Удаляем пароль перед возвратом результата
	user.Password = ""
	return &user, nil
}

// GetUserByID возвращает пользователя по ID
func (s *UserService) GetUserByID(userID int) (*models.User, error) {
	var user models.User

	// SQL-запрос для получения пользователя по ID
	query := `SELECT id, name, email FROM users WHERE id = $1`
	err := s.db.QueryRow(query, userID).Scan(&user.Id, &user.Name, &user.Email)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return &user, nil
}
