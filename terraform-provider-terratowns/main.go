// Terraform provider for TerraTowns

// The package main statement at the beginning of a Go source file
// indicates that the package is an executable program rather than a library.
package main

// The fmt package provides functions for formatting text, printing to the console,
// and reading input from the user
import (
	//"encoding/json"
	"fmt"
	//"net/http"
	"log"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

// The main function is the entry point of the executable program.
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
}

// The Provider function returns a schema.Provider.
// in Golanf the titlecase is used to export a function or variable
func Provider() *schema.Provider {
	var p *schema.Provider = &schema.Provider{
			Schema: map[string]*schema.Schema{
				"endpoint": {
					Type:        schema.TypeString,
					Required:    true,
					Description: "The endpoint of the external service",
				},
				"token": {
					Type:        schema.TypeString,
					Required:    true,
					Sensitive:   true,
					Description: "The token for authenticating with the external service",
				},
				"user_uuid": {
					Type:        schema.TypeString,
					Required:    true,
					Description: "The user uuid for authenticating with the external service",
					ValidateFunc: func(val interface{}, key string) (warns []string, errs []error) {
						_, err := uuid.Parse(val.(string))
						if err != nil {
							log.Printf("[ERROR] %q must be a valid uuid: %s", key, err)
							errs = append(errs, fmt.Errorf("%q must be a valid uuid", key))
						}
						return
					},
				},
			},
			ResourcesMap: map[string]*schema.Resource{
				// define your resources here
			},
			DataSourcesMap: map[string]*schema.Resource{
				// define your data sources here},
			},
		}
		return p
	}

