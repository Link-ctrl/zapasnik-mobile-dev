package models

type User struct {
	Id       int    `db:"id"`
	Name     string `db:"name"`
	Email    string `db:"email"`
	Password string `db:"password_hash"`
	Role     string `db:"role"`
}
