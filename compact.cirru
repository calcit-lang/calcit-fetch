
{} (:package |fetch)
  :configs $ {} (:init-fn |fetch.test/main!) (:reload-fn |fetch.test/reload!) (:version |0.0.5)
    :modules $ []
  :entries $ {}
  :files $ {}
    |fetch.core $ %{} :FileEntry
      :defs $ {}
        |fetch $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn fetch (url options cb)
              &call-dylib-edn-fn (get-dylib-path "\"/dylibs/libcalcit_http") "\"fetch" url options cb
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns fetch.core $ :require
            fetch.$meta :refer $ calcit-dirname
            fetch.util :refer $ get-dylib-path
    |fetch.test $ %{} :FileEntry
      :defs $ {}
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! () $ run-tests
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! $
        |run-tests $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn run-tests () (println "\"%%%% test for lib") (println calcit-filename calcit-dirname)
              fetch "\"http://calcit-lang.org" nil $ fn (info)
                tag-match info
                    :ok text
                    println text
                  (:err e) (println "\"Err" e)
              ; fetch "\"http://localhost:4000/demo"
                {} (:method :POST)
                  :headers $ {} (:a |b)
                  :queries $ [] ([] :a |b) ([] :c |d)
                  :body "|Some body"
                fn (info)
                  tag-match info
                      :ok text
                      println text
                    (:err e) (println "\"Err" e)
              println "\"sent request"
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns fetch.test $ :require
            fetch.core :refer $ fetch
            fetch.$meta :refer $ calcit-dirname calcit-filename
    |fetch.util $ %{} :FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc |)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) "\".so" (:macos "\".dylib") (:windows "\".dll")
        |get-dylib-path $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
        |or-current-path $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn or-current-path (p)
              if (blank? p) "\"." p
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns fetch.util $ :require
            fetch.$meta :refer $ calcit-dirname
