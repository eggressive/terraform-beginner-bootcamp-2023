// Terraform provider for TerraTowns

// The package main statement at the beginning of a Go source file
// indicates that the package is an executable program rather than a library.
package main

// The fmt package provides functions for formatting text, printing to the console,
// and reading input from the user
import (
	//"encoding/json"
	//"net/http"
	"context"
	"fmt"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
	"log"
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
			"terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{
			// define your data sources here},
		},
	}
	// configure context function
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

// The providerConfigure function returns a schema.ConfigureContextFunc.
type Config struct {
	Endpoint string
	Token    string
	UserUuid string
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("[INFO] Provider configure function called.")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token:    d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("[INFO] Provider configure function end.")
		return &config, nil
	}
}

func Resource() *schema.Resource {
	log.Print("[INFO] Resource function called.")
	resource := &schema.Resource{
		CreateContext: resourceHouseCreate,
		ReadContext:   resourceHouseRead,
		UpdateContext: resourceHouseUpdate,
		DeleteContext: resourceHouseDelete,
	}
	log.Print("[INFO] Resource function end.")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource create function called.")
	var diags diag.Diagnostics
	log.Print("[INFO] Resource create function end.")
	return diags
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource read function called.")
	var diags diag.Diagnostics
	log.Print("[INFO] Resource read function end.")
	return diags
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource update function called.")
	var diags diag.Diagnostics
	log.Print("[INFO] Resource update function end.")
	return diags
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource delete function called.")
	var diags diag.Diagnostics
	log.Print("[INFO] Resource delete function end.")
	return diags
}
