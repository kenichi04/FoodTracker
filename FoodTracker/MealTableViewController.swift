//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by takashimakenichi on 2021/01/01.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    var meals = [Meal]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load sample data.
        loadSampleMeals()
    }

    // MARK: - Table view data source

    // tableViewのセクション数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // セクションに対する行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    // 列ごとに表示するセルを決める
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        // UITableViewCellからカスタムのMealTableViewCellへのダウンキャスト
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not instance of MealTableViewCell.")
        }
        // セルに表示させるデータ取得,indexPath（IndexPath型）はsectionとrowプロパティを持つ
        // Fetchs the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        // セルにデータを適用させる
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // segueのidentifierによって、新規追加と編集のケース分け
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new model.", log: .default, type: .debug)
        case "ShowDetail":
            // destinationプロパティ:遷移先のviewControllerを取得
            guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            // 遷移先のviewControllerのmealプロパティに選択したcellのmealオブジェクトを設定する
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // segueのsourceプロパティは遷移元のViewControllerを指す
        if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
            
            // 新規作成時はnil、編集時はセルを選択してから遷移しているためnilにはならない
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Updata an existing meal.
                // 遷移元のmealで上書き
                meals[selectedIndexPath.row] = meal
                // tableViewの表示を更新
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                
            } else {
                // Add a new meal.
                // 新しいデータをtableViewに挿入する場所（rowは0からmeals.count-1まで存在するため、末尾を指定）
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                // 配列に追加
                meals.append(meal)
                // tableViewに行を追加
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func loadSampleMeals() {
        
        // UIImageを返す画像リテラル：#imageLiteral(resourceName:)
        let photo1 = #imageLiteral(resourceName: "meal1")
        let photo2 = #imageLiteral(resourceName: "meal2")
        let photo3 = #imageLiteral(resourceName: "meal3")
        
        guard let meal1 = Meal(name: "Hamburger", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiage meal1")
        }
        
        guard let meal2 = Meal(name: "Sushi Bento", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Grilled Beef", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        meals += [meal1, meal2, meal3]
    }
}
