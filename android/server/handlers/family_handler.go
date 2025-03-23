package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/IvanAbramovichWork/family-inventory-app/app/models"
	"github.com/IvanAbramovichWork/family-inventory-app/app/services"
)

type FamilyHandler struct {
	FamilyService *services.FamilyService
}

// NewFamilyHandler initializes a new FamilyHandler.
func NewFamilyHandler(familyService *services.FamilyService) *FamilyHandler {
	return &FamilyHandler{FamilyService: familyService}
}

// CreateFamily creates a new family.
func (h *FamilyHandler) CreateFamily(c *gin.Context) {
	var family models.Family
	if err := c.ShouldBindJSON(&family); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	if err := h.FamilyService.CreateFamily(&family); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create family"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Family created successfully", "family": family})
}

// GetFamily retrieves family details by ID.
func (h *FamilyHandler) GetFamily(c *gin.Context) {
	familyID := c.Param("id")

	family, err := h.FamilyService.GetFamilyByID(familyID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Family not found"})
		return
	}

	c.JSON(http.StatusOK, family)
}

// AddFamilyMember adds a new member to an existing family.
func (h *FamilyHandler) AddFamilyMember(c *gin.Context) {
	var member models.FamilyMember
	if err := c.ShouldBindJSON(&member); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	familyID := c.Param("id")
	if err := h.FamilyService.AddMemberToFamily(familyID, &member); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add family member"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Family member added successfully"})
}

// ListFamilyMembers lists all members in a family.
func (h *FamilyHandler) ListFamilyMembers(c *gin.Context) {
	familyID := c.Param("id")

	members, err := h.FamilyService.ListMembers(familyID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve family members"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"members": members})
}

// UpdateFamily updates family details.
func (h *FamilyHandler) UpdateFamily(c *gin.Context) {
	var family models.Family
	if err := c.ShouldBindJSON(&family); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	familyID := c.Param("id")
	if err := h.FamilyService.UpdateFamily(familyID, &family); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update family"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Family updated successfully"})
}

// DeleteFamily deletes a family.
func (h *FamilyHandler) DeleteFamily(c *gin.Context) {
	familyID := c.Param("id")

	if err := h.FamilyService.DeleteFamily(familyID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete family"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Family deleted successfully"})
}
