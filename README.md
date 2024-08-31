# toolkit.nvim neovim lua toolkit

toolkit include two class: **utils** & **filetype functions** (only go for now)

**any good ideal or useful PR are wellcome!!!** ❤️

toolkit includes:
- [x] file
- [x] vim
- [x] string
- [x] table
- [x] log
- [x] misc

filetypes:
- [x] go
- [ ] waiting for other filetype

## Install

* lazy
```lua
{
    "CaiJinKen/toolkit.nvim",
    tag = "v0.1.1",
    ft = ["go","lua"],
}
```

* Packer
```lua
use({
    "CaiJinKen/toolkit.nvim",
    tag = "v0.1.1",
})
```

* vim-plug
```lua
Plug "CaiJinKen/toolkit.nvim"
```

## spec function

### go
go dependencies can be install automatically or install by manual.
* auto install(default)
```lua
go = {
    ...
    auto_install = true
    ...
}
```

* manual install

fillstruct:
```sh
go install github.com/CaiJinKen/fillstruct@v0.1.1
```

jsongo:
```sh
go install github.com/ChimeraCoder/gojson@v1.1.0
```

gomodifytags:
```sh
go install github.com/fatih/gomodifytags@v1.17.0
```

### commands

| command       | desc                                 | detail                        |
| ------------- | --------------                       | --------------                |
| :GenSwag      | go-swag doc generator                | above the coursor line        |
| :FillStruct   | fill all fields for empty object     | under the coursor line        |
| :JsonToGo     | generate go struct from json content | replace selection             |
| :YamlToGo     | generate go struct from yaml content | replace selection             |
| :AddTags      | add tags to struct fields            | current line or selected area |
| :DelTags      | remove tags from struct fields       | current line or selected area |
| :ClearTags    | clear all tags from struct fields    | current line or selected area |
| :AddTagOpts   | add options to tags                  | current line or selected area |
| :DelTagOpts   | remove options from tags             | current line or selected area |
| :ClearTags    | clear options from tags              | current line or selected area |

#### examples 

* **`:GenSwag`** generate go-swag api doc for swagger

```go
1. package handler
2. 
3. func AddUser(ctx *gin.Context){
4.     // do what you want
5.     //......
6. }
```

set coursor to line 2 then exec `:GenSwag` , go-swag doc will be added, then you can change template by use `w` `f` `diw` etc.

```go
package handler

// FuncName     FuncDesc
// @Summary     Summary
// @Description Desc
// @Tags        Tags
// @Accept      x-www-form-urlencoded
// @Accept      json
// @Produce     json
// @Param       1Param    header   string  true "1Pram"
// @Param       2Param    path     integer true "2Pram"
// @Param       3Param    query    number  true "3Pram"
// @Param       4Param    query    bool    true "4Pram"
// @Param       Form      formData integer true "1Pram"
// @Param       Body      body     Struct  true "2Pram"
// @Success     200       {object} Object  "success"
// @Router      Path      [GET]
func AddUser(ctx *gin.Context){
    // do what you want
    // ...
}
```

* **`:FillStruct`** fill empty struct variable, including global/local/internal func
local variable:
```go
package model

import "fmt"

type User struct {
    FirstName string
    LastName  string
    Age       uint
    Addrs     []string
}

func something() {
    u := User{}
    fmt.Println(u)
}

```

set coursor to line with `u := User{}`, then exec `:FillStruct`
```go
func something() {
    u := User{FirstName: "", LastName: "", Age: 0, Addrs: []string{}}
    fmt.Println(u)
}

```
global variable
```go
package model

var u = User{}
```
move coursor to the line with `var u = User{}`, and exec `:FillStruct`
```go
package model

var u = User{FirstName: "", LastName: "", Age: 0, Addrs: []string{}}
```
internal func
```go
1. func something()func(){
2.     return func(){
3.         u := User{}
4.         // ...
5.     }
6. }
```
move coursor to line 3 and exec `:FillStruct`
```go
func something()func(){
    return func(){
        u := User{FirstName: "", LastName: "", Age: 0, Addrs: []string{}}
        // ...
    }
}
```

* **`:JsonToGo`** convert json to golang struct
assume you have file named user.go and contains json text and(or) other code
```go
// some go code above 
{
    "name":"Rechard",
    "age":30,
    "addrs":["aaa","bbb","ccc"]
}

// other go code below
```
press `v` to select hole json text, then exec `:JsonToGo`
```go
// some go code above 
type User struct {
    FirstName string   `json:"first_name"`
    LastName  string   `json:"last_name"`
    Age       uint     `json:"age"`
    Addrs     []string `json:"addrs"`
}

// other go code below

```

* **`:YamlToGo`** same as **`:JsonToGo`** but yaml style

* **`:AddTags`** add tags to struct single line or selected fields
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint
5.     Addrs     []string
6. }
```
set coursor to line 4 and exec `:AddTags json,yaml,uri`, you can set what tags you want, comma split
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint `json:"age" yaml:"age" uri:"age"`
5.     Addrs     []string
6. }
```

you can select fields you want to add tags by press `v` + `j` or `k`, or all fields with `vi{`, then exec the command. eg select lines 4 and 5
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint     `json:"age" yaml:"age" uri:"age"`
5.	   Addrs     []string `json:"addrs" yaml:"addrs" uri:"addrs"`
6. }
```

* **`:DelTags`** delete spec tags 
line to 4, then exec `:DelTags json,uri`. selection supported also
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint     `yaml:"age"`
5.	   Addrs     []string `json:"addrs" yaml:"addrs" uri:"addrs"`
6. }
```

* **`:ClearTags`**  clear all tags & options in current line or selection. **with no tags type in**. eg line to 5 and exec command
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint     `yaml:"age"`
5.	   Addrs     []string
6. }
```

* **`:AddTagOpts`** add options to tags. eg line to 4 and exec `:AddTagOpts yaml=omitempty,yaml=aaa,yaml=bbb`
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint `yaml:"age,omitempty,aaa,bbb"`
5.	   Addrs     []string
6. }
```

* **`:DelTagOpts`** remove options. eg line to 4 and exec `:DelTagOpts yaml=aaa,yaml=bbb`
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint `yaml:"age,omitempty"`
5.	   Addrs     []string
6. }
```

* **`:ClearTagOpts`** clear all options. eg line to 4 and exec `:ClearTagOpts`
```go
1. type User struct {
2.     FirstName string
3.     LastName  string
4.     Age       uint `yaml:"age"`
5.	   Addrs     []string
6. }
```

## vimscript user 

If you just want fillstruct or gojson, you can use:

[vim-fillstruct](https://github.com/CaiJinKen/vim-fillstruct)

[vim-sortimport](https://github.com/CaiJinKen/vim-sortimport)

[vim-jsontogo](https://github.com/meain/vim-jsontogo)

## configuration

default configuration:

```lua
require("toolkit").setup({
    go = {
        -- go filetype commands will not set if value is false
		enable = true,
        -- whether install programs
		auto_install = true,
		enable_cmds = {
			"GenSwag",
			"FillStruct",
			"JsonToGo",
			"YamlToGo",
			"AddTags",
			"DelTags",
			"ClearTags",
			"AddTagOpts",
			"DelTagOpts",
			"ClearTagOpts",
		},
		tags_transform = "snakecase", -- options: [snakecase, camelcase, lispcase, pascalcase, titlecase, keep]
	}
})
```
