class Tests_Decls extends haxe.unit.TestCase
{
	public static function GetSource()
	{ 
		var _sourceArr1: Array<Dynamic> = [1, 2, [3, 4]];
	
	    var _source = {
	        "updated": 1438517599342400, 
	        "apkey": "2a02d608-6431-40aa-b0b2-91bf5f48cd84", 
	        "stored": 1438313529667260, 
	        "eventkeyid": "3a300a90-eca4-e101-383d-6bfd5990d791", 
	        "key": "244de280-a01a-c5da-4162-ced9775246a5", 
	        "clientkey": "82b25cfa-f0ec-4f44-9209-77cbd98edd6a", 
	        "docalt": _sourceArr1, 
	        "invalid": false, 
	        "document": {
	            "description": "stuff", 
	            "themeindex": 6, 
	            "eventkeyid": "3a300a90-eca4-e101-383d-6bfd5990d791", 
	            "published": true, 
	            "type": "Metric_update", 
	            "name": "thingo"
	        }, 
	        "type": "CachedObject", 
	        "indexnames": [
	            "82B25CFA-F0EC-4F44-9209-77CBD98EDD6A-Metric"
	        ], 
	        "objecttype": "Metric"
	    }
	    
	    return _source;
	}

	var _coreDist = null;
	
	function LoadCoreDist()
	{
		if (this._coreDist == null)
		{
			this._coreDist = Util.loadcoredist();
		}
		
		return this._coreDist;
	}
	
	function EvaluateTransform(aDecl: Dynamic, aLibDecls: Array<Array<Dynamic>>, aSource:Dynamic = null): Dynamic
	{
		var s = new Sutl();
		
	    var llibresult = s.compilelib([aDecl], aLibDecls);
	    
	    var llib = {}
	    if (Reflect.hasField(llibresult, "lib"))
	    {
	        llib = Util.get(llibresult, "lib");
	    }
	    
	    //trace("lib contains: " + Reflect.fields(llib));
	    
	    var lresult = s.evaluate(aSource, Util.get(aDecl, "transform-t"), llib, 0);
	    
	    return lresult;
	}

	public function testLoadCoreDist()
	{
		var lcoreDist = LoadCoreDist();
		
		this.assertTrue(Util.isArray(lcoreDist));
	}

	public function test_concat()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclarr1: Array<Dynamic> = [
                	"&&",
                	1,
                	"^@.list"
            ];
        var ldecl = {
            "transform-t": ldeclarr1
        };

		var lsource = {
		  "list": [2, 3]
		};
		
