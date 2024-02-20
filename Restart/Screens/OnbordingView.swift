//
//  OnbordingView.swift
//  Restart
//
//  Created by Ricardo Sousa on 01/02/2024.
//

import SwiftUI

struct OnbordingView: View {
    // MARK: -PROPERTY
    @AppStorage("onbording") var isOnboardingViewActive: Bool = true
    
    @State private var ButtonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var ButtonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTilte: String = "Share"
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    // MARK: - BODY
    
    var body: some View{
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing:20){
                // MARK: - HEADER
                
                    Spacer()
                VStack(spacing:0){
                    Text(textTilte)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTilte)
                    
                    Text("""
                    It´s not how much we give but how much love we put into giving.
                    """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,10)
                } //: HEADER
                .opacity(isAnimating ? 1: 0)
                .offset(y: isAnimating ? 0: -40)
                .animation(.easeOut(duration: 1),value: isAnimating)
                
                // MARK: - CENTER
                
                ZStack{
                    
                    CircleGroupView(ShapeColor: .white,ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1) // oposto
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1: 0)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y:0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(DragGesture()
                            .onChanged{gesture in
                                if abs(imageOffset.width) <= 150{
                                    imageOffset = gesture.translation
                                    // fazer com que imagem aquando do movimento desapareça
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOpacity = 0
                                        textTilte = "Give."
                                    }
                                }
                            }
                            .onEnded{ _ in
                                imageOffset = .zero
                                withAnimation(.linear(duration: 0.5)){
                                    indicatorOpacity = 1
                                    textTilte = "Share."
                                }
                                
                                }
                        )//: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }//: CENTER
                .overlay(
                Image(systemName: "arrow.left.and.right.circle")
                .font(.system(size: 44,weight: .ultraLight))
                .foregroundColor(.white)
                .offset(y:20)
                .opacity(isAnimating ? 1: 0)
                .animation(.easeInOut(duration: 2), value: isAnimating)
                .opacity(indicatorOpacity)
                ,alignment: .bottom
                
                )
                Spacer()
               
                
                
                // MARK: FOOTER
                ZStack{
                    // 1. BACKGROUND (STATIC)
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    // 2. CALL-TO-ACTION (STATIC)
                    Text("Get Started")
                        .font(.system(.title3,design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x:20)
                    // 3. CAPSULE (DYNAMIC WIDHT)
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: ButtonOffset + 80)
                        Spacer()
                        
                    }
                    
                    // 4. CIRCLE (DRAGGABLE)
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName:"chevron.right.2")
                                .font(.system(size: 24,weight: .bold))

                            
                        }.foregroundColor(.white)
                            .frame(width: 80, height: 80, alignment: .center)
                            .offset(x: ButtonOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged{gesture in
                                        if gesture.translation.width > 0 && ButtonOffset <= ButtonWidth - 80 {
                                            ButtonOffset = gesture.translation.width}
                                    }
                                    .onEnded {_ in
                                        withAnimation(Animation.easeOut(duration: 0.4)){
                                            if ButtonOffset > ButtonWidth / 2 {
                                                hapticFeedback.notificationOccurred(.success)
                                                playSound(sound: "chimeup", type: "mp3")
                                                ButtonOffset = ButtonWidth - 80
                                                isOnboardingViewActive = false
                                            }else {
                                                ButtonOffset = 0
                                                hapticFeedback.notificationOccurred(.warning)
                                            }
                                        }
                                    ButtonOffset = 0
                                    }
                            )//: GESTURE
                        Spacer()
                    }//: HSTACK
                    
                }//:FOOTER
                .frame(width: ButtonWidth,height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1: 0)
                .offset(y: isAnimating ? 0: 40)
                .animation(.easeOut(duration: 1),value: isAnimating)
                
                
                
            }//: VSTACK
        } //: ZSTACK
        .onAppear(perform: {
            isAnimating = true
        })
        // color skin on your view
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
        
}

#Preview {
    OnbordingView()
}
