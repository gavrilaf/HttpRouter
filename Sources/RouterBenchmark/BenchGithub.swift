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
}
