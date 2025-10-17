package cmd

import (
  "encoding/json"
  "errors"
  "fmt"

  "github.com/spf13/cobra"
  "github.com/datagriff/datacli/internal/data"
)

var productID string

var getCmd = &cobra.Command{
  Use:   "get",
  Short: "Get a product by ID",
  RunE: func(cmd *cobra.Command, args []string) error {
    if productID == "" {
      return errors.New("--id is required")
    }
    catalog, err := data.Load(dataPath)
    if err != nil {
      return err
    }
    p := catalog.FindByID(productID)
    if p == nil {
      return fmt.Errorf("product %q not found", productID)
    }

    if jsonOut {
      enc := json.NewEncoder(cmd.OutOrStdout())
      enc.SetIndent("", "  ")
      return enc.Encode(p)
    }

    fmt.Fprintf(cmd.OutOrStdout(), "ID: %s\nName: %s\nPrice: $%.2f\nTags: %v\n", p.ID, p.Name, p.Price, p.Tags)
    return nil
  },
}

func init() {
  rootCmd.AddCommand(getCmd)
  getCmd.Flags().StringVar(&productID, "id", "", "product ID")
}
