package models

import "time"

type Family struct {
	Id        int       `db:"id"`
	Name      string    `db:"name"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}

type FamilyMember struct {
	Id       int    `db:"id"`
	FamilyId int    `db:"family_id"`
	UserId   int    `db:"user_id"`
	Role     string `db:"role"`
}
