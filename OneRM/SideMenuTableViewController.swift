// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import UIKit
import SideMenu

class SideMenuTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? UITableViewVibrantCell,
            let menu = navigationController as? SideMenuNavigationController {
            cell.blurEffectStyle = menu.blurEffectStyle
            return cell
        }
        return UITableViewCell()
    }
}
