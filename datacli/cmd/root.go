/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"os"
	"fmt"
	"github.com/spf13/cobra"
)

var (dataPath string
	jsonOut bool
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "datagriff-datacli",
	Short: "A zero-dependency JSON-driven CLI",
	Long: `datacli is a small demo CLI using Cobra. 
	It loads a JSON catalog (embedded by default) or from -data <file>.
	
	Examples:
		datacli list                    # List products using embedded data
		datacli --data custom.json list # List products from custom file
		datacli --json list             # Output as JSON`,
	SilenceUsage: true,
	SilenceErrors: true,
	// Add a run function to show help when no subcommand is provided
    Run: func(cmd *cobra.Command, args []string) {
        cmd.Help()
    },
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func init() {
  // Persistent flags available to all subcommands
  rootCmd.PersistentFlags().StringVar(&dataPath, "data", "", "path to JSON data file (optional; uses embedded default if empty)")
  rootCmd.PersistentFlags().BoolVar(&jsonOut, "json", false, "output JSON (default is human-readable text)")
}


