//
//  Listener.swift
//  aubrey
//
//  Created by samara on 8/29/23.
//

import Foundation
import Discord
import OSLog
import BotConfig

class MyListener: EventListener {
    let logger: Logger
    
    init(name: String, logger: Logger) {
        self.logger = logger
        super.init(name: name)
    }
    
    override func onMessageCreate(message: Message) async {
        guard !message.author.isBot else {
            return
        }
        //if message.author.id == owner {
//            let randomNumber = Int.random(in: 1...100)
//            if randomNumber == 1 {
//                
//                do {
//                    try await message.channel.send("meow"
//                                                   //, reference: message.asReference
//                    )
//                } catch {
//                    logger.error("Failed to send message: \(error, privacy: .public)")
//                }
//            }
//        //}


        switch message.content {
            
        case "[ping]":
            do {
                let start = DispatchTime.now()
                let sentMessage = try await message.channel.send("Pinging...")
                
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let latencyMS = Double(nanoTime) / 1_000_000
                
                let pingResponse = "Pong! Latency: \(latencyMS)ms"
                
                try await sentMessage.edit(.content(pingResponse))
                try await message.delete()
                logger.info("Ping response edited: \(pingResponse, privacy: .public)")
            } catch {
                logger.error("Failed to perform ping operation: \(error, privacy: .public)")
            }
        case "[meow]":
            do {
                try await message.channel.send("meow")
            } catch {
                logger.error("W>>>>e: \(error, privacy: .public)")
            }
        case "[help]":
            do {
                try await message.channel.send("""
                                               ```
                                               Things that the bot listens to:
                                               [meow]                           Meow
                                               [ping]                           Pong!
                                               [help]                           Sends this message
                                               [sync]                           Syncs slash commands (discord.swift sucks sometims) [needs bot owner]
                                               [disconnect]                     Disconnects the bot from discord [needs bot owner]
                                               [test]                           For testing [needs bot owner]
                                               
                                               
                                               Slash commands:
                                               /say <message> <attachments>     Sends message through the bot including attachments if any
                                               /compliment <mention>            Sends a compliment either to you or an oomfie you mentioned
                                               /me                              You
                                               ```
                                               """
                )
            } catch {
                logger.error("W>>>>e: \(error, privacy: .public)")
            }
        case "[sync]":
            if message.author.id == owner {
                do {
                    try await bot.syncApplicationCommands()
                    logger.info("Synced slash commands.")
                    
                    try await message.delete()
                } catch {
                    logger.error("Failed to sync: \(error, privacy: .public)")
                }
            }
        case "[disconnect]":
            if message.author.id == owner {
                do {
                    try await message.delete()
                } catch {
                    logger.error("Failed to delete: \(error, privacy: .public)")
                }
                logger.info("Disconnected.")

                bot.disconnect()
                exit(0)
            }
        case "[test]":
            if message.author.id == owner {
//                do {
//                    try await bot.http.deleteApplicationCommand(botId: 1109206230775378030, commandId: 1146303923838271538, guildId: nil)
//                } catch {
//                    logger.error("Failed to del: \(error, privacy: .public)")
//                }
                exit(0)
            }

        default:
            break
        }
    }
}

