package controllers

import (
	"context"
	"fmt"
	beego "github.com/beego/beego/v2/server/web"
	"go-skeleton-dockerized/models"
	mongorm "go-skeleton-dockerized/orm/mongo"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type MainController struct {
	beego.Controller
}

type User1 = models.User1

func (c *MainController) Get() {
	var result string = ""

	// Replace the connection string with your own
	client, err := mongorm.Connect("mongodb://mongo-skeleton-web:27017")
	if err != nil {
		panic(err)
	}

	db := client.Database("test_db")

	// Create a new user
	user := User1{
		FirstName: "John",
		LastName:  "Doe",
		Email:     "john.doe@example.com",
	}
	err = user.Create(context.Background(), db, "users", &user)
	if err != nil {
		panic(err)
	}
	result += fmt.Sprintf("User created: %v\n", user)

	// Read a user by ID
	var readUser User1
	err = readUser.Read(context.Background(), db, "users", bson.M{"_id": user.ID}, &readUser)
	if err != nil {
		panic(err)
	}
	result += fmt.Sprintf("User read: %v\n", readUser)

	// Update a user's email
	update := bson.M{"$set": bson.M{"email": "john.doe_updated@example.com", "updated_at": primitive.NewDateTimeFromTime(user.UpdatedAt)}}
	err = user.Update(context.Background(), db, "users", bson.M{"_id": user.ID}, update)
	if err != nil {
		panic(err)
	}
	result += fmt.Sprintf("User updated: %v\n", user)

	// Delete a user by ID
	err = user.Delete(context.Background(), db, "users", bson.M{"_id": user.ID})
	if err != nil {
		panic(err)
	}
	result += fmt.Sprintf("User deleted")

	c.Data["json"] = result
	c.ServeJSON()
}
