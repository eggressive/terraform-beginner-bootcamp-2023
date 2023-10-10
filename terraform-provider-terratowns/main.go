// Terraform provider for TerraTowns

// The package main statement at the beginning of a Go source file
// indicates that the package is an executable program rather than a library.
package main

// The fmt package provides functions for formatting text, printing to the console,
// and reading input from the user
import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

// The providerConfigure function returns a schema.ConfigureContextFunc.
type Config struct {
	Endpoint string
	Token    string
	UserUuid string
}

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
		Schema: map[string]*schema.Schema{
			"name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The name of the home",
			},
			"description": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The description of the home",
			},
			"domain_name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The domain name of the home, e.g. *.cloudfront.net",
			},
			"town": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The town to which the home belongs to",
			},
			"content_version": {
				Type:        schema.TypeInt,
				Required:    true,
				Description: "The content version of the home",
			},
		},
	}
	log.Print("[INFO] Resource function end.")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource create function called.")
	var diags diag.Diagnostics
	config := m.(*Config)

	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"domain_name":     d.Get("domain_name").(string),
		"town":            d.Get("town").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	// Construct an HTTP request
	//url := config.Endpoint+"/u/"+config.UserUuid +"/homes"
	//log.Print("URL: " + url)
	req, err := http.NewRequest("POST", config.Endpoint+"/u/"+config.UserUuid +"/homes", bytes.NewBuffer(payloadBytes))
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Decode the response body into our custom response type
	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}

	// HTTP Status OK
	if resp.StatusCode != http.StatusOK {
		log.Printf("[ERROR] %s", responseData["error"])
		return diag.FromErr(fmt.Errorf("failed to create home resource, status code: %d, status: %s, body: %s", resp.StatusCode, resp.Status, responseData))
	}

	homeUUID := responseData["uuid"].(string)
	d.SetId(homeUUID)

	log.Print("[INFO] Resource create function end.")

	return diags
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource read function called.")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()

	// Construct an HTTP request
	req, err := http.NewRequest("GET", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, nil)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}

	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Declare responseData variable
	var responseData map[string]interface{}

	// HTTP Status OK
	if resp.StatusCode == http.StatusOK {
		// Decode the response body into our custom response type
		if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
			log.Printf("[ERROR] %s", err)
			return diag.FromErr(err)
		}
		d.Set("name", responseData["name"].(string))
		d.Set("description", responseData["description"].(string))
		d.Set("domain_name", responseData["domain_name"].(string))
		//d.Set("town", responseData["town"].(string))
		d.Set("content_version", responseData["content_version"].(int))
	} else if resp.StatusCode == http.StatusNotFound {
		d.SetId("")
	} else if resp.StatusCode != http.StatusOK {
		log.Printf("[ERROR] %s", responseData["error"])
		return diag.FromErr(fmt.Errorf("failed to read home resource, status code: %d, status: %s, body: %s", resp.StatusCode, resp.Status, responseData))
	}

	log.Print("[INFO] Resource read function end.")
	return diags
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource update function called.")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()
	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}

	// Construct an HTTP request
	req, err := http.NewRequest("PUT", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, bytes.NewBuffer(payloadBytes))
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}

	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Decode the response body into our custom response type
	// var responseData map[string]interface{}
	// if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
	// 	log.Printf("[ERROR] %s", err)
	// 	return diag.FromErr(err)
	// }

	// HTTP Status OK
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to update home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
	}

	log.Print("[INFO] Resource update function end.")

	d.Set("name", payload["name"].(string))
	d.Set("description", payload["description"].(string))
	d.Set("content_version", payload["content_version"].(int))

	return diags
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("[INFO] Resource delete function called.")
	var diags diag.Diagnostics
	config := m.(*Config)
	homeUUID := d.Id()
	// Construct an HTTP request
	req, err := http.NewRequest("DELETE", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, nil)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}

	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("[ERROR] %s", err)
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// HTTP Status OK
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to delete home resource, status code: %d, status: %s", resp.StatusCode, resp.Status))
	}

	d.SetId("")
	log.Print("[INFO] Resource delete function end.")
	return diags
}
