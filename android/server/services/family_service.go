package services

import (
	"errors"

	"github.com/IvanAbramovichWork/family-inventory-app/app/models"
	"github.com/jmoiron/sqlx" // Для работы с базой данных через sqlx
)

type FamilyService struct {
	db *sqlx.DB
}

// NewFamilyService создает новый экземпляр FamilyService с базой данных
func NewFamilyService(db *sqlx.DB) *FamilyService {
	return &FamilyService{db: db}
}

// CreateFamily создает новую семью в базе данных
func (s *FamilyService) CreateFamily(family *models.Family) error {
	query := "INSERT INTO families (name) VALUES ($1) RETURNING id"
	err := s.db.QueryRow(query, family.Name).Scan(&family.Id)
	return err
}

// GetFamilyByID получает данные семьи по ID
func (s *FamilyService) GetFamilyByID(familyID string) (*models.Family, error) {
	var family models.Family
	query := "SELECT * FROM families WHERE id = $1"
	err := s.db.Get(&family, query, familyID)
	if err != nil {
		return nil, errors.New("семья не найдена")
	}
	return &family, nil
}

// AddMemberToFamily добавляет нового участника в семью
func (s *FamilyService) AddMemberToFamily(familyID string, member *models.FamilyMember) error {
	query := "INSERT INTO family_members (family_id, user_id, role) VALUES ($1, $2, $3)"
	_, err := s.db.Exec(query, familyID, member.UserId, member.Role)
	return err
}

func (s *FamilyService) ListMembers(familyID string) ([]models.FamilyMember, error) {
	var members []models.FamilyMember
	query := "SELECT * FROM family_members WHERE family_id = $1"
	err := s.db.Select(&members, query, familyID)
	if err != nil {
		return nil, errors.New("не удалось получить участников семьи")
	}
	return members, nil
}

func (s *FamilyService) UpdateFamily(familyId string, family *models.Family) error {
	query := "UPDATE families SET name = $1 WHERE id = $2"
	result, err := s.db.Exec(query, family.Name, familyId)
	if err != nil {
		return errors.New("failed to update family")
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return errors.New("error checking update result")
	}

	if rowsAffected == 0 {
		return errors.New("family not found")
	}

	return nil
}

func (s *FamilyService) DeleteFamily(familyId string) error {
	query := "DELETE FROM families WHERE id = $1"
	_, err := s.db.Exec(query, familyId)
	if err != nil {
		return errors.New("failed to delete family")
	}
	return nil
}
