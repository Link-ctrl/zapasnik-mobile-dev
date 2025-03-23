package models

import "time"

type Notification struct {
	Id        int       `db:"id"`
	UserId    int       `db:"user_id"`
	ProductId int       `db:"product_id"`
	Message   string    `db:"message"`
	SentAt    time.Time `db:"sent_at"`
	IsRead    bool      `db:"is_read"`
}
