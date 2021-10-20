
{}
  :configs $ {} (:reload-fn |fetch.test/reload!) (:port 6001) (:version |0.0.3)
    :modules $ []
    :init-fn |fetch.test/main!
  :ir $ {} (:package |fetch)
    :files $ {}
      |fetch.core $ {}
        :defs $ {}
          |fetch $ {}
            :data $ {}
              |T $ {} (:text |defn) (:type :leaf) (:at 1630219258753) (:by |u0)
              |j $ {} (:text |fetch) (:type :leaf) (:at 1634715839239) (:by |u0)
              |r $ {}
                :data $ {}
                  |T $ {} (:text |url) (:type :leaf) (:at 1634715850457) (:by |u0)
                  |j $ {} (:text |options) (:type :leaf) (:at 1634715851485) (:by |u0)
                  |r $ {} (:text |cb) (:type :leaf) (:at 1634716176877) (:by |u0)
                :type :expr
                :at 1630219268038
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |&callback-dylib-edn) (:type :leaf) (:at 1634716160451) (:by |u0)
                  |b $ {}
                    :data $ {}
                      |T $ {} (:text |get-dylib-path) (:type :leaf) (:at 1634715951430) (:by |u0)
                      |j $ {} (:text "|\"/dylibs/libcalcit_std") (:type :leaf) (:at 1634715953339) (:by |u0)
                    :type :expr
                    :at 1634715951073
                    :by |u0
                  |r $ {} (:text "|\"fetch") (:type :leaf) (:at 1634715842381) (:by |u0)
                  |v $ {} (:text |url) (:type :leaf) (:at 1634715848679) (:by |u0)
                  |x $ {} (:text |options) (:type :leaf) (:at 1634716174355) (:by |u0)
                  |y $ {} (:text |cb) (:type :leaf) (:at 1634716179983) (:by |u0)
                :type :expr
                :at 1630219268038
                :by |u0
            :type :expr
            :at 1630219258753
            :by |u0
        :proc $ {}
          :data $ {}
          :type :expr
          :at 1630171366222
          :by |u0
        :configs $ {}
        :ns $ {}
          :data $ {}
            |T $ {} (:text |ns) (:type :leaf) (:at 1630171366222) (:by |u0)
            |j $ {} (:text |fetch.core) (:type :leaf) (:at 1630171366222) (:by |u0)
            |r $ {}
              :data $ {}
                |T $ {} (:text |:require) (:type :leaf) (:at 1630175119637) (:by |u0)
                |j $ {}
                  :data $ {}
                    |T $ {} (:text |fetch.$meta) (:type :leaf) (:at 1634717953426) (:by |u0)
                    |j $ {} (:text |:refer) (:type :leaf) (:at 1630175127717) (:by |u0)
                    |r $ {}
                      :data $ {}
                        |T $ {} (:text |calcit-dirname) (:type :leaf) (:at 1630175130627) (:by |u0)
                      :type :expr
                      :at 1630175128076
                      :by |u0
                  :type :expr
                  :at 1630175120856
                  :by |u0
                |r $ {}
                  :data $ {}
                    |T $ {} (:text |fetch.util) (:type :leaf) (:at 1634717955112) (:by |u0)
                    |j $ {} (:text |:refer) (:type :leaf) (:at 1633181140100) (:by |u0)
                    |r $ {}
                      :data $ {}
                        |r $ {} (:text |get-dylib-path) (:type :leaf) (:at 1634715963670) (:by |u0)
                      :type :expr
                      :at 1633181140100
                      :by |u0
                  :type :expr
                  :at 1633181140100
                  :by |u0
              :type :expr
              :at 1630175118985
              :by |u0
          :type :expr
          :at 1630171366222
          :by |u0
      |fetch.test $ {}
        :defs $ {}
          |run-tests $ {}
            :data $ {}
              |yT $ {}
                :data $ {}
                  |T $ {} (:text |println) (:type :leaf) (:at 1634716143199) (:by |u0)
                  |j $ {} (:text "|\"sent request") (:type :leaf) (:at 1634716152098) (:by |u0)
                :type :expr
                :at 1634716142308
                :by |u0
              |T $ {} (:text |defn) (:type :leaf) (:at 1633150011172) (:by |u0)
              |j $ {} (:text |run-tests) (:type :leaf) (:at 1633150008092) (:by |u0)
              |r $ {}
                :data $ {}
                :type :expr
                :at 1633150008092
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |println) (:type :leaf) (:at 1634703837934) (:by |u0)
                  |j $ {} (:text "|\"%%%% test for lib") (:type :leaf) (:at 1634703847178) (:by |u0)
                :type :expr
                :at 1634703837934
                :by |u0
              |x $ {}
                :data $ {}
                  |T $ {} (:text |println) (:type :leaf) (:at 1634703837934) (:by |u0)
                  |j $ {} (:text |calcit-filename) (:type :leaf) (:at 1634703837934) (:by |u0)
                  |r $ {} (:text |calcit-dirname) (:type :leaf) (:at 1634703837934) (:by |u0)
                :type :expr
                :at 1634703837934
                :by |u0
              |y $ {}
                :data $ {}
                  |T $ {} (:text |fetch) (:type :leaf) (:at 1634716141675) (:by |u0)
                  |j $ {} (:text "|\"http://calcit-lang.org") (:type :leaf) (:at 1634716141675) (:by |u0)
                  |r $ {} (:text |nil) (:type :leaf) (:at 1634716141675) (:by |u0)
                  |v $ {}
                    :data $ {}
                      |T $ {} (:text |fn) (:type :leaf) (:at 1634716141675) (:by |u0)
                      |j $ {}
                        :data $ {}
                          |D $ {} (:text |info) (:type :leaf) (:at 1634727501032) (:by |u0)
                        :type :expr
                        :at 1634716141675
                        :by |u0
                      |r $ {}
                        :data $ {}
                          |D $ {} (:text |key-match) (:type :leaf) (:at 1634727504836) (:by |u0)
                          |H $ {} (:text |info) (:type :leaf) (:at 1634727611280) (:by |u0)
                          |L $ {}
                            :data $ {}
                              |T $ {}
                                :data $ {}
                                  |T $ {} (:text |:ok) (:type :leaf) (:at 1634727508406) (:by |u0)
                                  |j $ {} (:text |text) (:type :leaf) (:at 1634727511863) (:by |u0)
                                :type :expr
                                :at 1634727506210
                                :by |u0
                              |j $ {}
                                :data $ {}
                                  |T $ {} (:text |println) (:type :leaf) (:at 1634727513449) (:by |u0)
                                  |j $ {} (:text |text) (:type :leaf) (:at 1634727514676) (:by |u0)
                                :type :expr
                                :at 1634727513559
                                :by |u0
                            :type :expr
                            :at 1634727505110
                            :by |u0
                          |P $ {}
                            :data $ {}
                              |T $ {}
                                :data $ {}
                                  |T $ {} (:text |:err) (:type :leaf) (:at 1634727516787) (:by |u0)
                                  |j $ {} (:text |e) (:type :leaf) (:at 1634727518036) (:by |u0)
                                :type :expr
                                :at 1634727516052
                                :by |u0
                              |j $ {}
                                :data $ {}
                                  |T $ {} (:text |println) (:type :leaf) (:at 1634727520170) (:by |u0)
                                  |j $ {} (:text "|\"Err") (:type :leaf) (:at 1634727523611) (:by |u0)
                                  |r $ {} (:text |e) (:type :leaf) (:at 1634727522139) (:by |u0)
                                :type :expr
                                :at 1634727519410
                                :by |u0
                            :type :expr
                            :at 1634727515563
                            :by |u0
                          |R $ {}
                            :data $ {}
                              |T $ {} (:text |_) (:type :leaf) (:at 1634727525089) (:by |u0)
                              |j $ {}
                                :data $ {}
                                  |T $ {} (:text |println) (:type :leaf) (:at 1634727528537) (:by |u0)
                                  |j $ {} (:text "|\"unknown:") (:type :leaf) (:at 1634727534181) (:by |u0)
                                  |r $ {} (:text |info) (:type :leaf) (:at 1634727536835) (:by |u0)
                                :type :expr
                                :at 1634727525997
                                :by |u0
                            :type :expr
                            :at 1634727524523
                            :by |u0
                        :type :expr
                        :at 1634727503053
                        :by |u0
                    :type :expr
                    :at 1634716141675
                    :by |u0
                :type :expr
                :at 1634716141675
                :by |u0
            :type :expr
            :at 1633150008092
            :by |u0
          |main! $ {}
            :data $ {}
              |T $ {} (:text |defn) (:type :leaf) (:at 1633149996242) (:by |u0)
              |j $ {} (:text |main!) (:type :leaf) (:at 1633149996242) (:by |u0)
              |r $ {}
                :data $ {}
                :type :expr
                :at 1633149996242
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |run-tests) (:type :leaf) (:at 1633150004371) (:by |u0)
                :type :expr
                :at 1633150002066
                :by |u0
            :type :expr
            :at 1633149996242
            :by |u0
          |reload! $ {}
            :data $ {}
              |T $ {} (:text |defn) (:type :leaf) (:at 1633149998862) (:by |u0)
              |j $ {} (:text |reload!) (:type :leaf) (:at 1633149998862) (:by |u0)
              |r $ {}
                :data $ {}
                :type :expr
                :at 1633149998862
                :by |u0
            :type :expr
            :at 1633149998862
            :by |u0
        :proc $ {}
          :data $ {}
          :type :expr
          :at 1633149625774
          :by |u0
        :configs $ {}
        :ns $ {}
          :data $ {}
            |T $ {} (:text |ns) (:type :leaf) (:at 1633149625774) (:by |u0)
            |j $ {} (:text |fetch.test) (:type :leaf) (:at 1633149625774) (:by |u0)
            |r $ {}
              :data $ {}
                |T $ {} (:text |:require) (:type :leaf) (:at 1633149975596) (:by |u0)
                |j $ {}
                  :data $ {}
                    |T $ {} (:text |fetch.core) (:type :leaf) (:at 1634717944950) (:by |u0)
                    |j $ {} (:text |:refer) (:type :leaf) (:at 1634703859915) (:by |u0)
                    |r $ {}
                      :data $ {}
                        |T $ {} (:text |fetch) (:type :leaf) (:at 1634716069886) (:by |u0)
                      :type :expr
                      :at 1634703860100
                      :by |u0
                  :type :expr
                  :at 1634703855566
                  :by |u0
                |r $ {}
                  :data $ {}
                    |T $ {} (:text |fetch.$meta) (:type :leaf) (:at 1634717947304) (:by |u0)
                    |j $ {} (:text |:refer) (:type :leaf) (:at 1634703941759) (:by |u0)
                    |r $ {}
                      :data $ {}
                        |T $ {} (:text |calcit-dirname) (:type :leaf) (:at 1634703941759) (:by |u0)
                        |j $ {} (:text |calcit-filename) (:type :leaf) (:at 1634703953240) (:by |u0)
                      :type :expr
                      :at 1634703941759
                      :by |u0
                  :type :expr
                  :at 1634703941759
                  :by |u0
              :type :expr
              :at 1633149974572
              :by |u0
          :type :expr
          :at 1633149625774
          :by |u0
      |fetch.util $ {}
        :defs $ {}
          |get-dylib-ext $ {}
            :data $ {}
              |T $ {} (:text |defmacro) (:type :leaf) (:at 1630231418304) (:by |u0)
              |j $ {} (:text |get-dylib-ext) (:type :leaf) (:at 1633181058353) (:by |u0)
              |r $ {}
                :data $ {}
                :type :expr
                :at 1630231398718
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |case-default) (:type :leaf) (:at 1630231423910) (:by |u0)
                  |b $ {}
                    :data $ {}
                      |T $ {} (:text |&get-os) (:type :leaf) (:at 1630231433951) (:by |u0)
                    :type :expr
                    :at 1630231429893
                    :by |u0
                  |j $ {} (:text "|\".so") (:type :leaf) (:at 1630231427453) (:by |u0)
                  |r $ {}
                    :data $ {}
                      |T $ {} (:text |:macos) (:type :leaf) (:at 1630231439152) (:by |u0)
                      |j $ {} (:text "|\".dylib") (:type :leaf) (:at 1630231447585) (:by |u0)
                    :type :expr
                    :at 1630231437150
                    :by |u0
                  |v $ {}
                    :data $ {}
                      |T $ {} (:text |:windows) (:type :leaf) (:at 1630231449901) (:by |u0)
                      |j $ {} (:text "|\".dll") (:type :leaf) (:at 1630231461388) (:by |u0)
                    :type :expr
                    :at 1630231448478
                    :by |u0
                :type :expr
                :at 1630231403270
                :by |u0
            :type :expr
            :at 1630231398718
            :by |u0
          |get-dylib-path $ {}
            :data $ {}
              |T $ {} (:text |defn) (:type :leaf) (:at 1634715906181) (:by |u0)
              |j $ {} (:text |get-dylib-path) (:type :leaf) (:at 1634715906181) (:by |u0)
              |r $ {}
                :data $ {}
                  |T $ {} (:text |p) (:type :leaf) (:at 1634715917499) (:by |u0)
                :type :expr
                :at 1634715906181
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |str) (:type :leaf) (:at 1634715915727) (:by |u0)
                  |j $ {}
                    :data $ {}
                      |T $ {} (:text |or-current-path) (:type :leaf) (:at 1634715915727) (:by |u0)
                      |j $ {} (:text |calcit-dirname) (:type :leaf) (:at 1634715921685) (:by |u0)
                    :type :expr
                    :at 1634715915727
                    :by |u0
                  |r $ {} (:text |p) (:type :leaf) (:at 1634715944984) (:by |u0)
                  |v $ {}
                    :data $ {}
                      |T $ {} (:text |get-dylib-ext) (:type :leaf) (:at 1634715915727) (:by |u0)
                    :type :expr
                    :at 1634715915727
                    :by |u0
                :type :expr
                :at 1634715915727
                :by |u0
            :type :expr
            :at 1634715906181
            :by |u0
          |or-current-path $ {}
            :data $ {}
              |T $ {} (:text |defn) (:type :leaf) (:at 1630245583936) (:by |u0)
              |j $ {} (:text |or-current-path) (:type :leaf) (:at 1633181131099) (:by |u0)
              |r $ {}
                :data $ {}
                  |T $ {} (:text |p) (:type :leaf) (:at 1630245585364) (:by |u0)
                :type :expr
                :at 1630245582276
                :by |u0
              |v $ {}
                :data $ {}
                  |T $ {} (:text |if) (:type :leaf) (:at 1630245586336) (:by |u0)
                  |j $ {}
                    :data $ {}
                      |T $ {} (:text |blank?) (:type :leaf) (:at 1630245614560) (:by |u0)
                      |j $ {} (:text |p) (:type :leaf) (:at 1630245615061) (:by |u0)
                    :type :expr
                    :at 1630245586894
                    :by |u0
                  |r $ {} (:text "|\".") (:type :leaf) (:at 1630245616843) (:by |u0)
                  |v $ {} (:text |p) (:type :leaf) (:at 1630245618366) (:by |u0)
                :type :expr
                :at 1630245585942
                :by |u0
            :type :expr
            :at 1630245582276
            :by |u0
        :proc $ {}
          :data $ {}
          :type :expr
          :at 1633181044360
          :by |u0
        :configs $ {}
        :ns $ {}
          :data $ {}
            |T $ {} (:text |ns) (:type :leaf) (:at 1633181044360) (:by |u0)
            |j $ {} (:text |fetch.util) (:type :leaf) (:at 1633181044360) (:by |u0)
            |r $ {}
              :data $ {}
                |T $ {} (:text |:require) (:type :leaf) (:at 1634715935162) (:by |u0)
                |j $ {}
                  :data $ {}
                    |T $ {} (:text |fetch.$meta) (:type :leaf) (:at 1634718013389) (:by |u0)
                    |j $ {} (:text |:refer) (:type :leaf) (:at 1634715935562) (:by |u0)
                    |r $ {}
                      :data $ {}
                        |T $ {} (:text |calcit-dirname) (:type :leaf) (:at 1634715935562) (:by |u0)
                      :type :expr
                      :at 1634715935562
                      :by |u0
                  :type :expr
                  :at 1634715935562
                  :by |u0
              :type :expr
              :at 1634715933337
              :by |u0
          :type :expr
          :at 1633181044360
          :by |u0
  :users $ {}
    |u0 $ {} (:avatar nil) (:name |chen) (:nickname |chen) (:id |u0) (:theme :star-trail) (:password |d41d8cd98f00b204e9800998ecf8427e)
