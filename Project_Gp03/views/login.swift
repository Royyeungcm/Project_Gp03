import SwiftUI

var isLogined = UserDefaults.standard.bool(forKey: "KEY_LOGIN")

struct LoginView: View {
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var name: String = ""
    @State private var isRemember = false
    @State private var isSecure = false
    @State private var errMessage = ""
    @State private var gotoNextView = isLogined
    @State private var linkselection : Int? = isLogined ? 1 : nil
    @State private var isError = false
    
    @EnvironmentObject var rid: RootId
    
    
    private func validation() -> Bool{
        let db = DataDB.shared
        if(self.email.isEmpty || self.password.isEmpty){
            self.errMessage = "Missing Email or Password"
            return false
        }
        if(self.email.range(of: "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) == nil){
            self.errMessage = "Invalid Email"
            return false
        }
        if (db.user.contains{e in
            if (e.email == self.email && e.password == self.password){
                self.name = e.name
                return true
            }else{
                return false
            }
        }){
            return true
        }else{
            errMessage = "Email or Password incorrect"
            return false
        }
    }
    
    var body: some View {
        NavigationView{
            
            ZStack{
                NavigationLink(destination: ActivityList(), tag:1, selection: self.$linkselection){}
                
                Image("lionrock-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                VStack(){

                    Text("Lion Tourism")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .bold()
                        .padding([.top, .bottom], 80)
                        .shadow(radius: 10, x: 20, y: 10)
                        .offset(y:-20)
                    Spacer().frame(height: 20)
                    VStack(alignment: .center, spacing: 15){
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .opacity(0.7)
                            .frame(width: 300, height: 50)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        ZStack{
                            Group{
                                if isSecure{
                                    TextField("Password", text: self.$password)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .opacity(0.7)
                                        .frame(width: 300, height: 50)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                }else{
                                    SecureField("Password", text: self.$password)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .opacity(0.7)
                                        .frame(width: 300, height: 50)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                }
                            }
                            Button(action: {
                                isSecure.toggle()
                            }){
                                Image(systemName: self.isSecure ? "eye.slash" : "eye")
                                    .tint(.gray)
                            }.padding(.leading, 220)
                        }
                        
                    }.padding(.bottom, 20)
                    Toggle(isOn: self.$isRemember){
                        Text("Remember Me")
                    }.toggleStyle(Checkboxstyle())
                        .padding(.bottom, 20)
                    Button(action: {
                        print("username: \(self.email)")
                        print("password: \(self.password)")
                        print("isSecure: \(String(self.isSecure))")
                        print("isRemeber: \(String(self.isRemember))")
                        if(validation()){
                            print("pass")
                            if(isRemember){
                                UserDefaults.standard.set(true, forKey: "KEY_LOGIN")
                                UserDefaults.standard.set(["userEmail":"\(self.email)", "name":"\(self.name)"], forKey: "KEY_CURRUSER")
                                self.linkselection = 1
                            }else{
                                UserDefaults.standard.set(false, forKey: "KEY_LOGIN")
                                UserDefaults.standard.set(["userEmail":"\(self.email)", "name":"\(self.name)"], forKey: "KEY_CURRUSER")
                                let dd:[String:Activity] = ["\(self.name)": DataDB.shared.activities[0]]
                                do{
                                    let encodeAct = try JSONEncoder().encode(dd)
                                    UserDefaults.standard.set(encodeAct, forKey: "KEY_DB")
                                }catch{
                                    print("error")
                                }
                                self.linkselection = 1
                            }
                            
                        }else{
                            print(errMessage)
                            self.isError = true
                        }
                    }){
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100, height: 30)
                            .background(.green)
                            .cornerRadius(15)
                    }.alert(isPresented: self.$isError){
                        Alert(title: Text("Error"), message: Text("\(self.errMessage)"), dismissButton: .default(Text("Try Again")){

                        })
                    }
                    Spacer()
                    
                }
                
            }
            .navigationTitle(Text("Login"))
            .navigationBarTitleDisplayMode(.inline)
            .background(.white)
        }
        
    }
}

struct login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
