# Input variables

## Syntax
### Environment Variables
* **String**: `TF_VAR_image=foo`
* **List**: (aka, array) `TF_VAR_somelist='["this", "one", "that", "one"]`
* **Map**: (aka, hash) `TF_VAR_somemap='{foo = "bar", baz = "qux"}'`

### Command-line variables
* **Example:** `terraform -var 'foo={one="two",three="four"}'

### Command-line variable files
* **Example:** `terraform -var-file=myVars.tfvar apply'

### Variable files
Variables can be defned in a psuedo-JSON way. 

```
variable "key" {
  type = "string"
}

variable "zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "images" {
  type = "map"

  default = {
    us-east-1 = "image-1234"
    us-west-2 = "image-4567"
  }
}

variable "zones" {
   type = "boolean"
   default = 0
}

```
There are 4 types of values:
1. String
1. Lists (array)
1. Maps (hash; can these be multidimensional?)
1. Booleans (if I'm reading the docs correctly, you should use 0/1 to avoid issues going forward)

### Modules
Variables can be defined in the module call:

```
module "vms" {
  source  = "cardinalsolutions/azure"
  servers = 5
}
```

## Scope

## Order of Precedence
1. OS environment variables (named with the `TF_VAR_` prefix)
1. Last stated var file on command line (last definition loaded wins)
   * `-var-file=` or `-var 'foo={quux="bar"}' -var 'foo={bar="baz"}'`

If using modules, who's variable takes precendence, the parent's or the child's?  I would hope the parent's would, but I can imagine an argument where the child wins.
