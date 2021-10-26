
{} (:package |fetch)
  :configs $ {} (:init-fn |fetch.test/main!) (:reload-fn |fetch.test/reload!)
    :modules $ []
    :version |0.0.1
  :files $ {}
    |fetch.core $ {}
      :ns $ quote
        ns fetch.core $ :require
          fetch.$meta :refer $ calcit-dirname
          fetch.util :refer $ get-dylib-path
      :defs $ {}
        |fetch $ quote
          defn fetch (url options cb)
            &call-dylib-edn-fn (get-dylib-path "\"/dylibs/libcalcit_http") "\"fetch" url options cb
    |fetch.test $ {}
      :ns $ quote
        ns fetch.test $ :require
          fetch.core :refer $ fetch
          fetch.$meta :refer $ calcit-dirname calcit-filename
      :defs $ {}
        |run-tests $ quote
          defn run-tests () (println "\"%%%% test for lib") (println calcit-filename calcit-dirname)
            fetch "\"http://calcit-lang.org" nil $ fn (info)
              key-match info
                  :ok text
                  println text
                (:err e) (println "\"Err" e)
                _ $ println "\"unknown:" info
            ; fetch "\"http://localhost:4000/demo"
              {} (:method :POST)
                :headers $ {} (:a |b)
                :queries $ [] ([] :a |b) ([] :c |d)
                :body "|Some body"
              fn (info)
                key-match info
                    :ok text
                    println text
                  (:err e) (println "\"Err" e)
                  _ $ println "\"unknown:" info
            println "\"sent request"
        |main! $ quote
          defn main! () $ run-tests
        |reload! $ quote
          defn reload! $
    |fetch.util $ {}
      :ns $ quote
        ns fetch.util $ :require
          fetch.$meta :refer $ calcit-dirname
      :defs $ {}
        |get-dylib-ext $ quote
          defmacro get-dylib-ext () $ case-default (&get-os) "\".so" (:macos "\".dylib") (:windows "\".dll")
        |get-dylib-path $ quote
          defn get-dylib-path (p)
            str (or-current-path calcit-dirname) p $ get-dylib-ext
        |or-current-path $ quote
          defn or-current-path (p)
            if (blank? p) "\"." p
