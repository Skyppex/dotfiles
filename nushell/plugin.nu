register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver",
    "usage": "Show all the semver commands",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
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
    "input_output_types": [],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": []
}

register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver bump",
    "usage": "Bump the version to the next level",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "level",
        "desc": "The version level to bump. Valid values are: major, minor, patch, alpha, beta, rc, or release.",
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
      },
      {
        "long": "ignore-errors",
        "short": "i",
        "arg": null,
        "required": false,
        "desc": "If the input is not a valid SemVer version, return the original string unchanged without raising an error",
        "var_id": null,
        "default_value": null
      },
      {
        "long": "build-metadata",
        "short": "b",
        "arg": "String",
        "required": false,
        "desc": "Additionally set the build metadata",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [
      [
        "String",
        "String"
      ]
    ],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": "\"1.2.3-alpha.1+build\" | semver bump major",
      "description": "Bump major version",
      "result": {
        "String": {
          "val": "2.0.0",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3-alpha.1+build\" | semver bump minor",
      "description": "Bump minor version",
      "result": {
        "String": {
          "val": "1.3.0",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3+build\" | semver bump patch",
      "description": "Bump patch version from pre-release",
      "result": {
        "String": {
          "val": "1.2.4",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3-alpha.1+build\" | semver bump patch",
      "description": "Bump patch version from pre-release",
      "result": {
        "String": {
          "val": "1.2.3",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3-alpha.1+build\" | semver bump alpha",
      "description": "Bump current alpha pre-release to next alpha pre-release",
      "result": {
        "String": {
          "val": "1.2.3-alpha.2+build",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3\" | semver bump alpha",
      "description": "Bump version to next alpha pre-release",
      "result": {
        "String": {
          "val": "1.2.4-alpha.1",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3-rc.1\" | semver bump release",
      "description": "Release the current pre-release version",
      "result": {
        "String": {
          "val": "1.2.3",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    }
  ]
}

register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver from-record",
    "usage": "Construct a SemVer version from a record",
    "extra_usage": "Note: the record needs to have the same components as what is returned by `semver to-record`",
    "search_terms": [],
    "required_positional": [],
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
        {
          "Record": [
            [
              "major",
              "Int"
            ],
            [
              "minor",
              "Int"
            ],
            [
              "patch",
              "Int"
            ],
            [
              "pre",
              "String"
            ],
            [
              "build",
              "String"
            ]
          ]
        },
        "String"
      ]
    ],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": "{ major: 2, minor: 3, patch: 4, pre: \"\", build: \"\" } | semver from-record",
      "description": "Parse a semver version into a record",
      "result": {
        "String": {
          "val": "2.3.4",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": "\"1.2.3\" | semver to-record | update build \"foo\" | semver from-record",
      "description": "Modify a semver version.",
      "result": {
        "String": {
          "val": "1.2.3+foo",
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    }
  ]
}

register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver match-req",
    "usage": "Try to match a SemVer version with a version requirement",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [
      {
        "name": "requirement",
        "desc": "A valid version requirement",
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
        "Bool"
      ]
    ],
    "allow_variants_without_examples": false,
    "is_filter": true,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": " \"3.2.1\" | semver match-req \"3\" ",
      "description": "Match a SemVer version against a version requirement.",
      "result": {
        "Bool": {
          "val": true,
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": " \"3.2.1\" | semver match-req \">=2\" ",
      "description": "Match a SemVer version against a version requirement.",
      "result": {
        "Bool": {
          "val": true,
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    },
    {
      "example": " \"3.2.1\" | semver match-req \">=2,<3\" ",
      "description": "Match a SemVer version against a version requirement.",
      "result": {
        "Bool": {
          "val": false,
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    }
  ]
}

register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver sort",
    "usage": "Sort a list of versions using SemVer ordering.",
    "extra_usage": "Note: every item in the list needs to be a well-formed SemVer version.",
    "search_terms": [],
    "required_positional": [],
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
      },
      {
        "long": "reverse",
        "short": "r",
        "arg": null,
        "required": false,
        "desc": "Sort the versions in descending order",
        "var_id": null,
        "default_value": null
      }
    ],
    "input_output_types": [
      [
        {
          "List": "String"
        },
        {
          "List": "String"
        }
      ]
    ],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": "[\"3.2.1\", \"2.3.4\", \"3.2.2\", \"2.3.4-beta.1\", \"2.3.4-alpha.1\", \"2.3.4-alpha.2\"] | semver sort",
      "description": "sort versions by SemVer semantics.",
      "result": {
        "List": {
          "vals": [
            {
              "String": {
                "val": "2.3.4-alpha.1",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            },
            {
              "String": {
                "val": "2.3.4-alpha.2",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            },
            {
              "String": {
                "val": "2.3.4-beta.1",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            },
            {
              "String": {
                "val": "2.3.4",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            },
            {
              "String": {
                "val": "3.2.1",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            },
            {
              "String": {
                "val": "3.2.2",
                "internal_span": {
                  "start": 0,
                  "end": 0
                }
              }
            }
          ],
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    }
  ]
}

register C:\Users\brage.ingebrigtsen\.cargo\bin\nu_plugin_semver.exe  {
  "sig": {
    "name": "semver to-record",
    "usage": "Parse a valid SemVer version into its components",
    "extra_usage": "",
    "search_terms": [],
    "required_positional": [],
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
          "Record": [
            [
              "major",
              "Int"
            ],
            [
              "minor",
              "Int"
            ],
            [
              "patch",
              "Int"
            ],
            [
              "pre",
              "String"
            ],
            [
              "build",
              "String"
            ]
          ]
        }
      ]
    ],
    "allow_variants_without_examples": false,
    "is_filter": false,
    "creates_scope": false,
    "allows_unknown_args": false,
    "category": "Default"
  },
  "examples": [
    {
      "example": "\"1.2.3-alpha.1+build2\" | semver to-record",
      "description": "Parse a semver version into a record.",
      "result": {
        "Record": {
          "val": {
            "cols": [
              "major",
              "minor",
              "patch",
              "pre",
              "build"
            ],
            "vals": [
              {
                "String": {
                  "val": "1",
                  "internal_span": {
                    "start": 0,
                    "end": 0
                  }
                }
              },
              {
                "String": {
                  "val": "2",
                  "internal_span": {
                    "start": 0,
                    "end": 0
                  }
                }
              },
              {
                "String": {
                  "val": "3",
                  "internal_span": {
                    "start": 0,
                    "end": 0
                  }
                }
              },
              {
                "String": {
                  "val": "alpha.1",
                  "internal_span": {
                    "start": 0,
                    "end": 0
                  }
                }
              },
              {
                "String": {
                  "val": "build2",
                  "internal_span": {
                    "start": 0,
                    "end": 0
                  }
                }
              }
            ]
          },
          "internal_span": {
            "start": 0,
            "end": 0
          }
        }
      }
    }
  ]
}

