
{} (:package |fetch)
  :configs $ {} (:init-fn |fetch.test/main!) (:port 6001) (:reload-fn |fetch.test/reload!) (:version |0.0.5)
    :modules $ []
  :entries $ {}
  :files $ {}
    |fetch.core $ %{} :FileEntry
      :defs $ {}
        |fetch $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630219258753) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630219258753) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1634715839239) (:by |u0) (:text |fetch)
              |r $ %{} :Expr (:at 1630219268038) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634715850457) (:by |u0) (:text |url)
                  |j $ %{} :Leaf (:at 1634715851485) (:by |u0) (:text |options)
                  |r $ %{} :Leaf (:at 1634716176877) (:by |u0) (:text |cb)
              |v $ %{} :Expr (:at 1630219268038) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1635271202790) (:by |u0) (:text |&call-dylib-edn-fn)
                  |b $ %{} :Expr (:at 1634715951073) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634715951430) (:by |u0) (:text |get-dylib-path)
                      |j $ %{} :Leaf (:at 1694021553914) (:by |u0) (:text "|\"/dylibs/libcalcit_http")
                  |r $ %{} :Leaf (:at 1694021542023) (:by |u0) (:text "|\"fetch")
                  |v $ %{} :Leaf (:at 1634715848679) (:by |u0) (:text |url)
                  |x $ %{} :Leaf (:at 1634716174355) (:by |u0) (:text |options)
                  |y $ %{} :Leaf (:at 1634716179983) (:by |u0) (:text |cb)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1630171366222) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1630171366222) (:by |u0) (:text |fetch.core)
            |r $ %{} :Expr (:at 1630175118985) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1630175119637) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1630175120856) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634717953426) (:by |u0) (:text |fetch.$meta)
                    |j $ %{} :Leaf (:at 1630175127717) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1630175128076) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1630175130627) (:by |u0) (:text |calcit-dirname)
                |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634717955112) (:by |u0) (:text |fetch.util)
                    |j $ %{} :Leaf (:at 1633181140100) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1633181140100) (:by |u0)
                      :data $ {}
                        |r $ %{} :Leaf (:at 1634715963670) (:by |u0) (:text |get-dylib-path)
    |fetch.test $ %{} :FileEntry
      :defs $ {}
        |main! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633149996242) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633149996242) (:by |u0) (:text |main!)
              |r $ %{} :Expr (:at 1633149996242) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1633150002066) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1633150004371) (:by |u0) (:text |run-tests)
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633149998862) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633149998862) (:by |u0) (:text |reload!)
              |r $ %{} :Expr (:at 1633149998862) (:by |u0)
                :data $ {}
        |run-tests $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1633150008092) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1633150011172) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633150008092) (:by |u0) (:text |run-tests)
              |r $ %{} :Expr (:at 1633150008092) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1634703837934) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634703847178) (:by |u0) (:text "|\"%%%% test for lib")
              |x $ %{} :Expr (:at 1634703837934) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-filename)
                  |r $ %{} :Leaf (:at 1634703837934) (:by |u0) (:text |calcit-dirname)
              |y $ %{} :Expr (:at 1634716141675) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text |fetch)
                  |j $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text "|\"http://calcit-lang.org")
                  |r $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text |nil)
                  |v $ %{} :Expr (:at 1634716141675) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text |fn)
                      |j $ %{} :Expr (:at 1634716141675) (:by |u0)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1634727501032) (:by |u0) (:text |info)
                      |r $ %{} :Expr (:at 1634727503053) (:by |u0)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1685951194516) (:by |u0) (:text |tag-match)
                          |H $ %{} :Leaf (:at 1634727611280) (:by |u0) (:text |info)
                          |L $ %{} :Expr (:at 1634727505110) (:by |u0)
                            :data $ {}
                              |T $ %{} :Expr (:at 1634727506210) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727508406) (:by |u0) (:text |:ok)
                                  |j $ %{} :Leaf (:at 1634727511863) (:by |u0) (:text |text)
                              |j $ %{} :Expr (:at 1634727513559) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727513449) (:by |u0) (:text |println)
                                  |j $ %{} :Leaf (:at 1634727514676) (:by |u0) (:text |text)
                          |P $ %{} :Expr (:at 1634727515563) (:by |u0)
                            :data $ {}
                              |T $ %{} :Expr (:at 1634727516052) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727516787) (:by |u0) (:text |:err)
                                  |j $ %{} :Leaf (:at 1634727518036) (:by |u0) (:text |e)
                              |j $ %{} :Expr (:at 1634727519410) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727520170) (:by |u0) (:text |println)
                                  |j $ %{} :Leaf (:at 1634727523611) (:by |u0) (:text "|\"Err")
                                  |r $ %{} :Leaf (:at 1634727522139) (:by |u0) (:text |e)
              |yD $ %{} :Expr (:at 1634716141675) (:by |u0)
                :data $ {}
                  |D $ %{} :Leaf (:at 1694021908104) (:by |u0) (:text |;)
                  |T $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text |fetch)
                  |j $ %{} :Leaf (:at 1635270265106) (:by |u0) (:text "|\"http://localhost:4000/demo")
                  |r $ %{} :Expr (:at 1635270179599) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1635270181252) (:by |u0) (:text |{})
                      |j $ %{} :Expr (:at 1635270181563) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635270182475) (:by |u0) (:text |:method)
                          |j $ %{} :Leaf (:at 1635270189587) (:by |u0) (:text |:POST)
                      |r $ %{} :Expr (:at 1635270194958) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635270199773) (:by |u0) (:text |:headers)
                          |j $ %{} :Expr (:at 1635270200017) (:by |u0)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1635270200375) (:by |u0) (:text |{})
                              |j $ %{} :Expr (:at 1635270201400) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1635270342401) (:by |u0) (:text |:a)
                                  |j $ %{} :Leaf (:at 1635270205758) (:by |u0) (:text ||b)
                      |v $ %{} :Expr (:at 1635270207140) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635270209614) (:by |u0) (:text |:queries)
                          |j $ %{} :Expr (:at 1635270210971) (:by |u0)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1635270211223) (:by |u0) (:text |[])
                              |j $ %{} :Expr (:at 1635270213861) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1635270214339) (:by |u0) (:text |[])
                                  |j $ %{} :Leaf (:at 1635270344404) (:by |u0) (:text |:a)
                                  |r $ %{} :Leaf (:at 1635270215909) (:by |u0) (:text ||b)
                              |r $ %{} :Expr (:at 1635270213861) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1635270214339) (:by |u0) (:text |[])
                                  |j $ %{} :Leaf (:at 1635270346067) (:by |u0) (:text |:c)
                                  |r $ %{} :Leaf (:at 1635270219947) (:by |u0) (:text ||d)
                      |x $ %{} :Expr (:at 1635270221500) (:by |u0)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1635270222231) (:by |u0) (:text |:body)
                          |j $ %{} :Leaf (:at 1635270225875) (:by |u0) (:text "||Some body")
                  |v $ %{} :Expr (:at 1634716141675) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634716141675) (:by |u0) (:text |fn)
                      |j $ %{} :Expr (:at 1634716141675) (:by |u0)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1634727501032) (:by |u0) (:text |info)
                      |r $ %{} :Expr (:at 1634727503053) (:by |u0)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1694021589800) (:by |u0) (:text |tag-match)
                          |H $ %{} :Leaf (:at 1634727611280) (:by |u0) (:text |info)
                          |L $ %{} :Expr (:at 1634727505110) (:by |u0)
                            :data $ {}
                              |T $ %{} :Expr (:at 1634727506210) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727508406) (:by |u0) (:text |:ok)
                                  |j $ %{} :Leaf (:at 1634727511863) (:by |u0) (:text |text)
                              |j $ %{} :Expr (:at 1634727513559) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727513449) (:by |u0) (:text |println)
                                  |j $ %{} :Leaf (:at 1634727514676) (:by |u0) (:text |text)
                          |P $ %{} :Expr (:at 1634727515563) (:by |u0)
                            :data $ {}
                              |T $ %{} :Expr (:at 1634727516052) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727516787) (:by |u0) (:text |:err)
                                  |j $ %{} :Leaf (:at 1634727518036) (:by |u0) (:text |e)
                              |j $ %{} :Expr (:at 1634727519410) (:by |u0)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1634727520170) (:by |u0) (:text |println)
                                  |j $ %{} :Leaf (:at 1634727523611) (:by |u0) (:text "|\"Err")
                                  |r $ %{} :Leaf (:at 1634727522139) (:by |u0) (:text |e)
              |yT $ %{} :Expr (:at 1634716142308) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634716143199) (:by |u0) (:text |println)
                  |j $ %{} :Leaf (:at 1634716152098) (:by |u0) (:text "|\"sent request")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1633149625774) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1633149625774) (:by |u0) (:text |fetch.test)
            |r $ %{} :Expr (:at 1633149974572) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1633149975596) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1634703855566) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634717944950) (:by |u0) (:text |fetch.core)
                    |j $ %{} :Leaf (:at 1634703859915) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634703860100) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634716069886) (:by |u0) (:text |fetch)
                |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634717947304) (:by |u0) (:text |fetch.$meta)
                    |j $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634703941759) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634703941759) (:by |u0) (:text |calcit-dirname)
                        |j $ %{} :Leaf (:at 1634703953240) (:by |u0) (:text |calcit-filename)
    |fetch.util $ %{} :FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630231398718) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630231418304) (:by |u0) (:text |defmacro)
              |j $ %{} :Leaf (:at 1633181058353) (:by |u0) (:text |get-dylib-ext)
              |r $ %{} :Expr (:at 1630231398718) (:by |u0)
                :data $ {}
              |v $ %{} :Expr (:at 1630231403270) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630231423910) (:by |u0) (:text |case-default)
                  |b $ %{} :Expr (:at 1630231429893) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231433951) (:by |u0) (:text |&get-os)
                  |j $ %{} :Leaf (:at 1630231427453) (:by |u0) (:text "|\".so")
                  |r $ %{} :Expr (:at 1630231437150) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231439152) (:by |u0) (:text |:macos)
                      |j $ %{} :Leaf (:at 1630231447585) (:by |u0) (:text "|\".dylib")
                  |v $ %{} :Expr (:at 1630231448478) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630231449901) (:by |u0) (:text |:windows)
                      |j $ %{} :Leaf (:at 1630231461388) (:by |u0) (:text "|\".dll")
        |get-dylib-path $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1634715906181) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1634715906181) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1634715906181) (:by |u0) (:text |get-dylib-path)
              |r $ %{} :Expr (:at 1634715906181) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634715917499) (:by |u0) (:text |p)
              |v $ %{} :Expr (:at 1634715915727) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1634715915727) (:by |u0) (:text |str)
                  |j $ %{} :Expr (:at 1634715915727) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634715915727) (:by |u0) (:text |or-current-path)
                      |j $ %{} :Leaf (:at 1634715921685) (:by |u0) (:text |calcit-dirname)
                  |r $ %{} :Leaf (:at 1634715944984) (:by |u0) (:text |p)
                  |v $ %{} :Expr (:at 1634715915727) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1634715915727) (:by |u0) (:text |get-dylib-ext)
        |or-current-path $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1630245582276) (:by |u0)
            :data $ {}
              |T $ %{} :Leaf (:at 1630245583936) (:by |u0) (:text |defn)
              |j $ %{} :Leaf (:at 1633181131099) (:by |u0) (:text |or-current-path)
              |r $ %{} :Expr (:at 1630245582276) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630245585364) (:by |u0) (:text |p)
              |v $ %{} :Expr (:at 1630245585942) (:by |u0)
                :data $ {}
                  |T $ %{} :Leaf (:at 1630245586336) (:by |u0) (:text |if)
                  |j $ %{} :Expr (:at 1630245586894) (:by |u0)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1630245614560) (:by |u0) (:text |blank?)
                      |j $ %{} :Leaf (:at 1630245615061) (:by |u0) (:text |p)
                  |r $ %{} :Leaf (:at 1630245616843) (:by |u0) (:text "|\".")
                  |v $ %{} :Leaf (:at 1630245618366) (:by |u0) (:text |p)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1633181044360) (:by |u0)
          :data $ {}
            |T $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |ns)
            |j $ %{} :Leaf (:at 1633181044360) (:by |u0) (:text |fetch.util)
            |r $ %{} :Expr (:at 1634715933337) (:by |u0)
              :data $ {}
                |T $ %{} :Leaf (:at 1634715935162) (:by |u0) (:text |:require)
                |j $ %{} :Expr (:at 1634715935562) (:by |u0)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1634718013389) (:by |u0) (:text |fetch.$meta)
                    |j $ %{} :Leaf (:at 1634715935562) (:by |u0) (:text |:refer)
                    |r $ %{} :Expr (:at 1634715935562) (:by |u0)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1634715935562) (:by |u0) (:text |calcit-dirname)
  :users $ {}
    |u0 $ {} (:avatar nil) (:id |u0) (:name |chen) (:nickname |chen) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)
