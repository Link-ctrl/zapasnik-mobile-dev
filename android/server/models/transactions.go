package models

import "time"

type Transaction struct {
	Id        int       `db:"id"`
	FamilyId  int       `db:"family_id"`
	ProductId int       `db:"product_id"`
	UserId    int       `db:"user_id"`
	Action    string    `db:"action"`
	Quantity  int       `db:"quantity"`
	CreatedAt time.Time `db:"created_at"`
}
