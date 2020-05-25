/// Copyright © 2020 Oliver Lau <oliver@ersatzworld.net>

import Foundation
import UIKit

protocol RepsCollectionViewCellLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, sizeAtIndexPath indexPath: IndexPath) -> CGSize
}

class RepCollectionViewCellLayout: UICollectionViewLayout {
    weak var delegate: RepsCollectionViewCellLayoutDelegate?

    private let cellPadding: CGFloat = 6
    private let cellWidth: CGFloat = 130
    private let cellHeight: CGFloat = 70
    private var layoutCache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        let numberOfColumns: Int = Int(contentWidth / cellWidth)
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var column: Int = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let cellSize = delegate?.collectionView(collectionView, sizeAtIndexPath: indexPath) ?? CGSize(width: cellWidth, height: cellHeight)
            let frame = CGRect(x: CGFloat(column) * columnWidth,
                               y: yOffset[column],
                               width: cellSize.width,
                               height: cellSize.height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutCache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += cellSize.height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in layoutCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutCache[indexPath.item]
    }
}
