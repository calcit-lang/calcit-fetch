
{}
  :configs $ {} (:init-fn |fetch.test/main!) (:port 6001) (:reload-fn |fetch.test/reload!) (:version |0.0.3)
    :modules $ []
  :entries $ {}
  :ir $ {} (:package |fetch)
    :files $ {}
      |fetch.core $ {}
        :configs $ {}
        :defs $ {}
          |fetch $ {} (:at 1630219258753) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630219258753) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1634715839239) (:by |u0) (:text |fetch) (:type :leaf)
              |r $ {} (:at 1630219268038) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634715850457) (:by |u0) (:text |url) (:type :leaf)
                  |j $ {} (:at 1634715851485) (:by |u0) (:text |options) (:type :leaf)
                  |r $ {} (:at 1634716176877) (:by |u0) (:text |cb) (:type :leaf)
              |v $ {} (:at 1630219268038) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1635271202790) (:by |u0) (:text |&call-dylib-edn-fn) (:type :leaf)
                  |b $ {} (:at 1634715951073) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634715951430) (:by |u0) (:text |get-dylib-path) (:type :leaf)
                      |j $ {} (:at 1635271734146) (:by |u0) (:text "|\"/dylibs/libcalcit_http") (:type :leaf)
                  |r $ {} (:at 1634715842381) (:by |u0) (:text "|\"fetch") (:type :leaf)
                  |v $ {} (:at 1634715848679) (:by |u0) (:text |url) (:type :leaf)
                  |x $ {} (:at 1634716174355) (:by |u0) (:text |options) (:type :leaf)
                  |y $ {} (:at 1634716179983) (:by |u0) (:text |cb) (:type :leaf)
        :ns $ {} (:at 1630171366222) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1630171366222) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1630171366222) (:by |u0) (:text |fetch.core) (:type :leaf)
            |r $ {} (:at 1630175118985) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1630175119637) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1630175120856) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634717953426) (:by |u0) (:text |fetch.$meta) (:type :leaf)
                    |j $ {} (:at 1630175127717) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1630175128076) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1630175130627) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                |r $ {} (:at 1633181140100) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634717955112) (:by |u0) (:text |fetch.util) (:type :leaf)
                    |j $ {} (:at 1633181140100) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1633181140100) (:by |u0) (:type :expr)
                      :data $ {}
                        |r $ {} (:at 1634715963670) (:by |u0) (:text |get-dylib-path) (:type :leaf)
        :proc $ {} (:at 1630171366222) (:by |u0) (:type :expr)
          :data $ {}
      |fetch.test $ {}
        :configs $ {}
        :defs $ {}
          |main! $ {} (:at 1633149996242) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633149996242) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633149996242) (:by |u0) (:text |main!) (:type :leaf)
              |r $ {} (:at 1633149996242) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1633150002066) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1633150004371) (:by |u0) (:text |run-tests) (:type :leaf)
          |reload! $ {} (:at 1633149998862) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633149998862) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633149998862) (:by |u0) (:text |reload!) (:type :leaf)
              |r $ {} (:at 1633149998862) (:by |u0) (:type :expr)
                :data $ {}
          |run-tests $ {} (:at 1633150008092) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1633150011172) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633150008092) (:by |u0) (:text |run-tests) (:type :leaf)
              |r $ {} (:at 1633150008092) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1634703837934) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634703837934) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634703847178) (:by |u0) (:text "|\"%%%% test for lib") (:type :leaf)
              |x $ {} (:at 1634703837934) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634703837934) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634703837934) (:by |u0) (:text |calcit-filename) (:type :leaf)
                  |r $ {} (:at 1634703837934) (:by |u0) (:text |calcit-dirname) (:type :leaf)
              |y $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634716141675) (:by |u0) (:text |fetch) (:type :leaf)
                  |j $ {} (:at 1634716141675) (:by |u0) (:text "|\"http://calcit-lang.org") (:type :leaf)
                  |r $ {} (:at 1634716141675) (:by |u0) (:text |nil) (:type :leaf)
                  |v $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634716141675) (:by |u0) (:text |fn) (:type :leaf)
                      |j $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                        :data $ {}
                          |D $ {} (:at 1634727501032) (:by |u0) (:text |info) (:type :leaf)
                      |r $ {} (:at 1634727503053) (:by |u0) (:type :expr)
                        :data $ {}
                          |D $ {} (:at 1685951194516) (:by |u0) (:text |tag-match) (:type :leaf)
                          |H $ {} (:at 1634727611280) (:by |u0) (:text |info) (:type :leaf)
                          |L $ {} (:at 1634727505110) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727506210) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727508406) (:by |u0) (:text |:ok) (:type :leaf)
                                  |j $ {} (:at 1634727511863) (:by |u0) (:text |text) (:type :leaf)
                              |j $ {} (:at 1634727513559) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727513449) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727514676) (:by |u0) (:text |text) (:type :leaf)
                          |P $ {} (:at 1634727515563) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727516052) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727516787) (:by |u0) (:text |:err) (:type :leaf)
                                  |j $ {} (:at 1634727518036) (:by |u0) (:text |e) (:type :leaf)
                              |j $ {} (:at 1634727519410) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727520170) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727523611) (:by |u0) (:text "|\"Err") (:type :leaf)
                                  |r $ {} (:at 1634727522139) (:by |u0) (:text |e) (:type :leaf)
                          |R $ {} (:at 1634727524523) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727525089) (:by |u0) (:text |_) (:type :leaf)
                              |j $ {} (:at 1634727525997) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727528537) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727534181) (:by |u0) (:text "|\"unknown:") (:type :leaf)
                                  |r $ {} (:at 1634727536835) (:by |u0) (:text |info) (:type :leaf)
              |yD $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                :data $ {}
                  |D $ {} (:at 1635270392925) (:by |u0) (:text |;) (:type :leaf)
                  |T $ {} (:at 1634716141675) (:by |u0) (:text |fetch) (:type :leaf)
                  |j $ {} (:at 1635270265106) (:by |u0) (:text "|\"http://localhost:4000/demo") (:type :leaf)
                  |r $ {} (:at 1635270179599) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1635270181252) (:by |u0) (:text |{}) (:type :leaf)
                      |j $ {} (:at 1635270181563) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635270182475) (:by |u0) (:text |:method) (:type :leaf)
                          |j $ {} (:at 1635270189587) (:by |u0) (:text |:POST) (:type :leaf)
                      |r $ {} (:at 1635270194958) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635270199773) (:by |u0) (:text |:headers) (:type :leaf)
                          |j $ {} (:at 1635270200017) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1635270200375) (:by |u0) (:text |{}) (:type :leaf)
                              |j $ {} (:at 1635270201400) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1635270342401) (:by |u0) (:text |:a) (:type :leaf)
                                  |j $ {} (:at 1635270205758) (:by |u0) (:text ||b) (:type :leaf)
                      |v $ {} (:at 1635270207140) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635270209614) (:by |u0) (:text |:queries) (:type :leaf)
                          |j $ {} (:at 1635270210971) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1635270211223) (:by |u0) (:text |[]) (:type :leaf)
                              |j $ {} (:at 1635270213861) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1635270214339) (:by |u0) (:text |[]) (:type :leaf)
                                  |j $ {} (:at 1635270344404) (:by |u0) (:text |:a) (:type :leaf)
                                  |r $ {} (:at 1635270215909) (:by |u0) (:text ||b) (:type :leaf)
                              |r $ {} (:at 1635270213861) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1635270214339) (:by |u0) (:text |[]) (:type :leaf)
                                  |j $ {} (:at 1635270346067) (:by |u0) (:text |:c) (:type :leaf)
                                  |r $ {} (:at 1635270219947) (:by |u0) (:text ||d) (:type :leaf)
                      |x $ {} (:at 1635270221500) (:by |u0) (:type :expr)
                        :data $ {}
                          |T $ {} (:at 1635270222231) (:by |u0) (:text |:body) (:type :leaf)
                          |j $ {} (:at 1635270225875) (:by |u0) (:text "||Some body") (:type :leaf)
                  |v $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634716141675) (:by |u0) (:text |fn) (:type :leaf)
                      |j $ {} (:at 1634716141675) (:by |u0) (:type :expr)
                        :data $ {}
                          |D $ {} (:at 1634727501032) (:by |u0) (:text |info) (:type :leaf)
                      |r $ {} (:at 1634727503053) (:by |u0) (:type :expr)
                        :data $ {}
                          |D $ {} (:at 1634727504836) (:by |u0) (:text |key-match) (:type :leaf)
                          |H $ {} (:at 1634727611280) (:by |u0) (:text |info) (:type :leaf)
                          |L $ {} (:at 1634727505110) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727506210) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727508406) (:by |u0) (:text |:ok) (:type :leaf)
                                  |j $ {} (:at 1634727511863) (:by |u0) (:text |text) (:type :leaf)
                              |j $ {} (:at 1634727513559) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727513449) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727514676) (:by |u0) (:text |text) (:type :leaf)
                          |P $ {} (:at 1634727515563) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727516052) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727516787) (:by |u0) (:text |:err) (:type :leaf)
                                  |j $ {} (:at 1634727518036) (:by |u0) (:text |e) (:type :leaf)
                              |j $ {} (:at 1634727519410) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727520170) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727523611) (:by |u0) (:text "|\"Err") (:type :leaf)
                                  |r $ {} (:at 1634727522139) (:by |u0) (:text |e) (:type :leaf)
                          |R $ {} (:at 1634727524523) (:by |u0) (:type :expr)
                            :data $ {}
                              |T $ {} (:at 1634727525089) (:by |u0) (:text |_) (:type :leaf)
                              |j $ {} (:at 1634727525997) (:by |u0) (:type :expr)
                                :data $ {}
                                  |T $ {} (:at 1634727528537) (:by |u0) (:text |println) (:type :leaf)
                                  |j $ {} (:at 1634727534181) (:by |u0) (:text "|\"unknown:") (:type :leaf)
                                  |r $ {} (:at 1634727536835) (:by |u0) (:text |info) (:type :leaf)
              |yT $ {} (:at 1634716142308) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634716143199) (:by |u0) (:text |println) (:type :leaf)
                  |j $ {} (:at 1634716152098) (:by |u0) (:text "|\"sent request") (:type :leaf)
        :ns $ {} (:at 1633149625774) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1633149625774) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1633149625774) (:by |u0) (:text |fetch.test) (:type :leaf)
            |r $ {} (:at 1633149974572) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1633149975596) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1634703855566) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634717944950) (:by |u0) (:text |fetch.core) (:type :leaf)
                    |j $ {} (:at 1634703859915) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634703860100) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634716069886) (:by |u0) (:text |fetch) (:type :leaf)
                |r $ {} (:at 1634703941759) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634717947304) (:by |u0) (:text |fetch.$meta) (:type :leaf)
                    |j $ {} (:at 1634703941759) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634703941759) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634703941759) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                        |j $ {} (:at 1634703953240) (:by |u0) (:text |calcit-filename) (:type :leaf)
        :proc $ {} (:at 1633149625774) (:by |u0) (:type :expr)
          :data $ {}
      |fetch.util $ {}
        :configs $ {}
        :defs $ {}
          |get-dylib-ext $ {} (:at 1630231398718) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630231418304) (:by |u0) (:text |defmacro) (:type :leaf)
              |j $ {} (:at 1633181058353) (:by |u0) (:text |get-dylib-ext) (:type :leaf)
              |r $ {} (:at 1630231398718) (:by |u0) (:type :expr)
                :data $ {}
              |v $ {} (:at 1630231403270) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630231423910) (:by |u0) (:text |case-default) (:type :leaf)
                  |b $ {} (:at 1630231429893) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231433951) (:by |u0) (:text |&get-os) (:type :leaf)
                  |j $ {} (:at 1630231427453) (:by |u0) (:text "|\".so") (:type :leaf)
                  |r $ {} (:at 1630231437150) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231439152) (:by |u0) (:text |:macos) (:type :leaf)
                      |j $ {} (:at 1630231447585) (:by |u0) (:text "|\".dylib") (:type :leaf)
                  |v $ {} (:at 1630231448478) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630231449901) (:by |u0) (:text |:windows) (:type :leaf)
                      |j $ {} (:at 1630231461388) (:by |u0) (:text "|\".dll") (:type :leaf)
          |get-dylib-path $ {} (:at 1634715906181) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1634715906181) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1634715906181) (:by |u0) (:text |get-dylib-path) (:type :leaf)
              |r $ {} (:at 1634715906181) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634715917499) (:by |u0) (:text |p) (:type :leaf)
              |v $ {} (:at 1634715915727) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1634715915727) (:by |u0) (:text |str) (:type :leaf)
                  |j $ {} (:at 1634715915727) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634715915727) (:by |u0) (:text |or-current-path) (:type :leaf)
                      |j $ {} (:at 1634715921685) (:by |u0) (:text |calcit-dirname) (:type :leaf)
                  |r $ {} (:at 1634715944984) (:by |u0) (:text |p) (:type :leaf)
                  |v $ {} (:at 1634715915727) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1634715915727) (:by |u0) (:text |get-dylib-ext) (:type :leaf)
          |or-current-path $ {} (:at 1630245582276) (:by |u0) (:type :expr)
            :data $ {}
              |T $ {} (:at 1630245583936) (:by |u0) (:text |defn) (:type :leaf)
              |j $ {} (:at 1633181131099) (:by |u0) (:text |or-current-path) (:type :leaf)
              |r $ {} (:at 1630245582276) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630245585364) (:by |u0) (:text |p) (:type :leaf)
              |v $ {} (:at 1630245585942) (:by |u0) (:type :expr)
                :data $ {}
                  |T $ {} (:at 1630245586336) (:by |u0) (:text |if) (:type :leaf)
                  |j $ {} (:at 1630245586894) (:by |u0) (:type :expr)
                    :data $ {}
                      |T $ {} (:at 1630245614560) (:by |u0) (:text |blank?) (:type :leaf)
                      |j $ {} (:at 1630245615061) (:by |u0) (:text |p) (:type :leaf)
                  |r $ {} (:at 1630245616843) (:by |u0) (:text "|\".") (:type :leaf)
                  |v $ {} (:at 1630245618366) (:by |u0) (:text |p) (:type :leaf)
        :ns $ {} (:at 1633181044360) (:by |u0) (:type :expr)
          :data $ {}
            |T $ {} (:at 1633181044360) (:by |u0) (:text |ns) (:type :leaf)
            |j $ {} (:at 1633181044360) (:by |u0) (:text |fetch.util) (:type :leaf)
            |r $ {} (:at 1634715933337) (:by |u0) (:type :expr)
              :data $ {}
                |T $ {} (:at 1634715935162) (:by |u0) (:text |:require) (:type :leaf)
                |j $ {} (:at 1634715935562) (:by |u0) (:type :expr)
                  :data $ {}
                    |T $ {} (:at 1634718013389) (:by |u0) (:text |fetch.$meta) (:type :leaf)
                    |j $ {} (:at 1634715935562) (:by |u0) (:text |:refer) (:type :leaf)
                    |r $ {} (:at 1634715935562) (:by |u0) (:type :expr)
                      :data $ {}
                        |T $ {} (:at 1634715935562) (:by |u0) (:text |calcit-dirname) (:type :leaf)
        :proc $ {} (:at 1633181044360) (:by |u0) (:type :expr)
          :data $ {}
  :users $ {}
    |u0 $ {} (:avatar nil) (:id |u0) (:name |chen) (:nickname |chen) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)
