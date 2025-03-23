package models

import "time"

type Inventory struct {
	Id             int       `db:"id"`
	FamilyId       int       `db:"family_id"`
	ProductId      int       `db:"product_id"`
	Quantity       int       `db:"quantity"`
	ExpirationDate time.Time `db:"expiration_date"`
	CreatedAt      time.Time `db:"created_at"`
	UpdatedAt      time.Time `db:"updated_at"`
}

type Product struct {
	Id          int       `db:"id"`
	Name        string    `db:"name"`
	Category    string    `db:"category"`
	Description string    `db:"description"`
	Photo       string    `db:"photo_url"`
	Barcode     string    `db:"barcode"`
	CreatedAt   time.Time `db:"created_at"`
	UpdatedAt   time.Time `db:"updated_at"`
}
