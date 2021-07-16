//
//  ViewControllAdd.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/05/19.
//

//
//  ViewController.swift
//  CodeScan
//
//  Created by Haruki Mori on 2021/04/20.
//

import SwiftUI
import UIKit
import AVFoundation
import CoreData

class ViewControllAdder: UIViewController{

    let myQRCodeReader = MyQRCodeReader()
    //@IBOutlet var messageLabel:UILabel!

    override func viewDidLoad() {
        //view.bringSubviewToFront(messageLabel)
        super.viewDidLoad()
        myQRCodeReader.delegate = self
        myQRCodeReader.setupCamera(view:self.view)
        //読み込めるカメラ範囲
        myQRCodeReader.readRange()
        
    }
}


extension ViewControllAdder: AVCaptureMetadataOutputObjectsDelegate{
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //let flag = myQRCodeReader.onClick
        /*if metadataObjects.count == 0 {
            messageLabel.text = "No QR code is detected"
            return
        }*/
        //一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let barCode = myQRCodeReader.previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            //読み込んだQRを映像上で枠を囲む。ユーザへの通知。必要な時は記述しなくてよい。
            myQRCodeReader.qrView.frame = barCode.bounds
            //QRデータを表示
            if let str = metadata.stringValue {
                //messageLabel.text = metadata.stringValue
                
                //比較　同様のやつが既に登録されているか?
                let data = InspectSerch(str: str)
                if data == [] {
                    
                    inspectData(str: str)
                    
                } else {
                    
                    print("skip")
                    
                }
            }
        }
    }
    
    func InspectSerch(str: String) -> [InspectionData] {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let fetcgRequest: NSFetchRequest<InspectionData> = InspectionData.fetchRequest()
        //検索条件
        let predicate = NSPredicate(format: "%K = %@", "inspection", "\(str)")
        fetcgRequest.predicate = predicate
        
        let fetchData = try! manageContext.fetch(fetcgRequest)
        return fetchData
    }
        
    //inspect追加
    func inspectData(str: String){
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "InspectionData", in: manageContext) else { return  }
        let ent_name = NSManagedObject(entity: entity, insertInto: manageContext)
        
        ent_name.setValue(str, forKey: "inspection")
        
        do {
            try manageContext.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

struct ViewControllAdderWrapper : UIViewControllerRepresentable{
    typealias UIViewControllerType = ViewControllAdder
    
    func makeUIViewController(context: UIViewControllerRepresentableContext <ViewControllAdderWrapper>) -> ViewControllAdderWrapper.UIViewControllerType {
        return UIViewControllerType.init()
    }
    
    func updateUIViewController(_ uiViewController: ViewControllAdderWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllAdderWrapper>) {
    }
}
