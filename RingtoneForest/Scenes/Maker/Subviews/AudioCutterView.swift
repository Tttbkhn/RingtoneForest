//
//  AudioCutterView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 25/06/2023.
//

import SwiftUI

struct AudioCutterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var timeStart = "00:00"
    @State var duration = "00:00"
    @State var timeEnd = "00:00"
    @State var percentage = 0.5
    @State var isFadeIn = false
    @State var isFadeOut = false
    
    @State var isPlaying = false
    
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
                    
                    
                    Text(L10n.audioCutter)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                Text(L10n.maxLength)
                    .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .regular))
                    .padding(.top, 5)
                    .padding(.bottom, 43)
                
                HStack {
                    timeView(label: L10n.start, time: timeStart, alignment: .leading)
                    
                    Spacer()
                    
                    timeView(label: L10n.duration, time: duration, alignment: .center)
                    
                    Spacer()
                    
                    timeView(label: L10n.end, time: timeEnd, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(.green)
                    .frame(height: 217)
                    .padding(.top, 17)
                    .padding(.bottom, 35)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(asset: Asset.Colors.colorGreen69BE15).opacity(0.3))
                        .frame(height: 1)
                        
                    Rectangle()
                        .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                        .frame(height: 3)
                        .frame(width: (UIScreen.main.bounds.width - 32) * percentage)
                    
                        ZStack {
                            Rectangle()
                                .fill(Color(asset: Asset.Colors.colorGreen69BE15))
                                .frame(width: 3, height: 20)
                                
                        }
                        .offset(x: (UIScreen.main.bounds.width - 32) * percentage)
                    .contentShape(Rectangle())
                    

                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
                
                HStack {
                    HStack(spacing: 10) {
                        Text(L10n.fadeIn)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .medium))
                        
                        Toggle("", isOn: $isFadeIn)
                    }
                    
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Toggle("", isOn: $isFadeOut)
                        
                        Text(L10n.fadeOut)
                            .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .medium))
                    }
                    
                }
                .padding(.horizontal, 16)
                
                
                
                Spacer()
                
                Button {
                    isPlaying.toggle()
                } label: {
                    Image(asset: isPlaying ? Asset.Assets.icPauseRecord : Asset.Assets.icPlayRecord)
                        .padding(.bottom, 32)
                }

                
                
                NoFillButtonView(text: L10n.saveRingtone, width: 238, height: 60, cornerRadius: 14, textSize: 17, color: Asset.Colors.colorGreen69BE15) {
                    
                }
                .padding(.bottom, 10)
                
                
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func timeView(label: String, time: String, alignment: HorizontalAlignment) -> some View {
        
        VStack(alignment: alignment, spacing: 4) {
            Text(label)
                .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 12, weight: .medium))
            
            Text(time)
                .modifier(TextModifier(color: Asset.Colors.colorGrayCFCFCF, size: 12, weight: .medium))
        }
    }
}

struct AudioCutterView_Previews: PreviewProvider {
    static var previews: some View {
        AudioCutterView()
    }
}
