//
//  ContentView.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/04/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var initi = Init()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductData.product, ascending: true)],
            animation: .default)
    private var products: FetchedResults<ProductData>
    
    var body: some View {
            TabView{
                UserInit()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("home")
                    }
                InspectionList()
                    //CameraView()
                    .tabItem {
                        Image(systemName: "list.bullet.below.rectangle")
                        Text("リスト")
                    }
            }
            .environmentObject(initi)
            .onReceive(NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification), perform: { _ in
                resetAllCoredata()
                //print("app was terminated.")
            })
        }
    
    
    func resetAllCoredata(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try viewContext.fetch(fetchRequest)
            for manageObject in results{
                //print("flag")
                let manageObjectData:NSManagedObject = manageObject as! NSManagedObject
                viewContext.delete(manageObjectData)
            }
            //print("Success deleat")
        } catch _ as NSError{
            print("Error Detele all data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
