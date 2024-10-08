//
//  MPMusicPlayControl.swift
//  MusicPlay
//
//  Created by Chen guohao on 8/19/24.
//

import Foundation
import UIKit
import MusicKit
import SwiftUI
import Masonry
import SDWebImage
import SDWebImageSwiftUI
import SwiftUI
import Combine
import MediaPlayer
struct MPFloatPlayerView: View {
    
//    @State private var albumCoverUrl: URL?
//    @State private var title: String = ""
//    @State private var artist: String = ""
    
    @ObservedObject var musicPlayerQueue = ApplicationMusicPlayer.shared.queue
    @ObservedObject  private var playerState = ApplicationMusicPlayer.shared.state
    
    @State private var showPlaylist = false
    
    private let player = ApplicationMusicPlayer.shared
    
    private var isPlaying: Bool {
        return (playerState.playbackStatus == .playing)
    }
    private var cancellable: AnyCancellable?
 
 
    private var albumCoverUrl:URL? {
        if let currentEntry = musicPlayerQueue.currentEntry {
            let url =  currentEntry.artwork?.url(width: 100, height: 100)
            return url
        }
        return nil
    }
    
    private var isPlayListAvilable:Bool {
        let entries = musicPlayerQueue.entries
        if entries.count > 0{
            return true
        }
        return false
    }
    
    private var isTrackAvilable:Bool{
        if let currentEntry = musicPlayerQueue.currentEntry {
            return true
        }
        return false
    }
  
    func localImage(url: URL?) -> UIImage? {
        if let sUrl = url , sUrl.scheme == "musicKit" {
            if let data = try? Data(contentsOf: sUrl) {
                return UIImage(data: data)
            }
        }
        return UIImage(named: "mini_logo")
    }
    
    private var title:String {
        if let currentEntry = musicPlayerQueue.currentEntry {
            return  currentEntry.title
           
        }
        return "Melodies"
    }
    
    private var artist:String {
        if let currentEntry = musicPlayerQueue.currentEntry {
            
            return  currentEntry.subtitle ?? ""
            
        }
        return "com.xes"
    }
    
    private var albumTitle:String {
        if let currentEntry = musicPlayerQueue.currentEntry {
            
            switch currentEntry.item {
                case .song(let song):
                    return  song.albumTitle ?? ""
                case .none: break
                case .some(.musicVideo(_)):break
                case .some(_):break
            }
        }
        return "One OK App"
    }
    
    var body: some View {
        HStack(alignment: .center,spacing: 10) {
            Image(uiImage: localImage(url: albumCoverUrl)!)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                Text(artist)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(albumTitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }.padding(.vertical, 2).background(Color.white)

            Spacer()
            Button(action: {
                // Play button action
                isPlaying ? pausePlaying():beginPlaying()
            }) {
                Image(isTrackAvilable ? (isPlaying ? "icon_play_playing" : "icon_play_pause") : "icon_play_disable")
                    .resizable()
                    .frame(width: 40, height: 40)
            }.disabled(!isTrackAvilable)

            Button(action: {
                showPlaylist.toggle()
            }) {
                Image("common_playlist")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                            .clipped()
                    .foregroundColor(isTrackAvilable ? .black : Color.gray.opacity(0.5))
            }.sheet(isPresented: $showPlaylist) {
                PlaylistView(showPlaylist: $showPlaylist).presentationDetents([.medium, .large]) // 设置为半屏(.medium)和全屏(.large)
                    .presentationDragIndicator(.visible)
            }.disabled(!isTrackAvilable)
        }
        .padding(.horizontal, 10).background(Color.white)
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
    
    private func pausePlaying() {
        Task {
            do {
                try await player.pause()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }
}
 
@objc
class FloatPlayerSwiftUI:NSObject{
    @objc
    public static func makeSwiftUIViewController() -> UIViewController {
        return UIHostingController(rootView: MPFloatPlayerView())
    }
}
 
struct PlaylistView: View {
    @ObservedObject var musicPlayerQueue = ApplicationMusicPlayer.shared.queue
    @Binding var showPlaylist: Bool
     
    // 模拟的播放列表
    private var playlist: ApplicationMusicPlayer.Queue.Entries {
        print("cur \(String(describing: musicPlayerQueue.currentEntry?.title))")
        return musicPlayerQueue.entries
    }
    
    var body: some View {
        NavigationView {
            List(playlist, id: \.self) { entity in
                
                Button(action: {
                                   // 处理点击事件，比如设置当前播放项
                    handleSelection(entity: entity)
                }) {
                    HStack {
                        
                        
                        Text("\(entity.title) - \(entity.subtitle ?? "")")
                            .lineLimit(1) // 限定显示 1 行
                            .truncationMode(.middle)
                            .foregroundColor(isCurrent(entity: entity) ? Color(hex: "#74c69d") : Color.black) // 当前播放的条目使用红色字体
                        Spacer()
                        
                        if case let .song(song) = entity.item {
                            Text("\(formatDuration(song.duration))")
                                .font(.system(size: 14))
                                .foregroundColor(isCurrent(entity: entity)  ? Color(hex: "#74c69d") : Color.gray) // 当前播放的条目用红色，其他条目用灰色
                        }
                    }}
                
            }
            .navigationTitle("Playlist")
            .navigationBarItems(trailing: Button(action: {
                // 关闭视图的操作
                showPlaylist = false
            }) {
                Image(systemName: "chevron.down").foregroundColor(Color(hex: "#2d6a4f"))
            })
        }
    }
    func handleSelection(entity:MusicKit.MusicPlayer.Queue.Entry) {
        if( musicPlayerQueue.currentEntry?.item?.id != entity.item?.id){
            ApplicationMusicPlayer.shared.queue.currentEntry = entity
            Task {
                do {
                    try await ApplicationMusicPlayer.shared.play()
                } catch {
                    print("Failed to prepare to play with error: \(error).")
                }
            }
                    // 实现播放功能
//            ApplicationMusicPlayer.shared.state.playbackStatus = .playing
        }
    }
    func isCurrent(entity:MusicKit.MusicPlayer.Queue.Entry) -> Bool{
        return  musicPlayerQueue.currentEntry?.item?.id == entity.item?.id
    }
    
    func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "00:00" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


 

 
