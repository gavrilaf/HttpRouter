import Foundation
import HttpRouter
import HttpTestApi


func measureGithub() {
    let dictReq = PerfReq(name: "Dictionary based router (github)",
                          router: RouterDict<String>(),
                          api: Github.api,
                          staticUrl: "/user/repos",
                          paramsUrl: "/repos/gavrilaf/httprouter/stargazers")
    
    let dictRes = measureApi(dictReq)
    print("\(dictRes)")
    
    
    let arrayReq = PerfReq(name: "**** Array based router (github)",
                          router: RouterArray<String>(),
                          api: Github.api,
                          staticUrl: "/user/repos",
                          paramsUrl: "/repos/gavrilaf/httprouter/stargazers")
    
    let arrayRes = measureApi(arrayReq)
    print("\(arrayRes)")
    
    let sortedReq = PerfReq(name: "Sorted array based router (github)",
                           router: RouterSortedArray<String>(),
                           api: Github.api,
                           staticUrl: "/user/repos",
                           paramsUrl: "/repos/gavrilaf/httprouter/stargazers")
    
    let sortedRes = measureApi(sortedReq)
    print("\(sortedRes)")
}
