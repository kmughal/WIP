import RxSwift
import RxCocoa

class LineStatusViewController: UIViewController {
    
    private var table:LineStatusTable = LineStatusTable(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    public var lineStatusBuilder:LineStatusBuilder? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func revertColor() {
        self.view.backgroundColor = Shared.Instance.DARK_BLUE
    }
    
    func removeAllSubViews() {
        self.view.subviews.forEach({$0.removeFromSuperview()})
    }
    
    func createLineStatusTableView(data:LineStatusViewModel) {
         self.table = LineStatusTable(frame: CGRect(
            x: 0,
            y: 10,
            width: self.view.bounds.width,
            height: self.view.bounds.height))
        
        table.viewModel = data
        self.view.addSubview(self.table)
        table.reloadData()
        table.viewDidLoad()
        table.separatorStyle = .none
        table.backgroundColor = Shared.Instance.DARK_BLUE
    }
    
    func updateDataset(_ data:LineStatusViewModel) {
        Shared.Instance.updateUI {
            self.view.backgroundColor = Shared.Instance.DARK_BLUE
            self.removeAllSubViews()
            self.createLineStatusTableView(data:data)
        }
    }
    
    func getLineStatus() {
        
        let dispose = lineStatusBuilder?.build().subscribe(onNext: { data in
            let updateRequired = LineStatusViewModel.isJsonDifferent(oldJson: data.rawJson, newJson: self.table.viewModel.rawJson)
            
            if (updateRequired) {
                 self.updateDataset(data)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        guard let d:Disposable = dispose  else {
            return
        }
        
        print(d)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.lightGray
        self.getLineStatus()
        let result = Shared.Instance.runCodeInIntervals(interval: 100, code: {
            self.getLineStatus()
        })
        self.view.backgroundColor = UIColor.yellow
        print(result)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.layoutIfNeeded()
        self.table.frame = CGRect(
            x: 0,
            y: 10,
            width: size.width,
            height: size.height)
    }
}
