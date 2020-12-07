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
    
    // MARK: - Views
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
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
        
        // Delegates
        scrollView.delegate = self

        title = "Image"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissSelf))
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissSelf))
        swipe.direction = .down
        scrollView.addGestureRecognizer(swipe)
        
        
        scrollView.contentSize = imageView.bounds.size
        
    }
    
    override func viewWillLayoutSubviews() {
        configureLayout()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    @objc private func doubleTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateMinZoomScaleForSize(self.view.bounds.size)
        })
    }
    
    /// This method calculates the zoom scale for the scroll view.
    /// A zoom scale of 1 indicates that the content displays at its normal size.
    /// A zoom scale of less than 1 shows a zoomed-out version of the content, and a zoom scale greater than 1 shows the content zoomed in.
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        print("zoomScale: \(minScale)")
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureLayout() {
        // Scroll view
        let scrollViewConstraints = [scrollViewTopConstraint, scrollViewBottomConstraint, scrollViewLeadingConstraint, scrollViewTrailingConstraint]
        NSLayoutConstraint.activate(scrollViewConstraints)
        // Image view
        let imageConstraints = [imageViewTopConstraint, imageViewBottomConstraint, imageViewLeadingConstraint, imageViewTrailingConstraint]
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    
    // MARK: - Constraints
    
    // imageView constraints
    lazy var imageViewTopConstraint = NSLayoutConstraint(
        item: imageView,
        attribute: .top,
        relatedBy: .equal,
        toItem: scrollView,
        attribute: .top,
        multiplier: 1,
        constant: 0
    )
    lazy var imageViewBottomConstraint = NSLayoutConstraint(
        item: imageView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: scrollView,
        attribute: .bottom,
        multiplier: 1,
        constant: 0
    )
    lazy var imageViewLeadingConstraint = NSLayoutConstraint(
        item: imageView,
        attribute: .leading,
        relatedBy: .equal,
        toItem: scrollView,
        attribute: .leading,
        multiplier: 1,
        constant: 0
    )
    lazy var imageViewTrailingConstraint = NSLayoutConstraint(
        item: imageView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: scrollView,
        attribute: .trailing,
        multiplier: 1,
        constant: 0
    )
    
    // scrollView constraints
    lazy var scrollViewTopConstraint = NSLayoutConstraint(
        item: scrollView,
        attribute: .top,
        relatedBy: .equal,
        toItem: view,
        attribute: .top,
        multiplier: 1,
        constant: 0
    )
    lazy var scrollViewBottomConstraint = NSLayoutConstraint(
        item: scrollView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: view,
        attribute: .bottom,
        multiplier: 1,
        constant: 0
    )
    lazy var scrollViewLeadingConstraint = NSLayoutConstraint(
        item: scrollView,
        attribute: .leading,
        relatedBy: .equal,
        toItem: view,
        attribute: .leading,
        multiplier: 1,
        constant: 0
    )
    lazy var scrollViewTrailingConstraint = NSLayoutConstraint(
        item: scrollView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: view,
        attribute: .trailing,
        multiplier: 1,
        constant: 0
    )
}

// MARK: - UIScrollViewDelegate

extension ReminderImageViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

// MARK: - UIViewControllerRepresentable

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



