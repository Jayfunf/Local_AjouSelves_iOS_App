//
//  productdataViewModel.swift
//  AjouSelves_iOS_App
//
//  Created by Minhyun Cho on 2022/03/31.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

//MARK: - 두개의 alert를 사용하기 위함
enum ActiveAlert {
    case success, fail
}

class productdataViewModel: ObservableObject {
    
    //MARK: - Properties
    var subscription = Set<AnyCancellable>() // 메모리 관리
    
    @Published var projectAllDataParcings = [projectAllDataParcing]()
    
    @Published var postAllDatas = [postStruct.postAllData]()
    
    @Published var userCreateDetails = [userCreate.userCreateDetail]()
    
    @Published var userJoinDetails = [userJoin.userJoinDetail]()
    
    @Published var projJoin_LeaveIds = [projJoin_LeaveId]()
    @Published var userGets = [userGet]()
    @Published var userToken: String = "" // UserDefaults를 사용하기전 토큰 저장 레거시
    @Published var photoData: UIImage = UIImage() // 커뮤니티 사진 등록
    
    
    //MARK: for QR
    @Published var QRPhoto: UIImage = UIImage()
    @Published var QRlink: String = ""
    
    //MARK: for register
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var sex: Int  = 0
    @Published var phonenumber: String = ""
    @Published var nickname: String = ""
    @Published var status: String = "재학생"
    @Published var socialtype: String = ""
    @Published var birth: String = ""
    @Published var address: String = "dummy"
    @Published var profilelink: String = "https://kakao.com/abcd"
    @Published var bank: String = ""
    @Published var account: String = ""
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    @Published var wakeUp = Date()
    
    //MARK: for communityAdd
    @Published var title: String = ""
    @Published var explained: String = ""
    
    //MARK: - 상태저장형재들
    var registerCheck: Bool = false // 회원의 입력 항목중 빈 항목이 있다면 true로 체크
    var registerisSuccess: Bool = false // 회원가입이 성공적으로 이루어져 success를 받으면 true
    var registerEmpty: String = "" // 회원가입 필수 항목중 빈 항목이 있으면 여기에 저장
    var registerisFail: Bool = false // 회원가입이 실패하면 true
    var loginisSuccess: Bool = false // 로그인을 성공하면 true
    var postAddCheck: Bool = true // 게시글 추가 상태 하나의 필드(제목, 설명)이라도 비어있으면 false
    var postAddSuccess: Bool = false // 게시글 추가 상태 모든 postAddCheck가 통괴되면 true
    var postPhotoCheck: Bool = true // 게시글 추가시 사진 유무 반환
    
    //MARK: - URL -> lowerCamelCase
    
    var userAllUrl = "http://goodsbyus.com/api/user/all" // 전체 유저 데이터 불러옴
    
    var postAllUrl = "http://goodsbyus.com/api/post" // 커뮤니티 게시글 전체 조회
    
    var postPhotoUrl = "http://goodsbyus.com/api/post/photo" // 커뮤니티 게시글 추가 (사진O)
    
    var postUrl = "http://goodsbyus.com/api/post/" // 커뮤니티 게시글 추가 (사진X)
    
    var authRegisterUrl = "http://goodsbyus.com/api/auth/register" // 유저 데이터 삽입
    
    var projUrl = "http://goodsbyus.com/api/proj/" // 프로젝트 목록
    
    var authLoginUrl = "http://goodsbyus.com/api/auth/login" // 로그인 토큰 발급
    
    var userJoinDetailUrl = "http://goodsbyus.com/api/user/join-detail"
    
    var userCreateDetailUrl = "http://goodsbyus.com/api/user/create-detail"
    
    var projJoinIdUrl = "https://goodsbyus.com/api/proj/join/"
    
    var projLeaveIdUrl = "http://goodsbyus.com/api/proj/leave/"
    
    var userUrl = "http://goodsbyus.com/api/user"
    
    var projPayQrUrl = "http://goodsbyus.com/api/projpay/qr/"
    
    
    //MARK: - legacy
//    init() {
//        print("init productdataViewModel")
//        //authLogin(url: authLoginUrl) // 유저 로그인 -> 토큰 반환
//        //fetchRandomUserApi() // 랜덤유저api
//        //fetchUserAllUrl() // 전체 유저 데이터 불러오기
//        //fetchAuthRegisterUrl() // 회원가입
//        fetchProjUrl(url: projUrl) // 전체 프로젝트 데이터 불러오기
//        //projDelete(url: projDeleteUrl) // 특정 프로젝트 삭제
//        //fetchPostAll(url: postAllUrl) // 전체 커뮤니티 데이터 불러오기
//        //fetchUserCreateDetail()
//    }
    
//    func fetchUserAllUrl(){
//        AF.request(userAllUrl,
//                   method: .get,
//                   parameters: nil,
//                   encoding: URLEncoding.default,
//                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: [userResponseData].self) { response in
//            //print(response)
//        }
//        .responseJSON(){ response in
//            //print(response)
//        }
//    }
    
