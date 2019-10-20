//import Photos
//import MobileCoreServices
//
//// <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@IBAction func showImagePicker(sender: UIButton) {
//    let picker = UIImagePickerController()
//    picker.delegate = self;
//    picker.allowsEditing = false;
//    picker.sourceType = .photoLibrary;
//    picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String];
//
//    present(picker, animated: true, completion: nil);
//}
//
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    guard
//        let livePhoto = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto,
//        let photoDir = generateFolderForLivePhotoResources()
//        else {
//            return;
//    }
//
//    let assetResources = PHAssetResource.assetResources(for: livePhoto)
//    for resource in assetResources {
//
//        // SAVE FROM BUFFER
////            let buffer = NSMutableData()
////            PHAssetResourceManager.default().requestData(for: resource, options: nil, dataReceivedHandler: { (chunk) in
////                buffer.append(chunk)
////            }, completionHandler: {[weak self] error in
////                self?.saveAssetResource(resource: resource, inDirectory: photoDir, buffer: buffer, maybeError: error)
////            })
//
//        // SAVE DIRECTLY
//        saveAssetResource(resource: resource, inDirectory: photoDir, buffer: nil, maybeError: nil)
//    }
//
//    picker.dismiss(animated: true) {}
//}
//
//func saveAssetResource(
//    resource: PHAssetResource,
//    inDirectory: NSURL,
//    buffer: NSMutableData?, maybeError: Error?
//    ) -> Void {
//    guard maybeError == nil else {
//        print("Could not request data for resource: \(resource), error: \(String(describing: maybeError))")
//        return
//    }
//
//    let maybeExt = UTTypeCopyPreferredTagWithClass(
//        resource.uniformTypeIdentifier as CFString,
//        kUTTagClassFilenameExtension
//        )?.takeRetainedValue()
//
//    guard let ext = maybeExt else {
//        return
//    }
//
//    guard var fileUrl = inDirectory.appendingPathComponent(NSUUID().uuidString) else {
//        print("file url error")
//        return
//    }
//
//    fileUrl = fileUrl.appendingPathExtension(ext as String)
//
//    if let buffer = buffer, buffer.write(to: fileUrl, atomically: true) {
//        print("Saved resource form buffer \(resource) to filepath \(String(describing: fileUrl))")
//    } else {
//        PHAssetResourceManager.default().writeData(for: resource, toFile: fileUrl, options: nil) { (error) in
//            print("Saved resource directly \(resource) to filepath \(String(describing: fileUrl))")
//        }
//    }
//}
//
//func generateFolderForLivePhotoResources() -> NSURL? {
//    let photoDir = NSURL(
//        // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
//        fileURLWithPath: NSTemporaryDirectory(),
//        isDirectory: true
//        ).appendingPathComponent(NSUUID().uuidString)
//
//    let fileManager = FileManager()
//    // we need to specify type as ()? as otherwise the compiler generates a warning
//    let success : ()? = try? fileManager.createDirectory(
//        at: photoDir!,
//        withIntermediateDirectories: true,
//        attributes: nil
//    )
//
//    return success != nil ? photoDir! as NSURL : nil
//}
