

import Foundation

extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    
    public func dequeueCell<T: UICollectionViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type) {
        
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
