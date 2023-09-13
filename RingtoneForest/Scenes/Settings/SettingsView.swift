//
//  SettingsView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI

struct SettingsView: View {
    @State var isSharePresented: Bool = false
    @State var urlToShare: URL = URL(string: "https://apps.apple.com/us/app/id\(Constant.appID)")!
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(L10n.setting)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 30, weight: .bold))
                    
                    Spacer()
                }
                .padding(.top, 28)
                .padding(.bottom, 36)
                
                NavigationLink {
                    PremiumPlanView()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(L10n.joinPremium)
                                .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 21, weight: .bold))
                            
                            Text(L10n.enjoyFeatures)
                                .modifier(TextModifier(color: Asset.Colors.colorBlack, size: 14, weight: .regular))
                        }
                        .padding(.leading, 17)
                        
                        Spacer()
                        
                        Image(asset: Asset.Assets.icPremiumCrown)
                            .padding(.trailing, 29)
                    }
                    .frame(height: 89)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 5).foregroundColor(Color.white.opacity(0.33)).background(LinearGradient(colors: [Color(asset: Asset.Colors.colorGreen69BE15), Color(asset: Asset.Colors.colorYellowFFEE0A)], startPoint: .bottomLeading, endPoint: .topTrailing)).cornerRadius(20))
                    .padding(.bottom, 24)
                }
                
                Text(L10n.tutorials)
                    .modifier(TextModifier(color: Asset.Colors.colorGrayCDD2D8, size: 15, weight: .regular))
                    .padding(.bottom, 14)
                
                NavigationLink(destination: TutorialView()) {
                    SettingsRowNoTapView(icon: Asset.Assets.icInstallRingtone, text: L10n.installRingtone)
                        .padding(.bottom, 28)
                }
                
                Text(L10n.about)
                    .modifier(TextModifier(color: Asset.Colors.colorGrayCDD2D8, size: 15, weight: .regular))
                    .padding(.bottom, 14)
                
                VStack(spacing: 12) {
                    SettingsRowView(icon: Asset.Assets.icContactUs, text: L10n.contactUs) {
                        
                    }
                    
                    Button {
                        isSharePresented = true
                    } label: {
                        SettingsRowNoTapView(icon: Asset.Assets.icShare, text: L10n.shareApp)
                    }
                    .background(ActivityViewController(activityItems: $urlToShare, isPresented: $isSharePresented))
                    
                    SettingsRowView(icon: Asset.Assets.icPrivacy, text: L10n.privacyPolicy) {
                        
                    }
                    
                    SettingsRowView(icon: Asset.Assets.icTerms, text: L10n.terms) {
                        
                    }
                }
                
                Spacer()
                
                
            }
            .padding(.horizontal, 16)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingsRowNoTapView: View {
    var icon: ImageAsset
    var text: String
    
    var body: some View {
        HStack(spacing: 24) {
            Image(asset: icon)
                .padding(.leading, 20)
            
            Text(text)
                .modifier(TextModifier(color: Asset.Colors.colorGrayCDD2D8, size: 15, weight: .regular))
            
            Spacer()
        }
        .frame(height: 60)
        .background(Color(asset: Asset.Colors.colorTabBG202329))
        .cornerRadius(20)
    }
}

struct SettingsRowView: View {
    var icon: ImageAsset
    var text: String
    
    var onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 24) {
                Image(asset: icon)
                    .padding(.leading, 20)
                
                Text(text)
                    .modifier(TextModifier(color: Asset.Colors.colorGrayCDD2D8, size: 15, weight: .regular))
                
                Spacer()
            }
            .frame(height: 60)
            .background(Color(asset: Asset.Colors.colorTabBG202329))
            .cornerRadius(20)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(icon: Asset.Assets.icInstallRingtone, text: L10n.installRingtone) {
            
        }
    }
}
