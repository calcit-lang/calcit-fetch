
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |fetch) (:version |0.0.10)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'fetch.test/main!) (:mode :native) (:reload-fn 'fetch.test/reload!)
      :modules $ []
      :type-slots $ {}
  :files $ {}
    |fetch.core $ %{} 'FileEntry
      :defs $ {}
        |fetch $ %{} 'CodeEntry (:doc "|Asynchronously sends an HTTP request through the native fetch dylib.\nParams: url (string), options (nil or map), cb (callback receiving (:: :ok string) or (:: :err string)).\nReturns: unit immediately; response is delivered through callback.")
          :code $ quote
            defn fetch (url options cb)
              &call-dylib-edn-fn (get-dylib-path |/dylibs/libcalcit_http) |fetch url options cb
          :examples $ []
            quote $ quote
              fetch |https://calcit-lang.org nil $ fn (info)
                tag-match info
                  (:ok text) (println text)
                  (:err e) (println |Err e)
          :ffi $ {} (:backend :native) (:symbol |fetch)
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ [] 'String 'Dynamic
                :: 'Fn $ {} (:return 'Unit)
                  :args $ [] 'Dynamic
              :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns fetch.core $ :require
            fetch.$meta :refer $ calcit-dirname
            fetch.util :refer $ get-dylib-path
    |fetch.test $ %{} 'FileEntry
      :defs $ {}
        |main! $ %{} 'CodeEntry (:doc "|Runs fetch module demo cases.")
          :code $ quote
            defn main! () $ run-tests
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        |reload! $ %{} 'CodeEntry (:doc "|Hot reload hook for development.")
          :code $ quote
            defn reload! $
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        |run-tests $ %{} 'CodeEntry (:doc "|Prints module info and demonstrates an async GET request.")
          :code $ quote
            defn run-tests () (println "|%%%% test for lib") (println calcit-filename calcit-dirname)
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
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns fetch.test $ :require
            fetch.core :refer $ fetch
            fetch.$meta :refer $ calcit-dirname calcit-filename
    |fetch.util $ %{} 'FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} 'CodeEntry (:doc "|Resolves platform-specific dylib extension for the current OS.")
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) |.so (:macos |.dylib) (:windows |.dll)
          :examples $ []
          :ffi $ {} (:backend :native)
          :schema $ :: 'Macro
            {} (:return 'String)
              :args $ []
        |get-dylib-path $ %{} 'CodeEntry (:doc "|Builds a dylib path relative to current module directory.")
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String
        |or-current-path $ %{} 'CodeEntry (:doc "|Normalizes blank directory path to current directory marker.")
          :code $ quote
            defn or-current-path (p)
              if (blank? p) |. p
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns fetch.util $ :require
            fetch.$meta :refer $ calcit-dirname
