
import UIKit

class TableAnimationViewCell: UITableViewCell {
    override class func description() -> String {
        return "TableAnimationViewCell"
    }
    
    // MARK:- outlets for the viewController
   
    @IBOutlet weak var schoolName: UILabel!

    @IBOutlet weak var schoolAddress: UILabel!
    @IBOutlet weak var schoolPhone: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    // properties for the tableViewCell
    var tableViewHeight: CGFloat = 160
    var color = UIColor.init(hexString: "#A7C4BC"){
        didSet {
           
            self.containerView.backgroundColor = color
        }
    }
    
    var school : School? {
        didSet {
            schoolName.text = school?.schoolName
            schoolPhone.text = school?.phoneNumber
            schoolAddress.text = school?.address
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 4
    }
}
