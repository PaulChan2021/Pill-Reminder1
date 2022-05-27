//
//  BotResponse.swift
//  Pill-Reminder
//
//  Created by mac on 20/5/2022.
//

import Foundation

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("Hello") {
        return "Hello!"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later!"
    } else if tempMessage.contains("how are you") {
        return "I'm fine, how about you?"
    } else if tempMessage.contains("hello") {
        return "Hello! What can I help you?"
    } else if tempMessage.contains("How to keep fit") {
        return "Eat a well-balanced, low-fat diet with lots of fruits, vegetables and whole grains."
    } else if tempMessage.contains("hi") {
        return "Hello! What can I help you?"
    } else if tempMessage.contains("hey") {
        return "Hey there"
    } else if tempMessage.contains("hey there") {
        return "Hey"
    } else if tempMessage.contains("greetings") {
        return "Greetings! How can I assist?"
    } else if tempMessage.contains("greeting") {
        return "Greetings! How can I assist?"
    } else if tempMessage.contains("how are you?") {
        return "Good day! What can I do for you?"
    } else if tempMessage.contains("I'm sick") {
        return "You should go to a doctor!"
    } else if tempMessage.contains("I am tired") {
        return "If you feel tired, you can take a rest or play game!"
    } else if tempMessage.contains("Who are you?") {
        return "I am a healthcare bot! What can I help you?"
    } else if tempMessage.contains("Who are you") {
        return "I am a healthcare bot! What can I help you?"
    } else if tempMessage.contains("How to keep fit?") {
        return "Eat a well-balanced, low-fat diet with lots of fruits, vegetables and whole grains. Choose a diet that's low in saturated fat and cholesterol, and moderate in sugar, salt and total fat and be physically active for 30 minutes most days of the week"
    } else {
        return "I missed what you said. What was that?"
    }
}


