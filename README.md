# toolkit.nvim neovim lua toolkit

toolkit include two class: utils & filetype functions

toolkit includes:
[x] file
[x] vim
[x] string
[x] table
[x] misc

filetypes:
[x] go
[] waiting for

## Install

* lazy
```lua
{
    "CaiJinKen/toolkit.nvim",
    tag = "v0.1.0",
    ft = ["go","lua"],
}
```

* Packer
```lua
use({
    "CaiJinKen/toolkit.nvim",
    tag = "v0.1.0",
})
```

* vim-plug
```lua
Plug "CaiJinKen/toolkit.nvim"
```

## spec function

* go
fillstruct:
```sh
go install github.com/CaiJinKen/fillstruct@v0.1.1
```
jsongo:
```sh
go install github.com/ChimeraCoder/gojson@v1.1.0
```

| command       | desc                                      | detail                 |
| ------------- | --------------                            | --------------         |
| :GenSwag      | go-swag doc generator                     | above the coursor line |
| :FillStruct   | fill all fields for empty object          | under the coursor line |
| :JsonToGo     | generate go struct from json/yaml content | replace selection      |

## vimscript user 
If you just want fillstruct or gojson, you can use:
[vim-fillstruct](https://github.com/CaiJinKen/vim-fillstruct)
[vim-sortimport](https://github.com/CaiJinKen/vim-sortimport)
[vim-jsontogo](https://github.com/meain/vim-jsontogo)