        var lexpected:Array<Dynamic> = [1, 2, 3];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}

	public function test_path1()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": "^@.accum.0"
        };

		var lsource = {
		  "accum": [2, 3]
		};
		
        var lexpected = 2;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}

	public function test_reduce1()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclarr1: Array<Dynamic> = [[1, 2], ["a", "b"]];
        var ldecl = {
            "transform-t": {
                "&": "reduce",
                "accum": [],
                "t": {":": [
                	"&&",
                	"^@.item",
                	"^@.accum"
                ]}
            }
        };

		var lsource = {
		  "list": [1, 2, 3, 4, 5]
		};
		
        var lexpected:Array<Dynamic> = [5, 4, 3, 2, 1];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}

	public function test_reduce2()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": {
                "&": "reduce",
                "accum": 0,
                "t": {":": [
                	"&+",
                	"^@.item",
                	"^@.accum"
                ]}
            }
        };

		var lsource = {
		  "list": [1, 2, 3, 4, 5]
		};
		
        var lexpected = 15;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}

	public function test_foldone()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclarr1: Array<Dynamic> = [[1, 2], ["a", "b"]];
        var ldecl = {
            "transform-t": {
                "&": "foldone"
            }, 
            "language": "sUTL0",
            "requires": ["foldone"]
        };

		var lsource = {
		  "list": [4, 5],
		  "lists": [[1, 1], [2, 4]]
		};
		
        var lexpected:Array<Dynamic> = [
		  [
		    1,
		    1,
		    4
		  ],
		  [
		  	2,
		  	4,
		  	5
		  ]
		];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}
	
	public function test_zip()
	{
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclarr1: Array<Dynamic> = [[1, 2], ["a", "b"]];
        var ldecl = {
            "transform-t": {
                "&": "zip", 
                "list": ldeclarr1
            }, 
            "language": "sUTL0",
            "requires": ["zip"]
        };

        var lexpected:Array<Dynamic> = [[1, "a"], [2, "b"]];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
	}
	
    public function test_1a()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "addmaps_core"
            ], 
            "transform-t": {
                "!": "^*.addmaps_core", 
                "map2": {
               		"x": 1
                }, 
                "map1": {
                	"y": 2
                }
            }, 
            "language": "sUTL0"
        };
          
        var lexpected = {
          "x": 1,
          "y": 2
        };
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_1()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "addmaps_core", 
                "removekeys_core"
            ], 
            "transform-t": {
                "!": "^*.addmaps_core", 
                "map2": {
                    "__meta__": {
                        "!": "^*.removekeys_core", 
                        "map": "^$", 
                        "keys": [
                            "document"
                        ]
                    }
                }, 
                "map1": "^$.document"
            }, 
            "language": "sUTL0"
        };
          
        var lexpectedArr1:Array<Dynamic> = [
          1,
          2,
          [
            3,
            4
          ]
        ];
            
        var lexpected = {
          "description": "stuff",
          "themeindex": 6,
          "eventkeyid": "3a300a90-eca4-e101-383d-6bfd5990d791",
          "published": true,
          "__meta__": {
            "docalt": lexpectedArr1,
            "updated": 1438517599342400,
            "apkey": "2a02d608-6431-40aa-b0b2-91bf5f48cd84",
            "invalid": false,
            "stored": 1438313529667260,
            "eventkeyid": "3a300a90-eca4-e101-383d-6bfd5990d791",
            "key": "244de280-a01a-c5da-4162-ced9775246a5",
            "clientkey": "82b25cfa-f0ec-4f44-9209-77cbd98edd6a",
            "type": "CachedObject",
            "indexnames": [
              "82B25CFA-F0EC-4F44-9209-77CBD98EDD6A-Metric"
            ],
            "objecttype": "Metric"
          },
          "type": "Metric_update",
          "name": "thingo"
        };
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_2()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": "^$.indexnames.1", 
            "language": "sUTL0"
        };
          
        var lexpected = null;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_3()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "removekeys_core"
            ], 
            "transform-t": {
                        "!": "^*.removekeys_core", 
                        "map": "^$", 
                        "keys": [
                            "document",
                            "updated",
                            "apkey",
                            "key",
                            "clientkey",
                            "invalid",
                            "indexnames",
                            "docalt"
                        ]
                    },
            "language": "sUTL0"
        };
                      
        var lexpected = {
            "stored": 1438313529667260, 
            "eventkeyid": "3a300a90-eca4-e101-383d-6bfd5990d791", 
            "type": "CachedObject", 
            "objecttype": "Metric"
        };
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_4()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "isinlist_core"
            ], 
            "transform-t": {
                        "!": "^*.isinlist_core", 
                        "list": {"&": "keys", "map": "^$"}, 
                        "item": 
                            "document"
                        
                    },
            "language": "sUTL0"
        };
                      
        var lexpected = true;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_5()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "filter_core"
            ], 
            "transform-t": {
                        "!": "^*.filter_core", 
                        "list": {"&": "keys", "map": "^$"}, 
                        "filter-t": true
                    },
            "language": "sUTL0"
        };
                      
        var lexpected = [
        	"clientkey",
        	"eventkeyid",
        	"type",
        	"indexnames",
        	"objecttype",
        	"key",
        	"stored",
        	"document",
        	"updated",
        	"apkey",
        	"docalt",
        	"invalid"
        ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_6()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": {
                "&": "reduce", 
                "list": {
                	"&": "quicksort",
                	"list": {"&": "keys", "map": "^$"}
                },
                "accum": "",
                "t": {"'": 
                  {
                    "&": "+",
                    "b": "^@.item",
                    "a": "^@.accum"
                  }
                }
            }, 
            "language": "sUTL0",
            "requires": ["quicksort"]
        };
                      
        var lexpected = "apkeyclientkeydocaltdocumenteventkeyidindexnamesinvalidkeyobjecttypestoredtypeupdated";
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_7()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var lfilterDeclArr1: Array<Dynamic> = [
                "&&",
                "^@.accum",
                {
                  "&": "if",
                  "cond": {"'": 
                    {"''": "^@.filter-t"}
                  },
                  "true": ["^@.item"],
                  "false": []
                }
              ];
              
		var lfilterDecl =   {
            "name": "testfilter",
            "language": "sUTL0",
            "transform-t": 
            {
              "&": "reduce",
              "list": "^@.list",
              "accum": [],
              "t": {"'": lfilterDeclArr1}
            }
          };
        
        ljsonDecls.push([lfilterDecl]);
           
        var ldecl = {
            "requires": [
                "testfilter"
            ], 
            "transform-t": {
                "!": "^*.testfilter", 
                "list": {"&": "keys", "map": "^$"}, 
                "filter-t": {"'": {
                    "&": "=",
                    "a": "^@.item",
                    "b": "stored"
                }}
            },
            "language": "sUTL0"
        };
                      
        var lexpected = [
          "stored"
        ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_8()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": {
            "&": "if",
            "cond": [],
            "true": 1,
            "false": 0
          }
        };
                      
        var lexpected = 0;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_9()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var lreduceDecl =   {
            "name": "testreduce",
            "language": "sUTL0",
            "transform-t": 
            {
              "&": "if",
              "cond": "^@.list",
              "true": { "'": {
                "!": "^*.testreduce",
                "list": {
                  "&": "tail",
                  "b": "^@.list"
                },
                "t": "^@.t",
                "accum": {
                  "!": "^@.t",
                  "item": {
                    "&": "head",
                    "b": "^@.list"
                  },
                  "accum": "^@.accum"
                }
              }},
              "false": {
                "'": "^@.accum"
              }
            },
            "requires": [
              "testreduce", 
              "head_core_emlynoregan_com", 
              "tail_core_emlynoregan_com"
            ]
          };
        
        ljsonDecls.push([lreduceDecl]);
           
        var ldecl = {
            "requires": [
                "testreduce", "quicksort"
            ], 
            "transform-t": {
                "!": "^*.testreduce", 
                "list": {
                	"&": "quicksort",
                	"list": {"&": "keys", "map": "^$"}
                }, 
                "accum": "",
                "t": {"'": [ "&+", "^@.accum", "^@.item"]}
            }, 
            "language": "sUTL0"
        };
                      
        var lexpected = "apkeyclientkeydocaltdocumenteventkeyidindexnamesinvalidkeyobjecttypestoredtypeupdated";
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_10()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var lcondDecl =   {
            "name": "testcond",
            "language": "sUTL0",
            "transform-t": 
            {
              "&": "if",
              "cond": "^@.list",
              "true": { "'": true },
              "false": { "'": false }
            },
            "requires": [
            ]
          };
        
        ljsonDecls.push([lcondDecl]);
           
        var ldecl = {
            "requires": [
                "testcond"
            ], 
            "transform-t": {
                "!": "^*.testcond", 
                "list": {"&": "keys", "map": "^$"}
            }, 
            "language": "sUTL0"
        };
                      
        var lexpected = true;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_11()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": {
            	"&": "quicksort",
            	"list": {"&": "keys", "map": "^$"}
            },
            "language": "sUTL0",
            "requires": ["quicksort"]
        };
                      
        var lexpected = [
        	"apkey",
        	"clientkey",
        	"docalt",
        	"document",
        	"eventkeyid",
        	"indexnames",
        	"invalid",
        	"key",
        	"objecttype",
        	"stored",
        	"type",
        	"updated"
        ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_12()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "transform-t": {"'": {
            "a": "^$.updated", 
            "b": {"''": "^$.updated"}
          }}, 
          "language": "sUTL0"
        };
                      
        var lexpected = {
          "a": "^$.updated",
          "b": 1438517599342400
        };
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_13()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "zip_core"
            ], 
            "transform-t": {
                "!": "^*.zip_core", 
                "list": [[1, 2], [3, 4]]
            }, 
            "language": "sUTL0"
        };
                      
        var lexpected = [[1, 3], [2, 4]];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_14()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "requires": [
                "count_core"
            ], 
            "transform-t": {
              "&": "<",
              "a": 0,
              "b": {
                "!": "^*.count_core",
                "obj": [[],[]]
              }
            }, 
            "language": "sUTL0"
        };
                      
        var lexpected = false;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_15()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": "^$", 
            "language": "sUTL0"
        };
                      
        var lexpected = Tests_Decls.GetSource();
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_16()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
            "transform-t": {
                "&": "len",
                "list": [1, 2]
            },
            "language": "sUTL0"
        };
                      
        var lexpected = 2;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_17()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": {
            "!": "^*.foldone",
            "lists": [[1], [2]],
            "list": [3, 4]
          },
          "requires": [
            "foldone"
          ]
        };
                      
        var lexpected = [
          [
            1,
            3
          ],
          [
            2,
            4
          ]
        ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_18()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": {
            "!": "^*.quicksort",
            "list": [8, 1, 5, 3, 8, 9, 4, 3, 6, 2, 1],
          },
          "requires": [
            "quicksort"
          ]
        };
                      
        var lexpected = [
          1,
          1,
          2,
          3,
          3,
          4,
          5,
          6,
          8,
          8,
          9
        ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                Tests_Decls.GetSource()
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_19()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var lsource = {
            "x": [
                {
                    "y": "001"
                },
                {
                    "y": "002"
                },
                {
                    "y": "003"
                }
            ]
        }

        var ldecl = {
          "language": "sUTL0",
          "transform-t": "&$.x.**.y"
        };
                      
        var lexpected = [ "001", "002", "003" ];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_20()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": ["&=", "thing", "thing"]
        };
                      
        var lexpected = true;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_21()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": "^@.wontbefound"
        };
                      
        var lexpected = null;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_22()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var lsource = [
          {
            "id": "001",
            "parent": null
          },
          {
            "id": "002",
            "parent": null
          },
          {
            "id": "003",
            "parent": {
              "id": "002"
            }
          }
        ];

		var ldeclTransform: Array<Dynamic> = [
            "^%",
            {
              "!": "^*.mapget_core",
              "key": "^$.2.parent.id",
              "map": {
                  "!": "^*.idlisttomap",
                  "list": "^$",
                  "keypath": ["id"]
              }
            },
            "id"
          ];
          
        var ldecl = {
          "language": "sUTL0",
          "transform-t": ldeclTransform,
          "requires": ["mapget_core", "idlisttomap"]
        };
                      
        var lexpected = "002";
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                lsource
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_23()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclTransform: Array<Dynamic> = [
            "^%",
            {
              "x": 1,
              "y": 2
            },
            "y"
          ];
          
        var ldecl = {
          "language": "sUTL0",
          "transform-t": ldeclTransform,
          "requires": ["calcpath", "stepneedscomplete", "calcstepevents"]
        };
                      
        var lexpected = 2;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_24()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
		var ldeclTransform: Array<Dynamic> = ["&+", null, 3];
          
        var ldecl = {
          "language": "sUTL0",
          "transform-t": ldeclTransform
        };
                      
        var lexpected = 3;
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_25()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": {
            "&": "split",
            "value": "mailto:thingo@example.com",
            "sep": ":"
          }
        };
                      
        var lexpected = ["mailto", "thingo@example.com"];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_26()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": {
            "&": "trim",
            "value": "    blabo    "
          }
        };
                      
        var lexpected = "blabo";
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_27()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": 
          {
           "a": {
            "&": "pos",
            "value": "HelloWorld!!",
            "sub": "or"
           },
           "b": {
            "&": "pos",
            "value": "HelloWorld!!",
            "sub": "x"
           }
          }
        };
                      
        var lexpected = {
            "a": 6,
            "b": -1
        };
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }

    public function test_28()
    {
        var ljsonDecls:Array<Array<Dynamic>> = [LoadCoreDist()];
		
        var ldecl = {
          "language": "sUTL0",
          "transform-t": 
          {
          	"&": "map_core",
          	"list": "Hello World!!",
          	"t": {":": "^@.item"}
          },
          "requires": ["map_core"]
        };
                      
        var lexpected = ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d", "!", "!"];
          
        var lresult = EvaluateTransform(
                ldecl,
                ljsonDecls,
                null
            );
          
        this.assertTrue(Util.deepEqual(lexpected, lresult));
    }
}