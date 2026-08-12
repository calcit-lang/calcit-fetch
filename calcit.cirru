
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |fetch)
  :configs $ {} (:init-fn |fetch.test/main!) (:reload-fn |fetch.test/reload!) (:version |0.0.10)
    :modules $ []
  :entries $ {}
  :files $ {}
    |fetch.core $ %{} :FileEntry
      :defs $ {}
        |fetch $ %{} :CodeEntry (:doc "|Asynchronously sends an HTTP request through the native fetch dylib.\nParams: url (string), options (nil or map), cb (callback receiving (:: :ok string) or (:: :err string)).\nReturns: unit immediately; response is delivered through callback.")
          :code $ quote
            defn fetch (url options cb)
              &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |fetch url options cb
          :examples $ []
            quote $ quote
              fetch |https://calcit-lang.org nil $ fn (info)
                tag-match info
                  (:ok text) (println text)
                  (:err e) (println |Err e)
          :schema $ :: :fn
            {} (:return :unit)
              :args $ [] :string :dynamic
                :: :fn $ {} (:return :unit)
                  :args $ [] :dynamic
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns fetch.core $ :require
            fetch.$meta :refer $ calcit-dirname
            fetch.util :refer $ get-dylib-path
    |fetch.test $ %{} :FileEntry
      :defs $ {}
        |main! $ %{} :CodeEntry (:doc "|Runs fetch module demo cases.")
          :code $ quote
            defn main! () $ run-tests
          :examples $ []
          :schema $ :: :fn
            {} (:return :unit)
              :args $ []
        |reload! $ %{} :CodeEntry (:doc "|Hot reload hook for development.")
          :code $ quote
            defn reload! $
          :examples $ []
          :schema $ :: :fn
            {} (:return :unit)
              :args $ []
        |run-tests $ %{} :CodeEntry (:doc "|Prints module info and demonstrates an async GET request.")
          :code $ quote
            defn run-tests () (println "|%%%% test for lib") (println calcit-filename calcit-dirname)
              fetch |http://calcit-lang.org nil $ fn (info)
                tag-match info
                  (:ok text) (println text)
                  (:err e) (println |Err e)
              ; fetch |http://localhost:4000/demo
                {} (:method :POST)
                  :headers $ {} (:a |b)
                  :query $ [] ([] :a |b) ([] :c |d)
                  :body "|Some body"
                fn (info)
                  tag-match info
                    (:ok text) (println text)
                    (:err e) (println |Err e)
              println "|sent request"
          :examples $ []
          :schema $ :: :fn
            {} (:return :unit)
              :args $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns fetch.test $ :require
            fetch.core :refer $ fetch
            fetch.$meta :refer $ calcit-dirname calcit-filename
    |fetch.util $ %{} :FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc "|Resolves platform-specific dylib extension for the current OS.") (:schema :dynamic)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) |.so (:macos |.dylib) (:windows |.dll)
          :examples $ []
        |get-dylib-path $ %{} :CodeEntry (:doc "|Builds a dylib path relative to current module directory.")
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
          :schema $ :: :fn
            {} (:return :string)
              :args $ [] :string
        |or-current-path $ %{} :CodeEntry (:doc "|Normalizes blank directory path to current directory marker.")
          :code $ quote
            defn or-current-path (p)
              if (blank? p) |. p
          :examples $ []
          :schema $ :: :fn
            {} (:return :string)
              :args $ [] :string
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns fetch.util $ :require
            fetch.$meta :refer $ calcit-dirname
