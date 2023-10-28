//
//  PremiumPlanView.swift
//  RingtoneForest
//
//  Created by Thu Trương on 26/06/2023.
//

import SwiftUI
import SwiftyStoreKit

struct PremiumPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var priceWeek = ""
    @State var priceMonth = ""
    @State var priceYear = ""
    @State var showPandT: WebType? = nil
    @State var daySelected = false
    @State var monthSelected = false
    @State var yearSelected = false
    @State var currentPremium: EPremium = .month
    @State var showSuccessAlert = false
    @State var showErrorAlert = false
    @State var currentTrial = ""
    @State var showLoading = false
    
    var body: some View {
        ZStack {
            Image(asset: Asset.Assets.imgBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(asset: Asset.Assets.icClose)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                HStack(spacing: 18) {
                    Text(L10n.ringtonesPro)
                        .modifier(TextModifier(color: Asset.Colors.colorGreen69BE15, size: 35, weight: .bold))
                    
                    Image(asset: Asset.Assets.imgPro)
                }
                .padding(.bottom, 54)
                
                VStack(alignment: .leading, spacing: 15) {
                    PremiumTextRowView(text: L10n.unlimited1)
                    PremiumTextRowView(text: L10n.unlimited2)
                    PremiumTextRowView(text: L10n.unlimited3)
                    PremiumTextRowView(text: L10n.removeAds)
                }
                
                Spacer()
                
                HStack {
                    PremiumBoxView(isSelected: $daySelected, text: L10n.oneWeek, priceText: priceWeek.isEmpty ? "Loading" : priceWeek)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            daySelected = true
                            monthSelected = false
                            yearSelected = false
                            currentPremium = .week
                        }
                    PremiumBoxView(isSelected: $monthSelected, text: L10n.oneMonth, priceText: priceMonth.isEmpty ? "Loading" : priceMonth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            daySelected = false
                            monthSelected = true
                            yearSelected = false
                            currentPremium = .month
                        }
                    PremiumBoxView(isSelected: $yearSelected, text: L10n.oneYear, priceText: priceYear.isEmpty ? "Loading" : priceYear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            daySelected = false
                            monthSelected = false
                            yearSelected = true
                            currentPremium = .year
                        }
                }
                .padding(.bottom, 40)
                
                HStack(spacing: 0) {
                    Text(L10n.trial)
                    
                    Text(currentPremium == .year ? " \(priceYear)/year" : (currentPremium == .month ? " \(priceMonth)/month" : " \(priceWeek)/week"))
                }
                .modifier(TextModifier(color: Asset.Colors.colorWhite50, size: 14, weight: .medium))
                .padding(.bottom, 30)
                
                FillButtonView(text: L10n.try, width: UIScreen.main.bounds.width - 32, height: 60, cornerRadius: 18, textSize: 17, textColor: Asset.Colors.colorWhite, foregroundColor: Asset.Colors.colorGreen69BE15) {
                    purchase(package: Constant.packages[currentPremium.numOfPackage])
                }
                .padding(.bottom, 45)
                
                ZStack {
                    Button {
                        restorePurchase()
                    } label: {
                        Text(L10n.restore)
                            .underline()
                            .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                            .contentShape(Rectangle())
                    }
                    
                    
                    
                    HStack {
                        Button {
                            showPandT = .privacy
                        } label: {
                            Text(L10n.privacyPolicy)
                                .underline()
                                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        Button {
                            showPandT = .term
                        } label: {
                            Text(L10n.terms)
                                .underline()
                                .modifier(TextModifier(color: Asset.Colors.colorWhite, size: 14, weight: .regular))
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                Text(L10n.warning)
                    .multilineTextAlignment(.center)
                    .modifier(TextModifier(color: Asset.Colors.colorWhite40, size: 10, weight: .regular))
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $showPandT) { content in
            WebView(type: content)
        }
        .alert(isPresented: $showSuccessAlert, content: {
            Alert(title: Text("You're all set"), message: Text("Your purchase was successful."))
        })
        .alert(isPresented: $showErrorAlert, content: {
            Alert(title: Text("Oopps"), message: Text("Something went wrong"))
        })
        .onAppear() {
            fetchPrice()
        }
    }
    
    func purchase(package: Package) {
        showLoading = true
        SwiftyStoreKit.purchaseProduct(package.productID, quantity: 1, atomically: true) { [self] result in
            showLoading = false
            
            switch result {
            case .success(_):
                ProductStoreCacheCD.shared.saveCachePurchase(package: package, premiumType: currentPremium)
                showSuccessAlert = true
                
                //                        if fromHome {
                //                            InitialState.shared.goToHome = true
                //                        }
            case .error(_), .deferred(purchase: _):
                UserDefaults.standard.setValue(false, forKey: Constant.isPurchased)
                showErrorAlert = true
            }
        }
    }
    
    func restorePurchase() {
        showLoading = true
        
        SwiftyStoreKit.restorePurchases { [self] result in
            showLoading = false
            if result.restoredPurchases.count > 0 {
                do {
                    let productID = result.restoredPurchases.map { $0.productId }
                    let dateExpired = result.restoredPurchases.map { $0.originalPurchaseDate }
                    if productID.count > 0 {
                        if let package = Constant.packages.first(where: { package in
                            package.productID == productID.first!
                        }) {
                            ProductStoreCacheCD.shared.restorePurchase(package: package, dateExpired: dateExpired.first!)
                            
                            showSuccessAlert = true
                            
                            //                                    if fromHome {
                            //                                        InitialState.shared.goToHome = true
                            //                                    }
                        }
                    } else {
                        showErrorAlert = true
                    }
                }
            }
        }
    }
    
    func fetchPrice() {
        SwiftyStoreKit.retrieveProductsInfo([Constant.packages[0].productID, Constant.packages[1].productID, Constant.packages[2].productID]) { result in
            result.retrievedProducts.forEach { [self] product in
                switch product.productIdentifier {
                case Constant.packages[0].productID:
                    priceWeek = product.localizedPrice ?? ""
                case Constant.packages[1].productID:
                    priceMonth = product.localizedPrice ?? ""
                case Constant.packages[2].productID:
                    priceYear = product.localizedPrice ?? ""
                default:
                    break
                }
            }
        }
    }
}

struct PremiumPlanView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumPlanView()
    }
}

struct PremiumTextRowView: View {
    var text: String
    var body: some View {
        HStack {
            Image(asset: Asset.Assets.icSmallCrown)
            
            Text(text)
                .modifier(TextModifier(color: Asset.Colors.colorGrayBCBCBC, size: 14, weight: .medium))
        }
    }
}

struct PremiumTextRowView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumTextRowView(text: L10n.unlimited1)
    }
}

struct PremiumBoxView: View {
    @Binding var isSelected: Bool
    var text: String
    var priceText: String
    
    var body: some View {
        VStack(spacing: 13) {
            Text(text)
                .modifier(TextModifier(color: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGrayC2C2C2, size: 11, weight: .regular))
            
            Text(priceText)
                .modifier(TextModifier(color: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGrayC2C2C2, size: 18, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(RoundedRectangle(cornerRadius: 17)
            .stroke(Color(asset: Asset.Colors.colorGreen69BE15), lineWidth: isSelected ? 2 : 0)
            .background(Color(asset: isSelected ? Asset.Colors.colorGreen69BE15 : Asset.Colors.colorGray83868A).opacity(0.25)))
        .cornerRadius(17)
    }
}

//struct PremiumBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        PremiumBoxView(text: L10n.oneWeek, priceText: "$ 2.9")
//    }
//}
