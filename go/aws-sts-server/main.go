package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os/exec"
)

func sts(w http.ResponseWriter, req *http.Request) {
	id_json, _ := exec.Command("aws", "sts", "get-caller-identity").CombinedOutput()

	var id_map map[string]interface{}
	json.Unmarshal([]byte(id_json), &id_map)
	arn := id_map["Arn"].(string)

  assume_role_json, _ := exec.Command("aws", "sts", "assume-role", "--role-arn", arn, "--role-session-name", "assume-role").CombinedOutput()
  fmt.Fprintf(w, "%s", assume_role_json)
}

func main() {
	http.HandleFunc("/sts", sts)
	http.ListenAndServe(":8090", nil)
}

/* Permissive Policy
{
		"Version": "2012-10-17",
		"Statement": [
				{
						"Effect": "Allow",
						"Principal": {
								"AWS": "*"
						},
						"Action": "sts:AssumeRole"
				}
		]
}
*/
