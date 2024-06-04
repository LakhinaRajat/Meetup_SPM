//
//  FileModel.swift
//  LoktantramMeetup
//
//  Created by Rajat Lakhina on 16/10/23.
//

import Foundation

public enum FileType: String {
    // Images
    case pngImage = "image/png"
    case jpegImage = "image/jpeg"
    case jpgImage = "image/jpg"
    case gifImage = "image/gif"
    case bmpImage = "image/bmp"
    case tiffImage = "image/tiff"
    case webpImage = "image/webp"
    case svgImage = "image/svg+xml"
    
    // Document
    case pdfDocument = "application/pdf"
    case docxDocument = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case pptDocument = "application/vnd.ms-powerpoint"
    case xlsDocument = "application/vnd.ms-excel"
    case txtDocument = "text/plain"
    case rtfDocument = "application/rtf"
    case csvDocument = "text/csv"
    case docDocument = "application/msword"
    case pptxDocument = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case xlsxDocument = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    
    // Videos
    case mp4Video = "video/mp4"
    case aviVideo = "video/x-msvideo"
    case mkvVideo = "video/x-matroska"
    case movVideo = "video/quicktime"
    case wmvVideo = "video/x-ms-wmv"
    
    // Audio
    case mp3Audio = "audio/mpeg"
    case wavAudio = "audio/wav"
    case oggAudio = "audio/ogg"
    case flacAudio = "audio/flac"
    case aacAudio = "audio/aac"
}

public struct MultiMediaAttachmentFile {
    public let fieldName: String
    public let fileName: String
    public let mimeType: FileType
    public let data: Data
    public let md5Token: String
    
    public init(fieldName: String, fileName: String, mimeType: FileType, data: Data, md5Token: String) {
        self.fieldName = fieldName
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
        self.md5Token = md5Token
    }
}

// example let file = File(fieldName: "image", fileName: "image.jpg", mimeType: "image/jpeg", data: imageData)
