//
//  Utils.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-03.
//

import UIKit

class Utils {
    static func saveImageToDocumentDirectory(filename: String, jpegData: Data) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(atPath: fileURL.path)
        }
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try jpegData.write(to: fileURL)
                print("JPEG saved to \(fileURL)")
                return fileURL
            } catch {
                print("error saving file: \(fileURL)", error)
            }
        }
        return nil
    }
}
