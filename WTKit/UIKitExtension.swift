//
//  UIKitExtension.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
#if os(iOS)
import Foundation
import UIKit
import ImageIO
public typealias imageHandler = ((UIImage?,Error?)->Void)
@available(iOS 2.0, *)

extension UIColor{
    
    /*!
     根据字符串和alpha给出颜色
     如果给出的是一个不正常的字符串,会返回红色
     */
    public class func colorWithHexString(_ string:String,alpha:CGFloat?=1.0) -> UIColor{
        //        let s = NSScanner(string: string)
        let mutableCharSet = NSMutableCharacterSet()
        mutableCharSet.addCharacters(in: "#")
        mutableCharSet.formUnion(with: CharacterSet.whitespaces);
        
        
        let hString = string.trimmingCharacters(in: mutableCharSet as CharacterSet)
        DEBUGBlock {
            //            NSLog("%@", hString)
        }
        
        
        switch hString.length {
        case 0:
            return UIColor.red;
        case 1:
            return UIColor.colorWithHexString(hString+hString);
        case 2:
            return UIColor.colorWithHexString(hString+hString+hString);
        case 6:
            let r = hString[0..<2]
            let g = hString[2..<4]
            let b = hString[4..<6]
            var rInt:UInt32 = 0x0,gInt:UInt32 = 0x0,bInt:UInt32 = 0x0
            
            Scanner.init(string: r).scanHexInt32(&rInt)
            Scanner.init(string: g).scanHexInt32(&gInt)
            Scanner.init(string: b).scanHexInt32(&bInt)
            
            let red = CGFloat(rInt)/255.0
            let green = CGFloat(gInt)/255.0
            let blue = CGFloat(bInt)/255.0
            //            WTLog("\(red) \(green) \(blue)")
            let color = UIColor(red: red, green: green, blue: blue,alpha: alpha!)
            return color;
        default:
            return UIColor.red;
        }
    }
    
    public func intFromString(_ string:String)->UInt32{
        var intValue:UInt32 = 0x0;
        Scanner.init(string:string).scanHexInt32(&intValue)
        return intValue
    }
    
    
    public func antiColor()->UIColor{
        var r:CGFloat=0
        var g:CGFloat=0
        var b:CGFloat=0
        var a:CGFloat=0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1-r, green: 1-g, blue: 1-b, alpha: a)
    }
    
    //TODO
    public func hexString()->String{
        return ""
    }
    
    private class func randomColorValue()->CGFloat{
        return CGFloat(arc4random()).truncatingRemainder(dividingBy: 255.0)
    }
    
    //随机产生一个颜色
    public class func randomColor()->UIColor{
        let color:UIColor
        color = UIColor(red: randomColorValue(), green: randomColorValue(), blue: randomColorValue(), alpha: 1.0);
        return color
    }
    
    
    
    //传入0-1   0是最差   1是最好
    public class func wtStatusColor(with status:Float)->UIColor{
        let myStatus = max(min(status, 1), 0)
        let red:CGFloat = min(1, CGFloat (myStatus * 2))
        let green:CGFloat = min(1, CGFloat (myStatus * -2 + 2))
        return UIColor.init(red: red, green: green, blue: 0, alpha: 1)
    }
    
}
    
@available(iOS 2.0, *)
extension UIApplication{
    
    
    /*
     public class func openSettings(){
     
     if #available(iOS 10.0, *) {
     let options = [String:Any]();
     let url:URL = URL(string: UIApplicationOpenSettingsURLString)!;
     UIApplication.shared.open(url, options: options, completionHandler: { (flag) in
     
     })
     }else{
     UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
     }
     
     }
     */
    
    

    
    public static func documentsPath()->String{
        return String(format: "%@/Documents",NSHomeDirectory())
    }
    
    public static func libraryPath()->String{
        return String(format: "%@/Library",NSHomeDirectory())
    }
    
    
    // MARK: - 版本记录以及是否是本次build首次启动
    
    
    
}
@available(iOS 2.0, *)
extension UIScreen{
    public static func screenWidth()->CGFloat{
        return UIScreen.main.bounds.width
    }
    public static func screenHeight()->CGFloat{
        return UIScreen.main.bounds.height
    }
}
extension UIDevice{
    public static func systemVersion()->String{
        return UIDevice.current.systemVersion
    }
    public static func systemFloatVersion()->Float{
        return UIDevice.current.systemVersion.floatValue
    }
    
