package data

import (
	"embed"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
)

//go:embed assets
var embeddedFS embed.FS

// Load loads a catalog either from the provided path or from the embedded default.json
// If path =="", embedded is used.

func Load(path string) (Catalog, error){
	var r io.ReadCloser
	if path == "" {
		f, err := embeddedFS.Open("default.json")
		if err != nil {
			return Catalog{}, fmt.Errorf("open embedded data: %w", err)
		}
		r=f
	} else {
		f, err := os.Open(path)
		if err != nil {
			return Catalog{}, fmt.Errorf("open %s: %w", path, err)
		}
		r=f
	}
	defer r.Close()

	dec := json.NewDecoder(r)
	dec.DisallowUnknownFields()

	var c Catalog
	if err := dec.Decode(&c); err != nil {
		return Catalog{}, fmt.Errorf("decode JSON: %w", err)
	}
	if len(c.Products) == 0 {
		return Catalog{}, errors.New("no products found")
	}

	return c, nil
}