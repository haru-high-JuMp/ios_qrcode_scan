//
//  InspectionList.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/04/20.
//

import SwiftUI
import MessageUI
import CoreData

struct InspectionList: View {
    //メール関係
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    //メアド情報
    @ObservedObject var initi = Init()
    //QRからのリスト
    @State private var isShowingScanner = false
    @State private var isShowingAdder = false
    //core data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductData.product, ascending: true)],
            animation: .default)
    private var products: FetchedResults<ProductData>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InspectionData.inspection, ascending: true)], animation: .default)
    private var inspects: FetchedResults<InspectionData>
    //リスト
    @State var product_lists:[NSString] = []
    
    var adderDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List {
                    Section(header: Text("点検済")){
                        ForEach(products, id: \.self) { product in
                            Text("\(product.product!)")
                        }.onDelete(perform: deleteProduct)
                    }
                    Section(header: Text("点検リスト")){
                        ForEach(inspects, id: \.self) { inspect in
                            Text("\(inspect.inspection!)")
                        }.onDelete(perform: deleteInspection)
                    }
                }
                HStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            self.isShowingAdder = true
                        }) {
                            Image(systemName: "plus.viewfinder")
                                .frame(width: 60, height: 60)
                                .imageScale(.large)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .cornerRadius(30.0)
                                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        .sheet(isPresented: $isShowingAdder) {
                            CameraAdd()
                        }
                        Button(action: {
                            self.isShowingScanner = true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .frame(width: 60, height: 60)
                                .imageScale(.large)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .cornerRadius(30.0)
                                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        .sheet(isPresented: $isShowingScanner) {
                            CameraView()
                        }
                        /*
                        Button(action: getProduct){
                            Image(systemName: "doc.text")
                                .frame(width: 60, height: 60)
                                .imageScale(.large)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .cornerRadius(30.0)
                                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        */
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                                self.isShowingMailView.toggle()
                                product_lists = getProduct()
                                print(product_lists)
                            } else {
                                print("Can't send emails from this device")
                            }
                            if result != nil {
                                print("Result: \(String(describing: result))")
                            }
                        }){
                            Image(systemName: "envelope")
                                .frame(width: 60, height: 60)
                                .imageScale(.large)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .cornerRadius(30.0)
                                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: $result) { composer in
                                composer.setSubject("Equipment management")
                                composer.setToRecipients([initi.useremail])
                                composer.setCcRecipients([initi.GLemail, initi.TL1email, initi.TL2email])
                                composer.setMessageBody("Inspection result\n" + product_lists.debugDescription , isHTML: false)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("点検リスト", displayMode: .inline)
        }
    }
    
    func present(_ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil){
    }
    //product
    private func deleteProduct(offsets: IndexSet){
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            
            do{
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Could not save. \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //inspecton
    private func deleteInspection(offsets: IndexSet){
        withAnimation {
            offsets.map { inspects[$0] }.forEach(viewContext.delete)
            
            do{
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Could not save. \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //データの取得
    private func getProduct() -> [NSString]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductData")
        
        do{
            print("Success")
            let productResults = try viewContext.fetch(fetchRequest)
            
            var Result_lists:[NSString] = []
            
            for MyData in productResults{
                Result_lists.append(MyData.value(forKey: "product") as! NSString)
            }
            let product_lists = Result_lists
            //print(product_lists)
            return product_lists
        }catch {
            let nsError = error as NSError
            fatalError( "\(nsError), \(nsError.userInfo)")
        }
    }

}


struct List_Previews: PreviewProvider {
    static var previews: some View {
        InspectionList()
    }
}
