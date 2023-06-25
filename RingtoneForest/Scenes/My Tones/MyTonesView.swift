//
//  MyTonesView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import SwiftUI

struct MyTonesView: View {
    @State var myTones: [String] = []
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(L10n.myTone)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 30, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(asset: Asset.Assets.icQuestion)
                            .background(
                                Color(asset: Asset.Colors.colorTabBG202329)
                                    .blur(radius: 30)
                                    .brightness(0.7)
                                .frame(width: 36, height: 36)
                                .cornerRadius(11)
                            )
                    }

                    
                }
                .padding(.top, 28)
                .padding(.bottom, 36)
                
                if myTones.isEmpty {
                    Spacer()
                    
                    Image(asset: Asset.Assets.imgNoRingtones)
                        .padding(.bottom, 20)
                    
                    Text(L10n.noRingtone)
                        .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                        .padding(.bottom, 72)
                    
                    FillButtonView(text: L10n.makeNow, width: 182, height: 54, cornerRadius: 15, textSize: 14, textColor: Asset.Colors.colorGreen69BE15, foregroundColor: Asset.Colors.colorGreen69BE15O15) {
                        
                    }
                    
                    Spacer()
                    
                    Spacer()
                        .frame(height: 60)
                    
                    
                } else {
                    EmptyView()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct MyTonesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTonesView()
    }
}

struct MyTonesRowView: View {
    var name: String
    var time: String
    
    @State var isSelected = true
    @State var isPlaying = true
    @State var percentage = 0.5
    
    @State var currentTime = "00:13"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 17) {
                Image(asset: Asset.Assets.icRingtoneGreen)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 16, weight: .medium))
                    
                    Text(time)
                        .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                    
                }
                
                Spacer()
                
                Image(asset: isPlaying ? Asset.Assets.icPauseWhite : Asset.Assets.icPlayWhite)
            }
            .padding(.bottom, 15)
            
            if isSelected {
                VStack {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.1))
                            .frame(height: 1)
                        
                        if isPlaying {
                            Rectangle()
                                .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                                .frame(height: 2)
                                .frame(width: (UIScreen.main.bounds.width - 32) * percentage)
                            
                            Circle()
                                .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                                .frame(width: 9, height: 9)
                        }
                    }
                    .padding(.bottom, 8)
                    
                        HStack {
                            Text(currentTime)
                                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                            
                            Spacer()
                            
                            Text(time)
                                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
                        }
                    
                    HStack(spacing: 25) {
                        ButtonIconWithTextView(icon: Asset.Assets.icSetRingtone, text: L10n.setRingtone) {
                            
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icCutter, text: L10n.cutter) {
                            
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icRename, text: L10n.rename) {
                            
                        }
                        
                        ButtonIconWithTextView(icon: Asset.Assets.icDelete, text: L10n.delete) {
                            
                        }
                    }
                }
            }
            
            
            
        }
    }
}

struct MyTonesRowView_Previews: PreviewProvider {
    static var previews: some View {
        MyTonesRowView(name: "Shape of you", time: "00:30")
    }
}

struct ButtonIconWithTextView: View {
    var icon: ImageAsset
    var text: String
    var onTap: () -> ()
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 2) {
                Image(asset: icon)
                
                Text(text)
                    .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
            }
            .frame(width: 72, height: 72)
        }

        
    }
}

struct ButtonIconWithTextView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonIconWithTextView(icon: Asset.Assets.icSetRingtone, text: L10n.setRingtone) {
            
        }
    }
}
