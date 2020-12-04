//
//  ReminderImageViewerController.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 2.12.20.
//

import Foundation
import SwiftUI
import UIKit

class ReminderImageViewerController: UIViewController {
    var image: UIImage!
    
    lazy var imageViewTopConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0)
    lazy var imageViewBottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
    lazy var imageViewLeadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
    lazy var imageViewTrailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
    
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = image
        view.sizeToFit()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissSelf))
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
        configureLayout()
        updateZoomScale()
        updateConstraintsForSize(view.bounds.size)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    // When an image loads, it's gonna be zoomed out.
    private func updateZoomScale() {
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
    }
    
    var minZoomScale: CGFloat {
        let viewSize = view.bounds.size
        let widthScale = viewSize.width / imageView.bounds.width
        let heightScale = viewSize.height / imageView.bounds.height
        
        return min(widthScale, heightScale)
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        let verticalSpace = size.height - imageView.frame.height
        
        let yOffset = max(0, verticalSpace / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let horizontalSpace = size.width - imageView.frame.width
        
        
        
        let xOffset = max(0, horizontalSpace / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
    }
    
    private func configureLayout() {
        // Scroll view
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        // Image view
        let imageConstraints = [imageViewTopConstraint, imageViewBottomConstraint, imageViewLeadingConstraint, imageViewTrailingConstraint]
        NSLayoutConstraint.activate(imageConstraints)
    }
}

extension ReminderImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
        
//        if scrollView.zoomScale < minZoomScale {
//            dismiss(animated: true, completion: nil)
//        }
    }
}


struct ReminderImageViewerControllerWrapper: UIViewControllerRepresentable {
    let image: UIImage
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = ReminderImageViewerController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.image = image
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