    //
    public static func uuidString()->String{
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    
    /*!
     is iPhone
     */
    public static func isPhone()->Bool{
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return true
        }
        return false
    }
    
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

    
    // MARK: - 磁盘空间/可用空间/已用空间
    /*!
     硬盘空间
     */
    public func diskSpace()->Int64{
        var attributes: [FileAttributeKey : Any]
        var fileSystemSize:Int64 = 0
        do{
            let fm = FileManager.default;
            try attributes = fm.attributesOfFileSystem(forPath: NSHomeDirectory())
            //                try attributes = FileManager.default.attributesOfItem(atPath: NSHomeDirectory())
            //            fileSystemSize = (attributes![attributes.systemSize.rawValue]?.int64Value)!
            //            fileSystemSize = attributes[FileAttributeKey.fileSystemSize]
            fileSystemSize = (attributes[FileAttributeKey.systemSize] as AnyObject).int64Value
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
     可用空间
     */
    public func diskSpaceFree()->Int64{
        var attributes:[FileAttributeKey : Any]
        var fileSystemSize:Int64 = 0
        do{
            try attributes = FileManager.default.attributesOfItem(atPath: NSHomeDirectory())
            //            attributes?["aaa"]!
            fileSystemSize = (attributes[FileAttributeKey.systemFreeSize]as AnyObject).int64Value
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
     已用空间
     */
    public func diskSpaceUsed()->Int64{
        return diskSpace() - diskSpaceFree()
    }
    
    /*!
     物理内存
     */
    public func memoryTotal()->UInt64{
        let mem = ProcessInfo.processInfo.physicalMemory;
        return mem;
    }
    
}

//target - action block keys
private var UIControlTargetActionBlockKeys:Void?
public typealias uiControlHandler = (UIControl)->Swift.Void
extension UIControl{
    private var taBlockKeys:[UIControlTABlock]{
        get{
            var obj = objc_getAssociatedObject(self, &UIControlTargetActionBlockKeys)
            if( obj is Array<UIControlTABlock> ){
                
            }else{
                obj = [UIControlTABlock]()
                objc_setAssociatedObject(self, &UIControlTargetActionBlockKeys, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return obj as! Array<UIControlTABlock>
        }
        set{
            objc_setAssociatedObject(self, &UIControlTargetActionBlockKeys, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func addtarget(_ block:@escaping uiControlHandler, forControlEvents controlEvents: UIControlEvents)->Void{
        let taBlock = UIControlTABlock()
        taBlock.block = block
        let selector = #selector(UIControlTABlock.run(_:))
        self.addTarget(taBlock, action: selector, for: controlEvents)
        self.taBlockKeys.append(taBlock)
    }
    public func reciveEvent(_ sender:UIControl){
        
    }
    
    class UIControlTABlock:NSObject{
        var block:uiControlHandler?
        var event:UIControlEvents?
        
        override init() {
            
            super.init()
        }
        
        deinit{
            WTLog("deinit")
        }
        
        @objc func run(_ sender:UIControl){
            if block != nil{
                block?(sender)
            }
        }
    }
    
}





extension UIViewController{
    //弹出Alert
    public func showAlert(_ title:String?, message:String? , duration:Double){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        OperationQueue.main.addOperation {
            self.present(alert, animated: true) {
                self.performBlock({
                    alert.dismiss(animated: true, completion: {
                        
                    })
                }, afterDelay: duration)
            }
        }
    }
    
    
    
    
}


extension UIView{
    //绘制截图
    public func snapShot() -> UIImage!{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image;
    }
    
    /*!
     将UIView绘制成PDF
     */
    public func pdf()->Data{
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil);
        UIGraphicsBeginPDFPage();
        let pdfContext:CGContext? = UIGraphicsGetCurrentContext();
        self.layer.render(in: pdfContext!)
        UIGraphicsEndPDFContext();
        
        return pdfData as Data
    }
    
    
    /*!
     创建一个可缩放
     */
    public func setViewForImage(_ image:UIImage){
        
        let scrollview = UIScrollView(frame: self.bounds)
        addSubview(scrollview)
        
    }
    
    
    /*!
     清空所有子视图
     */
    public func removeAllSubViews(){
        while self.subviews.count != 0 {
            self.subviews.first?.removeFromSuperview()
        }
    }
    
    public func viewController()->UIViewController?{
        if self.next is UIViewController {
            return self.next as? UIViewController
        }else{
            return nil
        }
    }
}

extension UIWebView{
    /*!
     缓存网页
     */
    public func loadRequest(_ request: URLRequest, useCache:Bool){
        let req:NSMutableURLRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        if useCache {
            req.cachePolicy = .returnCacheDataElseLoad
        }
        loadRequest(request)
    }
}

// MARK: - 下拉刷新
public class RefreshHeader:UIView{
    /*!
     这里5条数据可配置
     */
    public var pullDownToRefreshText:String = "pull down to refresh"
    public var releaseToRefreshText:String = "release to refresh"
    public var loadingText:String = "Loading..."
    public var lastUpdateText:String = "last update time:"
    public var dateStyle:String = "HH:mm"

    
    var refreshBlock:()->Void
    weak var scrollView:UIScrollView?
    fileprivate var state:ScrollViewRefreshState{
        willSet{
            //            print(newValue)
        }
        didSet{
            if oldValue != state {
                updateTitle()
            }else{
                //equal, no need to update title
                //                print("no need to update")
            }
            
            
        }
    }
    public var refreshHeight:CGFloat
    
    
    private var titleLabel:UILabel
    private var timeLabel:UILabel
    
    
    public var arrowImageView:UIImageView
    private var activityIndicator:UIActivityIndicatorView
    private var lastUpdateDate:Date? = nil
    private var dateFormatter:DateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        self.refreshBlock = {}
        state = .pullDownToRefresh
        refreshHeight = frame.height
        titleLabel = UILabel()
        timeLabel = UILabel()
        arrowImageView = UIImageView()
        //        arrowImageView.
        let image = UIImage(named: "arrow")
        arrowImageView.image = image
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(arrowImageView)
        addSubview(activityIndicator)
        
        
        //        titleLabel.frame = CGRectMake(0, 0, UIScreen.screenWidth(), 40)
        self.configLayoutConstraint()
        titleLabel.textAlignment = .center
        
        
        
        //        timeLabel.frame = CGRectMake(0, 40, UIScreen.screenWidth(), 20)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.colorWithHexString("3")
        arrowImageView.frame = CGRect(x: 30, y: 0, width: 30, height: frame.height)
        activityIndicator.frame = arrowImageView.frame
        activityIndicator.hidesWhenStopped = true
        self.backgroundColor = UIColor.white
        
    }
    private func configLayoutConstraint(){
        //关闭自动伸展,改为用约束来控制
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        //这里的左侧和右侧 用Leading和Trailing的原因是为了适应各国语言的书写顺序,通常都是
        //从左向右的,但是个别国家的书写顺序是从右向左的,所以要注意一下
        var left = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        var right = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        var top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        var height = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        constraints.append(left)
        constraints.append(right)
        constraints.append(top)
        constraints.append(height)
        
        
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        left = NSLayoutConstraint(item: timeLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        right = NSLayoutConstraint(item: timeLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        top = NSLayoutConstraint(item: timeLabel, attribute: .top, relatedBy: .equal, toItem:titleLabel, attribute: .bottom, multiplier: 1, constant: 0)
        height = NSLayoutConstraint(item: timeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        constraints.append(left)
        constraints.append(right)
        constraints.append(top)
        constraints.append(height)
        
        
        
        if UIDevice.systemFloatVersion() >= 8.0 {
            NSLayoutConstraint.activate(constraints)
        }else{
            self.addConstraints(constraints)
        }
        
        //        self.addConstraints(constraints)
        //        self.updateConstraintsIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        WTLog("RefreshHeader deinit \(self)")
    }
    
    public enum ScrollViewRefreshState:Int{
        case pullDownToRefresh
        case releaseToRefresh
        case loading
    }
    
    /*!
     这个方法来设置不同状态的文案
     */
    public func setTitle(_ title:String, forState:ScrollViewRefreshState){
        switch forState {
        case .pullDownToRefresh:
            pullDownToRefreshText = title
            break
        case .releaseToRefresh:
            releaseToRefreshText = title
            break
        case .loading:
            loadingText = title
            break
        }
        updateTitle()
    }
    
    private func updateTitle(){
        //        WTLog("update title")
        activityIndicator.stopAnimating()
        self.arrowImageView.isHidden = false
        switch state {
        case .pullDownToRefresh:
            titleLabel.text = pullDownToRefreshText
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: nil)
            if lastUpdateDate != nil {
                dateFormatter.dateFormat = dateStyle
                timeLabel.text = "\(lastUpdateText)\(dateFormatter.string(from: lastUpdateDate!))"
            }
            break
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshText
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: nil)
            break
        case .loading:
            titleLabel.text = loadingText
            self.arrowImageView.isHidden = true
            activityIndicator.startAnimating()
            self.lastUpdateDate = Date()
            refreshBlock()
            //
            var options = UIViewAnimationOptions()
            options = options.union(UIViewAnimationOptions.beginFromCurrentState)
            options = options.union(UIViewAnimationOptions.curveEaseOut)
            UIView.animate(withDuration: 0.1, delay: 0, options: options, animations: {
                self.scrollView?.contentInset = UIEdgeInsetsMake((self.refreshHeight), 0, 0, 0);
                self.alpha = 1.0
            }) { (finish) in
                
            }
            let offset = CGPoint(x: 0, y: -self.refreshHeight)
            self.scrollView?.setContentOffset(offset, animated: true)
            self.setNeedsDisplay()
            
            break
        }
    }
    
    public class func headerWithRefreshing(_ block:@escaping ()->Void)->RefreshHeader{
        let width = UIScreen.screenWidth()
        let height:CGFloat = 60
        let header = RefreshHeader(frame: CGRect(x: 0,y: -height,width: width,height: height))
        header.refreshBlock = block
        
        return header
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        removeObservers();
        if newSuperview is UIScrollView {
            self.scrollView = newSuperview as? UIScrollView
            addObservers()
        }else{
            
        }
    }
    
    
    private func contentOffset()->String{
        return "contentOffset"
    }
    private func dragging()->String{
        return "dragging"
    }
    private func contentSize()->String{
        return "contentSize"
    }
    private func addObservers(){
        //        self.scrollView?.contentOffset
        //        self.scrollView?.dragging
        //        WTLog(self.scrollView)
        if let sc:UIScrollView = self.scrollView {
            sc.addObserver(self, forKeyPath: contentOffset(), options: .new, context: nil)
            sc.addObserver(self, forKeyPath: contentSize(), options: .new, context: nil)
        }
        
        
        //        self.scrollView?.addObserver(self, forKeyPath: "dragging", options: .New, context: nil)
    }
    public func removeObservers(){
        self.scrollView?.removeObserver(self, forKeyPath: contentOffset())
        self.scrollView?.removeObserver(self, forKeyPath: contentSize())
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if keyPath == contentOffset() {
            self.scrollViewContentOffsetDidChange(change as AnyObject?)
        }else if keyPath == contentSize(){
            if self.scrollView != nil {
                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.scrollView!.frame.width, height: refreshHeight)
                //                titleLabel.layoutIfNeeded()
                //                timeLabel.layoutIfNeeded()
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    private func scrollViewContentOffsetDidChange(_ change:AnyObject?)->Void{
        if self.scrollView != nil {
            if (self.scrollView!.isDragging) {
                
                //如果正在拖拽,就刷新一下状态
                if self.state != .loading {
                    if (self.scrollView?.contentOffset.y)! > -refreshHeight {
                        self.state = .pullDownToRefresh
                    }else
                    {
                        self.state = .releaseToRefresh
                    }
                }
                
            }else{
                if state == .releaseToRefresh {
                    self.state = .loading
                }
                
                
            }
        }
    }
    
    public func beginRefresh(){
        if state == .loading {
            return;
        }
        self.state = .loading
        
        
    }
    
}
private var refreshHeaderKey:Void?
extension UIScrollView{
    
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview);
        if newSuperview == nil {
            self.refreshHeader?.removeObservers();
        }
    }
    
    public weak var refreshHeader:RefreshHeader?{
        get{
            let r = objc_getAssociatedObject(self, &refreshHeaderKey)
            return r as? RefreshHeader
            
        }
        set{
            let header = self.refreshHeader
            if ((header?.superview) != nil) {
                header?.removeFromSuperview()
            }
            if newValue != nil {
                self.addSubview(newValue!)
            }
            objc_setAssociatedObject(self, &refreshHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    
    // state 1.PullDownToRefresh 2.loading
    /*!
     下拉
     */
    public func startRefresh()->Void{
        
        self.refreshHeader?.beginRefresh()
        
    }
    
    /*!
     回收
     */
    public func stopLoading()->Void{
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.contentOffset = CGPoint(x: 0, y: 0)
            
        }) { (finish) in
            self.refreshHeader?.arrowImageView.isHidden = false
            self.refreshHeader?.arrowImageView.transform = CGAffineTransform.identity
            self.refreshHeader?.state = .pullDownToRefresh
        }
    }
    
    
    
    
    
    
}
extension UITableView{
    public func updateWithClosure(_ table:(_ table:UITableView)->Void){
        self.beginUpdates()
        table(self)
        self.endUpdates()
    }
    
    public func insertRowAtIndexPath(_ indexPath: IndexPath, withRowAnimation animation: UITableViewRowAnimation){
        self.insertRows(at: [indexPath], with: animation)
    }
    
    public func insertRowAt(row:Int, section:Int,withRowAnimation animation: UITableViewRowAnimation){
        let indexPath = IndexPath(row: row, section: section)
        self.insertRowAtIndexPath(indexPath, withRowAnimation: animation)
    }
    
    
    /*!
     取消所有选中的cell
     */
    public func clearSelectedRows(_ animated:Bool){
        let indexPathsForSelectedRows = self.indexPathsForSelectedRows
        if indexPathsForSelectedRows != nil {
            for(_, indexPath) in self.indexPathsForSelectedRows!.enumerated(){
                self.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
    
}
extension UICollectionView{
    
}
extension UITextView{
    public func selectAllText(){
        let range = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
        self.selectedTextRange = range
    }
}
extension UICollectionView{
    //------------------图片查看----------------
}
public class FPSLabel:UIView{
    lazy var fpslabel:UILabel = UILabel()
    lazy var light:UIView = UIView()
    var displayLink:CADisplayLink?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let sel = #selector(FPSLabel.wtdisplay(ca:))
        displayLink = CADisplayLink(target: self, selector:sel)
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        addSubview(fpslabel)
        addSubview(light)
        light.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        light.layer.cornerRadius = 7
        fpslabel.frame = CGRect(x: 20, y: 0, width: 200, height: 14)
    }
    
    deinit {
        
    }
    
    @objc public func wtdisplay(ca:CADisplayLink){
        let fps:Double = Double(1.0) / Double(ca.duration)
        var percent:Double = 0
        var preferredFramesPerSecond:Double = 0
        if #available(iOS 10.0, *) {
            
            preferredFramesPerSecond = Double(ca.preferredFramesPerSecond)
        } else {
            preferredFramesPerSecond = 1/Double(ca.frameInterval)
        }
        percent = Double(fps / Double(preferredFramesPerSecond))
        let color = UIColor.wtStatusColor(with: Float(1 - percent))
        light.backgroundColor = color
        fpslabel.text = String(format: "fps: %.2f", fps)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CALayer{
    //绘制截图
    public func snapShot() -> UIImage!{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        let context = UIGraphicsGetCurrentContext()
        self.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    /*!
     暂停动画
     */
    public func pauseAnimation(){
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0;
        self.timeOffset = pausedTime;
    }
    /*!
     继续动画
     */
    public func resumeAnimation(){
        let pausedTime = self.timeOffset
        
        self.speed = 1.0;
        self.timeOffset = 0.0;
        self.beginTime = 0.0;
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause;
        
        
    }
}
extension NSLayoutConstraint{
    
}


//CG Kit
extension CGRect{
    public var centerPoint:CGPoint{
        return CGPoint(x: self.midX, y: self.minY)
    }
}


// MARK: - 附加类



/*!
 图片缩放类
 用于可缩放的图片查看
 */
public class ImageViewerView:UIView,UIScrollViewDelegate{
    let scrollView:UIScrollView
    let imageView:UIImageView
    public init(frame: CGRect,image:UIImage?) {
        scrollView = UIScrollView()
        imageView = UIImageView()
        super.init(frame: frame)
        scrollView.frame = bounds
        scrollView.maximumZoomScale = 4;
        scrollView.minimumZoomScale = 1;
        imageView.frame = bounds
        imageView.image = image
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
    }
    
    /*!
     重置缩放比
     //离开当前页的时候推荐调用
     */
    public func resetScale()->Void{
        scrollView.zoomScale = 1.0
    }
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



/*!
 用于屏幕上方的网络指示器
 */
public class WTNetworkActivityIndicatorManager{
    
    public static let sharedManager = WTNetworkActivityIndicatorManager()
    private var activityCount: Int = 0
    private var enabled: Bool = true
    init(){
        
    }
    public func incrementActivityCount() {
        activityCount += 1
        updateVisible()
    }
    public func decrementActivityCount() {
        activityCount -= 1
        updateVisible()
    }
    func updateVisible(){
        if enabled {
            if activityCount>0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
    

#endif



