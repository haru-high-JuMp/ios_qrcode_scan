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

class ViewController: UIViewController{

    let myQRCodeReader = MyQRCodeReader()
    var flag = 0
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


extension ViewController: AVCaptureMetadataOutputObjectsDelegate{
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
                let data = productSerch(str: str)
                if self.flag == 0{
                    if data == [] {
                        // 取得したデータの処理を行う
                        writeData(str: str)
                        self.flag = 1
                        let alert: UIAlertController = UIAlertController(title: "QRcodeの中身", message: str, preferredStyle: UIAlertController.Style.alert)
                    
                        let entryProduct: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            (action: UIAlertAction!) -> Void in
                            self.flag = 0
                        })
                        //アラート表示
                        alert.addAction(entryProduct)
                        present(alert, animated: true, completion: nil)
                    } else {
                        print("skip")
                    }
                }
            }
        }
    }
    
    func productSerch(str: String) -> [ProductData] {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let fetcgRequest: NSFetchRequest<ProductData> = ProductData.fetchRequest()
        //検索条件
        let predicate = NSPredicate(format: "%K = %@", "product", "\(str)")
        fetcgRequest.predicate = predicate
        
        let fetchData = try! manageContext.fetch(fetcgRequest)
        return fetchData
    }
    
    //Product追加
    func writeData(str: String){
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "ProductData", in: manageContext) else { return  }
        let ent_name = NSManagedObject(entity: entity, insertInto: manageContext)
        
        ent_name.setValue(str, forKey: "product")
        
        do {
            try manageContext.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

struct ViewControllerWrapper : UIViewControllerRepresentable{
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext <ViewControllerWrapper>) -> ViewControllerWrapper.UIViewControllerType {
        return UIViewControllerType.init()
    }
    
    func updateUIViewController(_ uiViewController: ViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerWrapper>) {
    }
}

