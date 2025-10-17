package data

type Product struct {
	ID string `json:"id"`
	Name string `json:"name"`
	Price float64 `json:"price"`
	Tags []string `json:"tags"`
}

type Catalog struct {
	Products []Product `json:"products"`
}

func (c *Catalog) FindByID(id string) *Product {
	for _, p := range c.Products {
		if p.ID == id {
			return &p
		}
	}
	return nil
}
