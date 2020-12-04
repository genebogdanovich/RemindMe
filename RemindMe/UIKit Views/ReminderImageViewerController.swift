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
    
    // Image view constraints
    lazy var imageViewTopConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0)
    lazy var imageViewBottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
    lazy var imageViewLeadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
    lazy var imageViewTrailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
    
    // Scroll view constraints
    lazy var scrollViewTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
    lazy var scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    lazy var scrollViewLeadingConstraint = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
    lazy var scrollViewTrailingConstraint = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    
    
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
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
        configureLayout()
        updateZoomScale()
        updateConstraintsForSize(view.bounds.size)
        
    }
    
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
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
        imageViewTopConstraint.constant = yOffset - topBarHeight
        imageViewBottomConstraint.constant = yOffset - topBarHeight
        
        let horizontalSpace = size.width - imageView.frame.width
        
        
        
        let xOffset = max(0, horizontalSpace / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
    }
    
    private func configureLayout() {
        // Scroll view
        let scrollViewConstraints = [scrollViewTopConstraint, scrollViewBottomConstraint, scrollViewLeadingConstraint, scrollViewTrailingConstraint]
        NSLayoutConstraint.activate(scrollViewConstraints)
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

