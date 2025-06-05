//
//  LoginScreen.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//
import SwiftUI
import CoreData
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import LocalAuthentication
import UserNotifications

struct LoginScreen: View {
    @EnvironmentObject var session: SessionManager
    @Environment(\.managedObjectContext) var viewContext

    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = ""
    @State private var showRoleSheet = false
    @State private var errorMessage = ""
    @State private var isUnlocked = false
    @State private var isSignedIn = false
    @State private var goToTaskManager = false

    private let appleLoginManager = AppleSignInManager()
    private let RequestNotificationPermission = NotificationModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image("LoginBackgroundImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Login to Task Management App")
                        .font(.title2)
                        .bold()

                    Group{
                        VStack (spacing: 15){
                            CustomTextField(icon: "person.fill", placeHolder: "UserName", text: $userName)
                            CustomTextField(icon: "envelope.fill", placeHolder: "Mail", text: $email)
                            CustomTextField(icon: "lock.fill", placeHolder: "Password", text: $password)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }

                    Button("Select Role") {
                        showRoleSheet = true
                    }
                    .frame(width: 250)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)

                    if !selectedRole.isEmpty {
                        Text("Selected Role: \(selectedRole)")
                            .foregroundColor(.gray)
                    }

                    Button("Login") {
                        guard !userName.isEmpty && !selectedRole.isEmpty else { return }
                        session.login(userName: userName, role: selectedRole, email: email)
                    }
                    .frame(width: 250)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    HStack(spacing: 20) {
                        Button(action: {
                            handleGoogleSignIn()
                        }) {
                            Image("google")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(12)

                        Button(action: {
                            appleLoginManager.startSignInWithAppleFlow()
                        }) {
                            Image("apple")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(12)
                    }

                    Divider().padding()

                    NavigationLink(destination: MainTabView(), isActive: $goToTaskManager) {
                        EmptyView()
                    }

                    if isUnlocked {
                        Button("Go to Task Manager") {
                            goToTaskManager = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
                        .background(Color.green)
                        .cornerRadius(12)
                    } else {
                        Button("Unlock with Face ID") {
                            authenticateWithBiometrics { success in
                                isUnlocked = success
                            }
                        }
                        .frame(width: 250)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showRoleSheet) {
                VStack {
                    Text("Select Role").font(.title2).bold()
                    Button("Manager") {
                        selectedRole = "Manager"
                        showRoleSheet = false
                    }
                    .padding().frame(maxWidth: .infinity).background(Color.blue).foregroundColor(.white).cornerRadius(10)

                    Button("Developer") {
                        selectedRole = "Developer"
                        showRoleSheet = false
                    }
                    .padding().frame(maxWidth: .infinity).background(Color.green).foregroundColor(.white).cornerRadius(10)

                    Spacer()
                }.padding()
            }
            .onAppear {
                authenticateWithBiometrics { success in
                    isUnlocked = success
                }
                RequestNotificationPermission.requestNotificationPermissions()
            }
        }
    }

    // MARK: - Face ID
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock to access tasks") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }

    func scheduleDeadlineNotification(taskTitle: String, deadline: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Deadline for \(taskTitle) is near!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Google Sign-In
    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let result = result,
                  let idToken = result.user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Sign-In failed: \(error.localizedDescription)")
                } else {
                    self.isSignedIn = true
                    print("✅ Google Sign-In Success: \(authResult?.user.email ?? "")")
                }
            }
        }
    }
}