    //MARK: - 프로젝트 불러오기, 삭제
    func refreshProj(){
        fetchProjUrl(url: projUrl)
    }
    func fetchProjUrl(url:String){
        print("fetchProjUrl Activated")
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [projectAllDataParcing].self) { response in
            switch response.result {
            case .success(let value):
                self.projectAllDataParcings = value
            case .failure(let error):
                print(error)
            }
        }
    }
    func projDelete(url: String){
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)",
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(url, method: .delete, parameters: nil, headers: tokenHeader).validate(statusCode: 200..<300)
            .responseString() { response in
                print(response)
            }
    }
    
    //MARK: - 로그인
    func authLogin(){
        //print("authLogin Activated")
        
        let param: Parameters = [
            "email" : "\(loginEmail)",
            "password" : "\(loginPassword)"
        ]
        AF.request(authLoginUrl,
                   method: .post,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: nil)
        .validate(statusCode: 200...400)
        .responseString { response in
            let test = response.value?.split(separator: "\"")
            print(response)
            print(test![3])
            if test![3] != "fail"{
                switch response.result {
                case .success(_):
                    print("login success")
                    self.loginisSuccess = true
                    if let data = response.data, let success = String(data: data, encoding: .utf8) {
                        let testText = success.split(separator: "\"")
                        //self.userToken = String(testText[9]) // UserDefaults를 사용하기전 토큰 저장 레거시
                        UserDefaults.standard.set(String(testText[15]), forKey: "userToken")
                        print("OriginUserToken: ", UserDefaults.standard.string(forKey: "userToken"))
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - 커뮤니티 게시글 불러오기
    func refreshPostAll() {
        fetchPostAll(url: self.postAllUrl)
    }
    func fetchPostAll(url: String){
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        
        AF.request(url, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200...400)
            .responseString(){ response in
                print(response)
            }
            .responseDecodable(of: postStruct.self) { response in
                switch response.result {
                case .success(let value):
                    self.postAllDatas = value.data
                case .failure(let error):
                    print("ERROR: fetchPostAll function: ", error)
                }
            }
    }
    
    //MARK: - 이메일 인증
    func emailConfirm(){
        
    }
    
    //MARK: - 회원가입 체크
    func registConfirm(){
        self.registerCheck = false
        self.registerisSuccess = false
        self.registerisFail = false
        
        if name.isEmpty == true {
            print("name is Empty")
            self.registerCheck = true
            self.registerEmpty = "성명"
        }
        else if email.isEmpty == true {
            print("email is Empty")
            self.registerCheck = true
            self.registerEmpty = "이메일"
        }
        else if password.isEmpty == true {
            print("password is Empty")
            self.registerCheck = true
            self.registerEmpty = "비밀번호"
        }
        else if status.isEmpty == true {
            print("status is Empty")
            self.registerCheck = true
            self.registerEmpty = "재학상태"
        }
        else if phonenumber.isEmpty == true {
            print("phonenumber is Empty")
            self.registerCheck = true
            self.registerEmpty = "휴대폰 번호"
        }
        else if nickname.isEmpty == true {
            print("nickname is Empty")
            self.registerCheck = true
            self.registerEmpty = "닉네임"
        }
        
        if registerCheck == false {
            print("registerCheck == false")
            self.registerisSuccess = true
        }
        if registerCheck == true {
            print("registerCheck == true")
            self.registerisFail = true
        }
    }
    
    func authRegister() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateParser = dateFormatter.string(from: wakeUp)
        birth = dateParser
        
        let param: Parameters = [
            "email" : "\(email)",
            "password" : "\(password)",
            "name" : "\(name)",
            "phonenumber" : "\(phonenumber)",
            "nickname" : "\(nickname)",
            "status" : "\(status)",
            "socialtype" : "\(socialtype)",
            "sex" : 0,
            "birth" : "\(birth)",
            "address" : "\(address)",
            "account" : "\(account)",
            "profilelink" : "\(profilelink)"
        ]
        AF.request(authRegisterUrl, method: .post, parameters: param, headers: nil)
            .validate(statusCode: 200...400)
            .responseString{ response in
                switch response.result {
                case .success(_):
                    self.registerisSuccess = true
                case .failure(let error):
                    print("ERROR: registConfirm function: ", error)
                }
            }
    }
    
    //MARK: - 내가 참여한 굿즈
    func refreshJoinProj() {
        fetchUserJoinDetail()
    }
    
    func fetchUserJoinDetail(){
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(userJoinDetailUrl, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200...400)
            .responseDecodable(of: userJoin.self) { response in
                print("decodable",response)
                switch response.result {
                case .success(let value):
                    self.userJoinDetails = value.data
                case .failure(let error):
                    print("ERROR: fetchUserJoinDetail function: ", error)
                }
            }
    }
    
    //MARK: - 내가 생성한 굿즈
    func refreshCreateProj(){
        fetchUserCreateDetail()
    }
    
    func fetchUserCreateDetail(){
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(userCreateDetailUrl, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200...404)
            .responseString { response in
                print("create",response)
            }
            .responseDecodable(of: userCreate.self) { response in
                switch response.result {
                case .success(let value):
                    self.userCreateDetails = value.data
                case .failure(let error):
                    print("ERROR: fetchUserCreateDetail function: ", error)
                }
            }
    }
    
    //MARK: - 프로젝트 참여
    func projJoin(id: String) {
        let url = "\(projJoinIdUrl)+\(id)"
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(url, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200..<300)
            .responseString{ response in
                print("response projJoin: ", response)
            }
            .responseDecodable(of: [projJoin_LeaveId].self) { response in
                switch response.result {
                case .success(let value):
                    self.projJoin_LeaveIds = value
                case .failure(let error):
                    print("ERROR: projJoin function: ", error)
                }
            }
    }
    
    //MARK: - 프로젝트 참여 해제
    func projLeave(id: String) {
        let url = "\(projLeaveIdUrl)+\(id)"
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(url, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [projJoin_LeaveId].self) { response in
                switch response.result {
                case .success(let value):
                    self.projJoin_LeaveIds = value
                case .failure(let error):
                    print("ERROR: projLeave function: ", error)
                }
            }
    }
    
    //MARK: - 유저 정보 불러오기
    func user_Get() {
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)", //UserDefaults에 저장한 토큰 불러오기
            "Accept": "application/json",
            "Content-Type": "application/json" ]
        AF.request(userUrl, method: .get, parameters: nil, headers: tokenHeader)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [userGet].self) { response in
                switch response.result {
                case .success(let value):
                    self.userGets = value
                case .failure(let error):
                    print("ERROR: user_Get function: ", error)
                }
            }
    }
    
    //MARK: - 커뮤니티 게시글 추가 (사진X)
    func postAddWithoutPhoto() {
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data" ]
        
        let param: Parameters = ["userid": 30, "title" : "\(title)", "explained" : "\(explained)"] //dummyData in required
        AF.request(postUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: tokenHeader)
            .responseString() { response in
                print("RESPONSE postAddWithoutPhoto: ",response)
            }
    }
    
    //MARK: - 커뮤니티 게시글 추가 (사진O)
    func postAddWithPhoto() {
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data" ]

        let param: [String: Any] = [
            "userid": 30,
            "title" : "\(title)",
            "explained" : "\(explained)",
            "url" : "null"
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key,value) in param {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if let image = self.photoData.jpegData(compressionQuality: 0.1) {
                MultipartFormData.append(image, withName: "url", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: postUrl, usingThreshold: UInt64.init(),method: .post, headers: tokenHeader)
            .responseString { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS: postAddWithPhoto function", value)
            case .failure(let error):
                print("ERROR: postAddWithPhoto function: ", error)
            }
        }
    }
    
    //MARK: - 커뮤니티 게시글 체크
    func postAddConfirm() {
        self.postAddCheck = true
        self.postAddSuccess = false
        if title.isEmpty == true {
            print("title is Empty")
            self.postAddCheck = false
        }
        else if explained.isEmpty == true {
            print("explained is Empty")
            self.postAddCheck = false
        }
        else if photoData == nil {
            print("photoData is Empty")
            self.postPhotoCheck = false
        }
        if postAddCheck == true {
            postAddSuccess = true
        }
    }
    
    func projPayQr() {
        let tokenHeader: HTTPHeaders = [
            "Authorization": "\(UserDefaults.standard.string(forKey: "userToken")!)",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data" ]

        let param: [String: Any] = [
            "paylink": "\(QRlink)",
            "photo" : "null"
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            for (key,value) in param {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if let image = self.QRPhoto.jpegData(compressionQuality: 0.1) {
                MultipartFormData.append(image, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: projPayQrUrl, usingThreshold: UInt64.init(),method: .post, headers: tokenHeader)
            .responseString { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS: projPayQr function: ", value)
            case .failure(let error):
                print("ERROR: projPayQr function: ", error)
            }
        }

    }
}
