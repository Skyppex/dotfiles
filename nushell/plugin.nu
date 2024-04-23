register ~\scoop\persist\rustup\.cargo\bin\nu_plugin_regex.exe  {
  "sig": {
    "name": "regex",
    "usage": "Parse input with a regular expression and display the results.",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "pattern",
        "desc": "the regular expression to use",
        "shape": "String",
        "var_id": null,
        "default_value": null
      }
    ],
    "optional_positional": [],
    "rest_positional": null,
    "named": [
      {
        "long": "help",
        "short": "h",
        "arg": null,
        "required": false,
        "desc": "Display the help message for this command",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [
      [
        "String",
        {
          "Table": []
        }
      ]
    ],
    "allow_variants_without_examples": true,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Experimental"
  },
  "examples": [
    {
      "example": "\"hello world\" | regex '(?P<first>\\w+) (?P<second>\\w+)'",
      "description": "Parse a string with a regular expression",
      "result": null
    }
  ]
}

