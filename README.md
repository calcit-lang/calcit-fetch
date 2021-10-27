## Workflow

> Rust libray for Calcit runtime.

### Usages

APIs:

```cirru
fetch.core/fetch |http://calcit-lang.org nil $ fn (text)
  println text
```

Demo of options:

```cirru
fetch "\"http://localhost:4000/demo"
  {} (:method :POST)
    :headers $ {} (:a |b)
    :queries $ [] ([] :a |b)
      [] :c |d
    :body "|Some body"
  fn (info)
    key-match info
        :ok text
        println text
      (:err e)
        println "\"Err" e
      _ $ println "\"unknown:" info
```

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT
