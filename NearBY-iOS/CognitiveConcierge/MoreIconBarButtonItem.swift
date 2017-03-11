/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/


import Foundation
import UIKit

class MoreIconBarButtonItem: UIBarButtonItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        setupMoreIconButton()
    }
    
       func goToMore() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendFeedLogin"), object:nil)
       }
    
    private func getMoreIconButton() -> UIButton {
        let moreIconButton = UIButton()
        moreIconButton.setImage(UIImage(named: "moreIcon"), for: .normal)
        moreIconButton.addTarget(self, action: #selector(MoreIconBarButtonItem.goToMore), for: .touchUpInside)
        moreIconButton.frame = CGRect(x: 343, y: 43.5, width: 16, height: 4)
        moreIconButton.tintColor = UIColor.customGetMoreIconButtonColor()
        return moreIconButton
    }
    
    private func setupMoreIconButton() {
        self.customView = getMoreIconButton()
    }
}
