//
//  RecordAudioView.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/23/23.
//

import SwiftUI

struct RecordAudioView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var currentTime = "00:00:00"
    @State var isRecording = true
    @State var doneRecording = true
    
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
                    
                    
                    Text(L10n.recordAudio)
                        .modifier(TextModifier(color: Asset.Colors.colorWhite90, size: 20, weight: .bold))
                }
                .frame(height: 55)
                
                Text(currentTime)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 30, weight: .regular))
                    .padding(.top, 100)
                
                Rectangle()
                    .fill(.blue)
                    .frame(height: 150)
                    .padding(.top, 76.5)
                
                Spacer()
                
                if !doneRecording {
                    Button {
                        isRecording.toggle()
                    } label: {
                        Image(asset: isRecording ? Asset.Assets.icStopRecord : Asset.Assets.icStartRecord)
                    }
                } else {
                    HStack {
                        NoFillButtonView(text: L10n.delete, width: 100, height: 46, cornerRadius: 23, textSize: 14, color: Asset.Colors.colorGray83868A) {
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            doneRecording.toggle()
                        } label: {
                            Image(asset: Asset.Assets.icPlayRecord)
                        }
                        
                        Spacer()
                        
                        NoFillButtonView(text: L10n.continue, width: 100, height: 46, cornerRadius: 23, textSize: 14, color: Asset.Colors.colorGreen69BE15) {
                            
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                
                Text(!isRecording ? L10n.tapToRecord : "")
                    .modifier(TextModifier(color: Asset.Colors.colorGray83868A, size: 14, weight: .regular))
                    .padding(.top, 19)
                    .padding(.bottom, 45)
                
                
            }
            .frame(maxWidth: .infinity)
        }
        
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}


