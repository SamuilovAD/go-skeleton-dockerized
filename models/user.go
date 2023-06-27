package models

import "go-skeleton-dockerized/orm/mongo"

type User struct {
	mongorm.Model
	FirstName string `bson:"first_name"`
	LastName  string `bson:"last_name"`
	Email     string `bson:"email"`
}
