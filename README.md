# Lua++

A preprocessor for Lua, aiming to make it easier and more fun to work with.

The goal is to create a strict super set of Lua, meaning that any code that is valid in Lua is also valid in Lua++, but not the other way around, with all of its extra features being completely optional. In addition, Lua++ is not intended to be "it's own thing" with a custom interpreter / runtime and such. Instead, it is compiled to standard Lua and can be executed with any Lua >5.1 interpreter.

**Please note** that this project is very experimental.

Currently (partially) implemented features:

- `class`es
  
  - ```lua
    local class MyClass()
    end
    ```
    
    - The brackets aren't arbitrary and have a meaning:
      
      1. This is the end of the definition (because I think that `class MyClass do` seems a bit weird) and
      
      2. If there is something written inside of them, it will be used as the name for the parent class to inherit properties from.
         
         - Multiple inheritance is currently not planned.

Planned features / TODOs:

- Inheritance support for classes.

- Macros that translate to different code depending on the targeted Lua version.
  
  - For example, `@unpack()` could translate to `unpack()` for Lua 5.1 and `table.unpack()` for later versions (this might not be the best example since `local unpack = unpack or table.unpack` would also work, with the added bonus of also being cross-version compatible, however, there are some more "quirky" things where that wouldn't be as nice).

- `async` / `await` syntax for asynchronous programming.

- `match`-statement for pattern matching.
  
  - ```lua
    local x = "foo"
    local lang_name = "lua"
    
    match x do
        case "foo"|"bar"|lang_name do
            print("It's a place holder")
        end
    
        default
            print("It's not a place holder")
        end
    end
    ```

- `enum`s

- JavaScript-style lambda expressions using a fat arrow (without curly bracket support)

---

This project uses [LuaMacro by stevedonovan](https://github.com/stevedonovan/LuaMacro).
