//
//  ViewController.swift
//  XFPickerViewDemo
//
//  Created by zyz on 17/2/28.
//  Copyright © 2017年 科大讯飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let singleData = ["男", "女"]
        
        XFPickerView.showSingleColPicker("性别选择", data: singleData, defalutSelectedIndex: 0, doneAction: {(selectedIndex, selectedValue) in
            
        })
        
    }


}

