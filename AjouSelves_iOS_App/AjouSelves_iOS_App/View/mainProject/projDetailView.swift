//
//  projDetailView.swift
//  AjouSelves_iOS_App
//
//  Created by Minhyun Cho on 2022/05/13.
//

import Foundation
import SwiftUI

struct projDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var productDataVM = productdataViewModel()
    @State var fundingClicked: Bool = false
    @State var shareClicked: Bool = false
    
    var prdData: projectAllDataParcing
    
    init(_ prdData : projectAllDataParcing) {
        self.prdData = prdData
    }
    
    var body: some View {
        ScrollView{
            Spacer(minLength: 100)
            VStack{
                ScrollView(.horizontal) {
                    projImgView(imageUrl: prdData.profileImgUrl)
                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                VStack(alignment: .leading){
                    Group{
                        Group{
                            HStack{
                                Text("제목")
                                    .font(.system(size: 15))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color.gray)
                                Text("*")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 20))
                            }
                            Text("\(prdData.description_title)")
                                .font(.system(size: 25))
                                .bold()
                                .lineLimit(4)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Divider()
                            HStack{
                                Text("가격")
                                    .font(.system(size: 15))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color.gray)
                                Text("*")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 20))
                            }
                            Text("\(prdData.description_amount)원")
                                .font(.system(size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Spacer(minLength: 20)
                            HStack{
                                Text("목표 펀딩 인원")
                                    .font(.system(size: 15))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color.gray)
                                Text("*")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 20))
                            }
                            Text("\(prdData.description_minnum)명")
                                .font(.system(size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                        Spacer(minLength: 20)
                        HStack{
                            Text("현재 펀딩 인원")
                                .font(.system(size: 15))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.red)
                            Text("*")
                                .foregroundColor(Color.red)
                                .font(.system(size: 15))
                        }
                        HStack{
                            Text("\(prdData.description_curnum)명")
                                .font(.system(size: 20))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text("\(prdData.cal_joinPer)% 달성!")
                                .font(.system(size: 25))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.red)
                                .font(.system(size: 20))
                        }
                        Spacer(minLength: 20)
                    }
                    Group{
                        HStack{
                            Text("카테고리")
                                .font(.system(size: 15))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.gray)
                            Text("*")
                                .foregroundColor(Color.red)
                                .font(.system(size: 20))
                        }
                        Text("\(prdData.description_category)")
                            .font(.system(size: 20))
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        Spacer(minLength: 20)
                        HStack{
                            Text("굿즈 상세 설명")
                                .font(.system(size: 15))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.gray)
                            Text("*")
                                .foregroundColor(Color.red)
                                .font(.system(size: 20))
                        }
                        Text("\(prdData.description_explained)")
                            .font(.system(size: 15))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1000)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 350, height: .infinity)
                        Spacer()
                        Divider()
                        HStack{
                            Button(action: {
                                self.fundingClicked = true
                                productDataVM.projJoin(id: prdData.description_projid)
                            }, label: {
                                Text("펀딩하기👍")
                            }).alert(isPresented: $fundingClicked, content: {
                                Alert(title: Text("축하합니다🎉"), message: Text("펀딩에 성공하셨습니다!"), dismissButton: .default(Text("확인"), action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }))
                            })
                            Spacer()
                            Button(action: {
                                self.shareClicked = true
                            }, label: {
                                Label("공유", systemImage: "square.and.arrow.up")
                            }).alert(isPresented: $shareClicked, content: {
                                Alert(title: Text("죄송합니다"), message: Text("추가될 예정입니다."), dismissButton: .default(Text("참아보기"), action: {
                                    //self.presentationMode.wrappedValue.dismiss()
                                }))
                            })
                        }
                        Spacer(minLength: 50)
                    }
                }.frame(width: 350, height: .infinity, alignment: .leading).padding()
            }
        }
        
        .ignoresSafeArea()
        .setTabBarVisibility(isHidden: true) // 프로젝트 디테일 뷰로 들어가면 TabBar활성화
    }
}

struct projDetailView_Previews: PreviewProvider {
    static var previews: some View {
        projDetailView(projectAllDataParcing.getDummy())
    }
}
