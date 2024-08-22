//
//  MusicKitWrapper.swift
//  MusicPlay
//
//  Created by Chen guohao on 8/12/24.
//
import MusicKit
import Foundation
import ReactiveSwift
import SwiftUI
@objc
class MusicKitWrapper :NSObject
{
    @objc
    static let shared = MusicKitWrapper()
   
    @objc var stateChangeHandler: ((Int) -> Void)?
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    private let player = ApplicationMusicPlayer.shared
    
    
    @objc
    func setStateLisener(lisener:((Int) -> Void)?){
        self.stateChangeHandler = lisener
    }
    
    override init() {
        
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: Notification.Name("MusicPlayerStateDidChange"), object: nil)
 

//        player.addObserver(self, forKeyPath: "state", options: [.new], context: nil)

        
//        let cancellable2 = playerState.publisher(for: ApplicationMusicPlayer.shared.state)
//                   .sink { newState in
//                       switch newState {
//                       case .playing:
//                           print("Music is playing")
//                       case .paused:
//                           print("Music is paused")
//                       case .stopped:
//                           print("Music is stopped")
//                       default:
//                           print("Unknown state")
//                       }
//                   }
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    func checkMusicPlayerState() {
        // 每秒查询一次
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let playerState = ApplicationMusicPlayer.shared.state
            
            // 根据 state 进行操作
            switch playerState.playbackStatus {
            case .playing:
                print("Music is playing")
            case .paused:
                print("Music is paused")
            case .stopped:
                print("Music is stopped")
            default:
                print("Unknown state")
            }
            
            // 递归调用自己，继续每秒查询
            self.checkMusicPlayerState()
        }
    }
    
    @objc func playbackStateDidChange(notify : Any){
        
    }

    @objc
    func search( keyword:String) async -> [[String: Any]]{
        var searchRequest = MusicCatalogSearchRequest(term: keyword, types: [Song.self])
        searchRequest.limit = 20
        do{
            let searchResponse = try await searchRequest.response()
            let songsArray: [Song] = Array(searchResponse.songs)
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(songsArray)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] ?? []
            return jsonObject;
        }catch {
            print("Search request failed with error: \(error).")
            
        }
        
        return []
    }
    
    func decodeTracks(from jsonData: Data) -> [Track] {
        let decoder = JSONDecoder()
        do {
            // 将 JSON 数据解码为 [Track] 数组
            let tracks = try decoder.decode([Track].self, from: jsonData)
            return tracks
        } catch {
            print("Error decoding JSON to [Track]: \(error)")
            return []
        }
    }
    @objc
    func playTrack(index:Int,dictArray:[[String: Any]]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dictArray, options: .prettyPrinted)
            let tracks = decodeTracks(from: jsonData)
            
            let track = tracks[index]
            
        
            
            
            player.queue = ApplicationMusicPlayer.Queue(for: tracks, startingAt:track)
            beginPlaying()
//            handleTrackSelected(track, loadedTracks: MusicItemCollection<Track>(tracks))
        }catch{
            
        }
        
        
    }
    
    func convertDictionaryToJSON(dictionary: [String: Any]) -> Data?{
        do {
                // 将 NSDictionary 转换为 JSON 数据
                let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let track = try decoder.decode(Track.self, from: jsonData)
                return jsonData
            } catch {
                print("Error converting dictionary to JSON: \(error)")
                return nil
            }
    }
    
    func handleTrackSelected(_ track: Track, loadedTracks: MusicItemCollection<Track>) {
       
        player.state
////        player.queue = ApplicationMusicPlayer.Queue(for: loadedTracks, startingAt: track)
//        player.queue = ApplicationMusicPlayer.Queue(playlist: loadedTracks, startingAt: track)
//        beginPlaying()
    }
    
    private func beginPlaying() {
        Task {
            do {
                try await player.play()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }
}
