import Foundation

extension String {
    
    var substr: Substring {
        return self[self.startIndex...]
    }
}
