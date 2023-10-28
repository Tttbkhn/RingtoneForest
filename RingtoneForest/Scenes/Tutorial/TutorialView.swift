//
//  TutorialView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 23/07/2023.
//

import SwiftUI

struct Tutorial: Identifiable {
    let id: Int
    let text: String
    let image: ImageAsset
}

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var selection: Int = 0
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(asset: Asset.Assets.icBack)
                                .padding(.leading, 16)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                    }
                    
                    
                    Text(L10n.installRingtone)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                .padding(.bottom, 25)
                
                let screenWidthWithPadding = UIScreen.main.bounds.width - 95
                
                HStack(spacing: 0) {
                    ForEach(Constant.tutorials) { page in
                        Rectangle()
                            .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(selection < page.id ? 0.15 : 1))
                            .frame(width: screenWidthWithPadding / 6, height: 1)
                    }
                }
                .padding(.bottom, 60)
                
                TabView(selection: $selection) {
                    ForEach(Constant.tutorials) { page in
                        switch page.id {
                        case 0:
                            VStack(spacing: 0) {
                                Image(asset: page.image)
                                    .padding(.bottom, 28)
                                
                                Text(L10n.howToInstall)
                                    .frame(width: 204)
                                    .multilineTextAlignment(.center)
                                    .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 16, weight: .bold))
                                    .padding(.bottom, 58)
                                
                                HStack(spacing: 0) {
                                    Text(L10n.noteGarage1)
                                        .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .regular))
                                    Text(L10n.garageBand)
                                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 14, weight: .bold))
                                }
                                
                                Text(L10n.noteGarage2)
                                    .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .regular))
                            }
                        case 1:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
//                                    .frame(height: 217)
                                
                                HStack(spacing:  0) {
                                    Text(page.text)
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    Text(L10n.garageBand)
                                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .bold))
                                }
                            }
                        case 2:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                VStack(spacing: 3) {
                                    Text(page.text)
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    
                                    HStack(spacing: 0) {
                                        Text("Swipe up and click ")
                                            .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                        Text("Share")
                                            .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
                                        Text(" Button")
                                            .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    }
                                }
                            }
                        case 3:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                HStack(spacing: 0) {
                                    Text("3. Click ")
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    Text("Ringtone")
                                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
                                    Text(" button")
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                }
                            }
                        case 4:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                HStack(spacing: 0) {
                                    Text("4. Click ")
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    Text("Export")
                                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
                                    Text(" button")
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                }
                            }
                        case 5:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                HStack(spacing: 0) {
                                    Text("5. Click ")
                                        .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                                    Text("Use sound as...")
                                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .regular))
                                }
                            }
                        case 6:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                Text(L10n.step6)
                                    .modifier(TextModifier(color: Asset.Colors.colorGray7A7A7A, size: 16, weight: .regular))
                            }
                        default:
                            VStack(spacing: 93) {
                                Image(asset: page.image)
                                    .resizable()
                                    .frame(height: 217)
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(alignment: .top)
                
                Spacer()
                    .frame(height: 160)
                
                NoFillButtonView(text: selection == 6 ? L10n.done : L10n.next, width: 214, height: 50, cornerRadius: 17, textSize: 16, color: Asset.Colors.colorGreen69BE15, lineWidth: 1) {
                    if selection == 6 {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        selection = selection + 1
                    }
                }
                .padding(.bottom, 50)
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .previewDevice(PreviewDevice(stringLiteral: "iPhone 14"))
    }
}
