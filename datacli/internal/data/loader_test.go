package data

import "testing"

func TestFindById(t *testing.T){
	c, err := Load("")
	if err != nil {t.Fatal(err)}
	if p := c.FindByID("p2"); p == nil || p.Name == ""{
		t.Fatalf("expected product p2 to exist")
	}
}