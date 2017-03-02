# XFPickerView
Swift3.0  封装的UIPickView
##  1 快速使用方法
### 单列选择器
#### 
public class func showSingleColPicker(_ toolBarTitle:String, data: [String], defalutSelectedIndex:Int?,doneAction:SingleDoneAction?)

### 2 多列选择器
#### 2.1 日期选择器
 public class func showDatePicker(_ toolBarTitle:String,datePickerSetting:DatePickerSetting = DatePickerSetting(),doneAction:DateDoneAction?)
