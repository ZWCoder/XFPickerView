//
//  PickerView.swift
//  IFXY
//
//  Created by zyz on 17/1/7.
//  Copyright © 2017年 IFly. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width



public struct DatePickerSetting{
     /// 默认选中时间
    public var date = Date()
    public var dateMode = UIDatePickerMode.date
    //最小时间
    public var minimumDate:Date?
    //最大时间
    public var maximumDate:Date?
}


class PickerView: UIView {

    //1 属性定义
    fileprivate let pickerViewHeight = 216.0
    fileprivate let toolBarHeight = 44.0
    
    public enum PickerStyles{
        case single
        case date
    }
    fileprivate var pickerStyle: PickerStyles = .single
    
    fileprivate var singleColData: [String]? = nil
    
    fileprivate var selectedIndex: Int = 0
    fileprivate var selectedValue: String = ""{
        didSet{
        
        }
    }
    
    // 完成按钮的响应Closure
    public typealias BtnAction = () -> Void
    public typealias SingleDoneAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias DateDoneAction = (_ selectedDate: Date) -> Void
    
    //2 属性监听
    fileprivate var toolBarTitle = "请选择"{
        didSet{
            toolBar.title = toolBarTitle
        }
    }
    // 配置UIDatePicker的样式
    fileprivate var datePickerSetting = DatePickerSetting(){
        didSet{
            datePicker.date = datePickerSetting.date
            datePicker.minimumDate = datePickerSetting.minimumDate
            datePicker.maximumDate = datePickerSetting.maximumDate
            datePicker.datePickerMode = datePickerSetting.dateMode
            /// set currentDate to the default
            selectedDate = datePickerSetting.date
   
        }
    }
    
    //只有一列的时候用到的属性
    fileprivate var singleDoneOnClick:SingleDoneAction? = nil{
        didSet{
            toolBar.doneAction = {[weak self] in
                self?.singleDoneOnClick?((self?.selectedIndex)!, (self?.selectedValue)!)
            }
        }
    }
    
    fileprivate var dateDoneAction: DateDoneAction? {
        didSet {
            toolBar.doneAction = {[unowned self] in
                self.dateDoneAction?(self.selectedDate)
                
            }
        }
    }

    
    fileprivate var defalultSelectedIndex: Int? = nil{
        didSet{
            guard let defaultIndex = defalultSelectedIndex else { return  }
            guard let singleData = singleColData else { return  }
            assert(defaultIndex >= 0 && defaultIndex < singleData.count, "设置的默认选中Index不合法")
            if defaultIndex >= 0 && defaultIndex < singleData.count{
                // 设置默认值
                selectedIndex = defaultIndex
                selectedValue = singleData[defaultIndex]
                // 滚动到默认位置
                pickerView.selectRow(defaultIndex, inComponent: 0, animated: false)
            }
            else {// 没有默认值设置0行为默认值
                selectedIndex = 0
                selectedValue = singleColData![0]
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            
        }
    }
    
    fileprivate var cancelAction: BtnAction? = nil {
        didSet {
            toolBar.cancelAction = cancelAction
        }
    }

    // MARK:- 日期选择器用到的属性
    fileprivate var selectedDate = Date() {
        didSet{
            
        }
    }
    
   
    
    public init(pickerStyle:PickerStyles) {
        let frame = CGRect(x: 0.0, y: 0.0, width: Double(ScreenWidth), height: toolBarHeight + pickerViewHeight)
        self.pickerStyle = pickerStyle
        super.init(frame: frame)
        commonInit()
        
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //懒加载
    fileprivate lazy var toolBar:ToolBarView! = ToolBarView()
    
    fileprivate lazy var pickerView:UIPickerView! = {[weak self] in
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        return picker
        }()
    
    
    fileprivate lazy var datePicker:UIDatePicker = {[unowned self] in
        let datePic = UIDatePicker()
        datePic.backgroundColor = UIColor.white
        datePic.locale = Locale(identifier: "zh_CN")
        return datePic
        
    }()
}

//MARK：－ 创建界面
extension PickerView{
    fileprivate func commonInit(){
        addSubview(toolBar)
        
        if pickerStyle == .date {
            datePicker.addTarget(self, action: #selector(self.dateDidChang(_:)), for: .valueChanged)
            addSubview(datePicker)
        }else
        {
            addSubview(pickerView)
        }
    }
    
     override open func layoutSubviews() {
        super.layoutSubviews()
        
        let toolBarX = NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let toolBarY = NSLayoutConstraint(item: toolBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let toolBarW = NSLayoutConstraint(item: toolBar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        let toolBarH = NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(toolBarHeight))
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([toolBarX,toolBarY,toolBarW,toolBarH])
        
        if pickerStyle == PickerStyles.date {
            let pickerX = NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let pickerY = NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CGFloat(toolBarHeight))
            let pickerW = NSLayoutConstraint(item: datePicker, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
            let pickerH = NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(pickerViewHeight))
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([pickerX, pickerY, pickerW, pickerH])

        }else
        {
            let pickerX = NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let pickerY = NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: CGFloat(toolBarHeight))
            let pickerW = NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
            let pickerH = NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(pickerViewHeight))
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraints([pickerX, pickerY, pickerW, pickerH])
        }
    }
    
    func dateDidChang(_ datePic:UIDatePicker) {
        selectedDate = datePic.date
    }
}

//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension PickerView: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerStyle {
        case .single:
            return singleColData == nil ? 0 : 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerStyle {
        case .single:
            return singleColData?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.backgroundColor = UIColor.clear
        
        label.text = titleForRow(row, forComponent: component)
        return label

    }
    
    fileprivate func titleForRow(_ row: Int, forComponent component: Int) -> String?{
        switch pickerStyle {
        case .single:
            return singleColData?[row]
        default:
            return nil
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerStyle {
        case .single:
            selectedIndex = row
            selectedValue = singleColData![row]
        default:
            return
        }
    }
}

//MARK: 快速使用方法
extension PickerView {
    /// 单列
    public class func singleColPickerView(_ toolBarTitle: String, singleColData: [String], defaultIndex: Int?,cancelAction: BtnAction?, doneAction: SingleDoneAction?) -> PickerView{
        
        let picker = PickerView(pickerStyle: .single)
        picker.toolBarTitle = toolBarTitle
        picker.singleColData = singleColData
        picker.defalultSelectedIndex = defaultIndex
        picker.singleDoneOnClick = doneAction
        picker.cancelAction = cancelAction
        return picker
    }
    
    /// 时间选择器
    public class func datePicker(_ toolBarTitle: String, datePickerSetting: DatePickerSetting, cancelAction: BtnAction?, doneAction: DateDoneAction?) -> PickerView {
        
        let pic = PickerView(pickerStyle: .date)
        pic.datePickerSetting = datePickerSetting
        pic.toolBarTitle = toolBarTitle
        pic.cancelAction = cancelAction
        pic.dateDoneAction = doneAction
        return pic
        
    }
}





