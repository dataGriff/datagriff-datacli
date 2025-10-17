package cmd

import (
    "encoding/json"
    "fmt"
    "github.com/datagriff/datacli/internal/data"
    "github.com/spf13/cobra"
)

var listCmd = &cobra.Command{
    Use:   "list",
    Short: "List all products in the catalog",
    Long:  "List all products from the catalog with their ID, name, price, and tags",
    Example: `  datacli list
  datacli --json list
  datacli --data custom.json list`,
    RunE: func(cmd *cobra.Command, args []string) error {
        catalog, err := data.Load(dataPath)
        if err != nil {
            return fmt.Errorf("failed to load catalog: %w", err)
        }

        if jsonOut {
            return outputJSON(cmd, catalog.Products)
        }

        return outputTable(cmd, catalog.Products)
    },
}

func outputJSON(cmd *cobra.Command, products []data.Product) error {
    enc := json.NewEncoder(cmd.OutOrStdout())
    enc.SetIndent("", "  ") // Use 2 spaces for better readability
	enc.SetEscapeHTML(false) // Don't escape &, <, > in strings - !ok as a cli and not web facing!
    if err := enc.Encode(products); err != nil {
        return fmt.Errorf("failed to encode JSON: %w", err)
    }
    return nil
}

func outputTable(cmd *cobra.Command, products []data.Product) error {
    // Print header
    fmt.Fprintf(cmd.OutOrStdout(), "%-8s %-25s %-12s %s\n", "ID", "NAME", "PRICE", "TAGS")
    fmt.Fprintf(cmd.OutOrStdout(), "%-8s %-25s %-12s %s\n", "──", "────", "─────", "────")
    
    // Print products
    for _, p := range products {
        fmt.Fprintf(cmd.OutOrStdout(), "%-8s %-25s $%-11.2f %v\n", 
            p.ID, p.Name, p.Price, p.Tags)
    }
    
    fmt.Fprintf(cmd.OutOrStdout(), "\nTotal products: %d\n", len(products))
    return nil
}

func init() {
    rootCmd.AddCommand(listCmd)
}