//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Un on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filterViewControllerDidUpdate(_ filterViewController: FiltersViewController)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var distanceFilters: [Float] = [0, 0.3, 1, 5, 20]
    var switchStates = [Int: Bool] ()
    var categories: [Dictionary<String, String>] = []
    
    let filters = Filters.filterModel
    
    var dealValue: Bool = false
    var distanceValue: Float = 0
    var sortByValue: Int = 0
    var categoriesSearch = [String]()
    
    var isDistanceExpand: Bool = false
    var isSortByExpand: Bool = false
    var isCategoriesExpand: Bool = false
    
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = getCategories()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.tableFooterView = UIView()
        
    }

    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: UIBarButtonItem) {
        
        filters.categories = categoriesSearch
        filters.sortByValue = sortByValue
        filters.dealValue = dealValue
        filters.distanceValue = distanceValue
        
        delegate?.filterViewControllerDidUpdate!(self)
        
        dismiss(animated: true, completion: nil)
    }
    
}

// TABLE VIEW
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 8
        case 4:
            return 0
        default:
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerSection = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 48))
        headerSection.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 48))
        switch section {
        case 1:
            titleLabel.text = "Distance"
        case 2:
            titleLabel.text = "Sort By"
        case 3:
            titleLabel.text = "Categories"
        default:
            return nil
        }
        
        headerSection.addSubview(titleLabel)
        
        return headerSection
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 3
        case 4:
            return 1
        default:
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = (indexPath as NSIndexPath).section
        let indexPathRow = (indexPath as NSIndexPath).row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.titleLabel.text = "Offering a Deal"
            cell.switchButton.isOn = Filters.filterModel.dealValue
            
            settingCell(cell: cell)
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell") as! SelectCell
            switch indexPathRow {
            case 0:
                cell.titleLabel.text = "Auto"
            case 1:
                cell.titleLabel.text = String(format: "%g mile", distanceFilters[indexPathRow])
            default:
                cell.titleLabel.text = String(format: "%g miles", distanceFilters[indexPathRow])
            }
            
            if self.distanceValue == distanceFilters[indexPathRow] {
                if isDistanceExpand {
                    cell.iconImageView.image = #imageLiteral(resourceName: "check-24")
                } else {
                    cell.iconImageView.image = #imageLiteral(resourceName: "arrow_drop_down_grey_192x192")
                }
            } else {
                cell.iconImageView.image = #imageLiteral(resourceName: "uncheck-24")
            }
            
            settingCell(cell: cell)
            cell.delegate = self
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell") as! SelectCell
            switch indexPathRow {
            case 0:
                cell.titleLabel.text = "Best match"
            case 1:
                cell.titleLabel.text = "Distance"
            default:
                cell.titleLabel.text = "Highest rated"
            }
            
            if self.sortByValue == indexPathRow {
                if isSortByExpand {
                    cell.iconImageView.image = #imageLiteral(resourceName: "check-24")
                } else {
                    cell.iconImageView.image = #imageLiteral(resourceName: "arrow_drop_down_grey_192x192")
                }
            } else {
                cell.iconImageView.image = #imageLiteral(resourceName: "uncheck-24")
            }
            
            settingCell(cell: cell)
            cell.delegate = self
            return cell
        
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.titleLabel.text = categories[indexPathRow]["name"]
            
            cell.switchButton.isOn = switchStates[indexPathRow] ?? false
            
            settingCell(cell: cell)
            cell.delegate = self
            return cell
            
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell") as! SeeAllCell
            if isCategoriesExpand {
                cell.titleLabel.text = "Shrink All"
            } else {
                cell.titleLabel.text = "See All"
            }
            settingCell(cell: cell)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = (indexPath as NSIndexPath).section
        
        switch section {
        case 1:
            
            if isDistanceExpand {
                return 48
            } else {
                if distanceValue == distanceFilters[indexPath.row] {
                    return 48
                }else {
                    return 0
                }
            }
        case 2:
            if isSortByExpand {
                return 48
            } else {
                if sortByValue == indexPath.row {
                    return 48
                }else {
                    return 0
                }
            }
            
        case 3:
            if (indexPath.row) <= 2 || isCategoriesExpand {
                return 48
            } else {
                return 0
            }

        default:
            return 48
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = (indexPath as NSIndexPath).section
        switch section {
        case 1:
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        case 2:
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        case 4:
            if isCategoriesExpand {
                isCategoriesExpand = false
            } else {
                isCategoriesExpand = true
            }
            tableView.reloadSections(IndexSet(integer: 3), with: .none)
        default:
            return
        }
    }
    
    func settingCell(cell: UITableViewCell) {
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        
    }
    

}

// DELEGATE
extension FiltersViewController: SwitchCellDelegate, SelectCellDelegate{
    
    func selectCellDidCellSelected(_ selectCell: SelectCell) {
        let indexPath = tableView.indexPath(for: selectCell)
        if indexPath != nil {
            
            let section = indexPath!.section
            switch section {
            case 1:
                self.distanceValue = distanceFilters[(indexPath?.row)!]
                if isDistanceExpand {
                    isDistanceExpand = false
                } else {
                    isDistanceExpand = true
                }
            
            default:
                self.sortByValue = (indexPath?.row)!
                print(self.sortByValue)
                if isSortByExpand {
                    isSortByExpand = false
                } else {
                    isSortByExpand = true
                }
            }
        }

        
    }
    
    func switchCellDidSwitchChanged(_ switchCell: SwitchCell, didValueChanged value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        let section = indexPath!.section
        switch section {
        case 0:
            self.dealValue = value
            
        default:
            self.switchStates[(indexPath?.row)!] = value
            
            for (row, isSelected) in self.switchStates {
                if isSelected {
                    self.categoriesSearch.append(categories[row]["code"]!)
                }
            }
        }
    }
    
}

extension FiltersViewController {
    func getCategories() -> [Dictionary<String, String>] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}
