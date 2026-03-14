## Calcit Fetch

> Fetch client for Calcit

Native requests are executed asynchronously through the fetch dylib. The public API calls the callback with either `(:: :ok text)` or `(:: :err message)`.

### Usages

APIs:

```cirru
fetch.core/fetch |http://calcit-lang.org nil $ fn (info)
  tag-match info
    (:ok text)
      println text
    (:err e)
      println "\"Err" e
```

Demo of options:

```cirru
fetch "\"http://localhost:4000/demo"
  {} (:method :POST)
    :headers $ {} (:a |b)
    :query $ [] ([] :a |b)
      [] :c |d
    :body "|Some body"
  fn (info)
    tag-match info
      (:ok text)
        println text
      (:err e)
        println "\"Err" e
```

Supported option keys:

- `:method` - request method tag such as `:GET`, `:POST`, `:PUT`, `:PATCH`, `:DELETE`
- `:headers` - map from string/tag keys to string values
- `:query` - list of `[key value]` pairs, with key as string or tag and value as string
- `:body` - request body string

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT
