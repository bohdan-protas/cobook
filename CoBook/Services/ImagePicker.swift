//
//  ImagePicker.swift
//  CoBook
//
//  Created by protas on 4/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CropViewController

public protocol ImagePickerDelegate: class {
    func imagePicker(_ picker: ImagePicker, didSelectImage image: UIImage)
}

// MARK: - ImagePicker

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController!
    private weak var cropController: CropViewController?

    /// Image picker controller delegation object
    weak var delegate: ImagePickerDelegate?

    /// Flag that define if need to use crop controller
    var allowsEditing: Bool = false

    var cropViewControllerAspectRatioPreset: CropViewControllerAspectRatioPreset?
    var cropViewControllerCustomAspectRatio: CGSize?

    /// Callback fired when image is selected and cropped if needed
    var onImagePicked: ((UIImage) -> Void)?

    /// Dismiss view, where crop controller animeted returns
    private var dismissView: UIView?

    // MARK: Object Life Cycle

    public init(presentationController: UIViewController, allowsEditing: Bool = false) {
        self.pickerController = UIImagePickerController()
        super.init()

        self.presentationController = presentationController
        self.allowsEditing = allowsEditing

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }

    // MARK: - Public

    public func present(dismissView: UIView? = nil) {
        self.dismissView = dismissView

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Зробити знімок") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Фотоальбом") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Відмінити", style: .cancel, handler: nil))

        self.presentationController?.present(alertController, animated: true)
    }

    // MARK: - Privates

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage) {
        switch self.allowsEditing {

        case true:
            let cropController = CropViewController(croppingStyle: .default, image: image)
            cropController.delegate = self

            if let cropViewControllerAspectRatioPreset = cropViewControllerAspectRatioPreset {
                 cropController.aspectRatioPreset = cropViewControllerAspectRatioPreset
            }

            if let cropViewControllerCustomAspectRatio = cropViewControllerCustomAspectRatio {
                cropController.customAspectRatio = cropViewControllerCustomAspectRatio
            }

            cropController.aspectRatioLockEnabled = true
            cropController.resetAspectRatioEnabled = false
            cropController.aspectRatioPickerButtonHidden = true
            cropController.doneButtonTitle = "Готово"
            cropController.cancelButtonTitle = "Відмінити"

            controller.dismiss(animated: true, completion:  {
                self.presentationController?.present(cropController, animated: true, completion: nil)
            })

        case false:
            controller.dismiss(animated: true, completion: {
                self.delegate?.imagePicker(self, didSelectImage: image)
                self.onImagePicked?(image)
                self.onImagePicked = nil
            })
        }
    }


}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.pickerController(picker, didSelect: image)
    }


}

// MARK: - CropViewControllerDelegate

extension ImagePicker: CropViewControllerDelegate {

    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }

    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        switch dismissView {

        case .none:
            cropViewController.dismiss(animated: true, completion: {
                self.delegate?.imagePicker(self, didSelectImage: image)
                self.onImagePicked?(image)
                self.onImagePicked = nil
            })

        case .some(let view):
            view.isHidden = true
            self.delegate?.imagePicker(self, didSelectImage: image)
            self.onImagePicked?(image)
            self.onImagePicked = nil

            cropViewController.dismissAnimatedFrom(presentationController,
                                                   withCroppedImage: image,
                                                   toView: view,
                                                   toFrame: .zero,
                                                   setup: nil) { () -> (Void) in
                view.isHidden = false
            }
        }

    }


}



