//
//  XFPickerView.swift
//  IFXY
//
//  Created by zyz on 17/1/6.
//  Copyright © 2017年 IFly. All rights reserved.
//

import UIKit

class XFPickerView: UIView {
    
    
  fileprivate var pickerView: PickerView!
  fileprivate let pickerViewHeight:CGFloat = 260.0
  fileprivate let screenWidth = UIScreen.main.bounds.size.width
  fileprivate let screenHeight = UIScreen.main.bounds.size.height
  fileprivate var hideFrame:CGRect {
    return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickerViewHeight)
  }
    fileprivate var showFrame:CGRect{
        return CGRect(x: 0.0, y:screenHeight - pickerViewHeight, width: screenWidth, height: pickerViewHeight)
    }
    
    public typealias SingleDoneAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias DateDoneAction = (_ selecteddate:Date)->Void
    
    
 
    //便利构造函数
    convenience init(frame: CGRect,toolBarTitle:String,singleColData:[String],defaultselectedIndex:Int?,doneAction: SingleDoneAction?) {
        self.init(frame: frame)
        
        pickerView = PickerView.singleColPickerView(toolBarTitle, singleColData: singleColData, defaultIndex: defaultselectedIndex, cancelAction: {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
        }, doneAction: { [unowned self] (selectedIndex, selectedValue) in
            // 点击取消的时候移除
            print("selectedIndex = \(selectedIndex) selectedValue = \(selectedValue)")
             doneAction?(selectedIndex, selectedValue)
            self.hidePicker()
        })
//        pickerView.backgroundColor = UIColor.yellow
        pickerView.frame = hideFrame
        
        addSubview(pickerView)
        
        //添加点击背景移出self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
        
    }
    
    // 日期选择器
     convenience init(frame: CGRect,toolBarTitle:String,datePickerSetting: DatePickerSetting, doneAction: DateDoneAction?) {
        self.init(frame:frame)
        
        pickerView = PickerView.datePicker(toolBarTitle, datePickerSetting: datePickerSetting, cancelAction:  {[unowned self] in
            // 点击取消的时候移除
            self.hidePicker()
            
            }, doneAction: {[unowned self] (selectedDate) in
                doneAction?(selectedDate)
                self.hidePicker()
        })
        
        pickerView.frame = hideFrame
        addSubview(pickerView)
        
        // 点击背景移除self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOrentationObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self.debugDescription) --- 销毁")
    }
}

// MARK:- 弹出和移除self
extension XFPickerView{
    
    // 1 show
    fileprivate func showPicker(){
         // 1 通过window 弹出view
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return  }
        currentWindow.addSubview(self)
        
        // 2 
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            self?.pickerView.frame = (self?.showFrame)!
        }, completion: nil)
    }
    
    // 2 hide
    fileprivate func hidePicker(){
        // 把self从window中移除
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.backgroundColor = UIColor.clear
            self?.pickerView.frame = (self?.hideFrame)!
            }, completion: {[weak self] (_) in
                self?.removeFromSuperview()
        })
    }
    
    // 3 移除背景
     func tapAction(_ tap:UITapGestureRecognizer){
        
        let location = tap.location(in: self)
        // 点击空白背景移除self
        if location.y <= screenHeight - pickerViewHeight {
            self.hidePicker()
        }
    }
    
    // 4 屏幕旋转时移除pickerView通知
    fileprivate func addOrentationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    func statusBarOrientationChange() {
        removeFromSuperview()
    }
    
}

// MARK: -  快速使用方法
extension XFPickerView{
    
    /// 单列选择器
    ///
    ///  - parameter title:                      标题
    ///  - parameter data:                       数据
    ///  - parameter defaultSeletedIndex:        默认选中的行数
    ///  - parameter doneAction:                 响应完成的Closure
    ///
    ///  - returns:

    public class func showSingleColPicker(_ toolBarTitle:String, data: [String], defalutSelectedIndex:Int?,doneAction:SingleDoneAction?){
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        let contentView = XFPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, singleColData: data, defaultselectedIndex: defalutSelectedIndex, doneAction: doneAction)
        
        contentView.showPicker()
    }
    
    /// 日期选择器                                 ///  @author ZeroJ, 16-04-23 18:04:59
    ///
    ///  - parameter title:                      标题
    ///  - parameter datePickerSetting:          可配置UIDatePicker的样式
    ///  - parameter doneAction:                 响应完成的Closure
    ///
    ///  - returns:

    public class func showDatePicker(_ toolBarTitle:String,datePickerSetting:DatePickerSetting = DatePickerSetting(),doneAction:DateDoneAction?){
    
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return  }
        let contentView = XFPickerView(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, datePickerSetting: datePickerSetting, doneAction: doneAction)
        contentView.showPicker()
        
        
    }
    
    
    
    
    
    
    
}
