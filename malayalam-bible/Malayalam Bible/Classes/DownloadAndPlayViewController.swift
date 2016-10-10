//
//  DownloadAndPlayViewController.swift
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 19/06/16.
//
//

import UIKit
import MediaPlayer


@objc class DownloadAndPlayViewController: UIViewController {
    var activeDownloads = [String: Download]()
    
    // 1
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    // 2
    var dataTask: URLSessionDataTask?
    var searchResults = [Track]()
    @IBOutlet weak var tableView: UITableView!
    
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let userPasswordString = "bible:godbless"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        let authString = "Basic \(base64EncodedCredential)"
        configuration.httpAdditionalHeaders = ["Authorization" : authString]
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResults.append(Track(name: "Psalms 1", artist: "David", previewUrl: "http://jeesmon.csoft.net/audio-bible/malayalam/psalm/chapter1.mp3"))

        tableView.tableFooterView = UIView()
        _ = self.downloadsSession
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Download methods
    
    // Called when the Download button for a track is tapped
    func startDownload(_ track: Track) {
        if let urlString = track.previewUrl, let url =  URL(string: urlString) {
            // 1
            let download = Download(url: urlString)
            // 2
            download.downloadTask = downloadsSession.downloadTask(with: url)
            // 3
            download.downloadTask!.resume()
            // 4
            download.isDownloading = true
            // 5
            activeDownloads[download.url] = download
        }
    }
    
    // Called when the Pause button for a track is tapped
    func pauseDownload(_ track: Track) {
        if let urlString = track.previewUrl,
            let download = activeDownloads[urlString] {
                if(download.isDownloading) {
                    download.downloadTask?.cancel { data in
                        if data != nil {
                            download.resumeData = data
                        }
                    }
                    download.isDownloading = false
                }
        }
    }
    
    // Called when the Cancel button for a track is tapped
    func cancelDownload(_ track: Track) {
        if let urlString = track.previewUrl,
            let download = activeDownloads[urlString] {
                download.downloadTask?.cancel()
                activeDownloads[urlString] = nil
        }
    }
    
    // Called when the Resume button for a track is tapped
    func resumeDownload(_ track: Track) {
        if let urlString = track.previewUrl,
            let download = activeDownloads[urlString] {
                if let resumeData = download.resumeData {
                    download.downloadTask = downloadsSession.downloadTask(withResumeData: resumeData)
                    download.downloadTask!.resume()
                    download.isDownloading = true
                } else if let url = URL(string: download.url) {
                    download.downloadTask = downloadsSession.downloadTask(with: url)
                    download.downloadTask!.resume()
                    download.isDownloading = true
                }
        }
    }
    
    // This method attempts to play the local file (if it exists) when the cell is tapped
    func playDownload(_ track: Track) {
        if let urlString = track.previewUrl, let url = localFilePathForUrl(urlString) {
            let moviePlayer:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
            presentMoviePlayerViewControllerAnimated(moviePlayer)
        }
    }
    
    // MARK: Download helper methods
    
    // This method generates a permanent local file path to save a track to by appending
    // the lastPathComponent of the URL (i.e. the file name and extension of the file)
    // to the path of the app’s Documents directory.
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        if let url = URL(string: previewUrl)
            {
                let lastPathComponent = url.lastPathComponent
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    // This method checks if the local file exists at the path generated by localFilePathForUrl(_:)
    func localFileExistsForTrack(_ track: Track) -> Bool {
        if let urlString = track.previewUrl, let localUrl = localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
             let path = localUrl.path
                return FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            
        }
        return false
    }
    
    func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in searchResults.enumerated() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }

}

// MARK: - NSURLSessionDelegate

//extension DownloadAndPlayViewController: NSURLSessionDelegate {
//    
//    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
//        if let appDelegate = UIApplication.sharedApplication().delegate as? MalayalamBibleAppDelegate {
//            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//                appDelegate.backgroundSessionCompletionHandler = nil
//                dispatch_async(dispatch_get_main_queue(), {
//                    completionHandler()
//                })
//            }
//        }
//    }
//}


// MARK: - NSURLSessionDownloadDelegate

extension DownloadAndPlayViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // 1
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
            let destinationURL = localFilePathForUrl(originalURL) {
                
                print(destinationURL)
                
                // 2
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(at: destinationURL)
                } catch {
                    // Non-fatal: file probably doesn't exist
                }
                do {
                    try fileManager.copyItem(at: location, to: destinationURL)
                } catch let error as NSError {
                    print("Could not copy file to disk: \(error.localizedDescription)")
                }
        }
        
        // 3
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            activeDownloads[url] = nil
            // 4
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                })
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // 1
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {
                // 2
                download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
                // 3
                let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
                // 4
                if let trackIndex = trackIndexForDownloadTask(downloadTask), let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? TrackCell {
                    DispatchQueue.main.async(execute: {
                        trackCell.progressView.progress = download.progress
                        trackCell.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
                    })
                }
        }
    }
}

// MARK: TrackCellDelegate

extension DownloadAndPlayViewController: TrackCellDelegate {
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            pauseDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            resumeDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            cancelDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            startDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
}

// MARK: UITableViewDataSource

extension DownloadAndPlayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as!TrackCell
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        
        let track = searchResults[(indexPath as NSIndexPath).row]
        
        // Configure title and artist labels
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        var showDownloadControls = false
        if let download = activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: UIControlState())
        }
        cell.progressView.isHidden = !showDownloadControls
        cell.progressLabel.isHidden = !showDownloadControls
        
        // If the track is already downloaded, enable cell selection and hide the Download button
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        cell.downloadButton.isHidden = downloaded || showDownloadControls
        
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension DownloadAndPlayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResults[(indexPath as NSIndexPath).row]
        if localFileExistsForTrack(track) {
            playDownload(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

