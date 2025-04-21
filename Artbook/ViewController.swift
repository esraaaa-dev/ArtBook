//
//  ViewController.swift
//  Artbook
//
//  Created by Esra Arı on 15.04.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var paintingArray = [Paintings]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Artworks"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UINib(nibName: "ArtCell", bundle: nil), forCellReuseIdentifier: "ArtCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Navigation Bar a sağ üst köşeye + butonu ekleyelim
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paintingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = paintingArray[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    func getData(){
        //arrayi temizle
        paintingArray.removeAll(keepingCapacity: false)
        
        //context oluşturalım
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //verileri table view a getirmek için fetch request yapalım
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count>0 {
                for result in results as! [NSManagedObject]{
                    paintingArray.append(result as! Paintings)
                }
                tableView.reloadData()
            }
        }catch{
            print("Veri çekilemedi")
        }
    }
    // tableviewda tıklanılan artın detaylarını görmek
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPainting = paintingArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: selectedPainting)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! detailsVC
            if let selectedPainting = sender as? Paintings {
                destinationVC.chosenPainting = selectedPainting
                
            }
        }
    }
    func tableView(_ tableView: UITableView,
                           commit editingStyle: UITableViewCell.EditingStyle,
                           forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            //silinecek ögeyi al
            let paintingToDelete = paintingArray[indexPath.row]
            
            //core data dan sil
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(paintingToDelete)
            do{
                try context.save() // değişiklikleri kaydet
                paintingArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
                print("silme hatası")
            }
        }
    }
}


    
    
