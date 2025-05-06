import React, { useState } from "react";
import { Send } from "lucide-react";
import { messages } from "@/data/chat";

const ClubChatTab: React.FC = () => {
  const [newMessage, setNewMessage] = useState("");

  const handleSendMessage = () => {
    if (newMessage.trim()) {
      // In a real app, this would send the message to a server
      console.log("Sending message:", newMessage);
      setNewMessage("");
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  return (
    <div className="bg-blue-800/90 rounded-xl p-4 mt-2 md:h-[57.5vh] shadow-lg flex flex-col h-[600px]">
      <h2 className="text-xl font-bold mb-4">Club Chat</h2>
      <div className="md:h-[50vh] overflow-auto scrollbar">
        <div className="flex-1 overflow-y-auto mb-4 space-y-4">
          {messages.map((message) => (
            <div key={message.id} className="flex items-start gap-3">
              <div className="w-8 h-8 bg-gray-300 rounded-full flex-shrink-0"></div>
              <div>
                <div className="flex items-baseline gap-2">
                  <span className="font-semibold">{message.sender}</span>
                  <span className="text-xs text-blue-300">{message.time}</span>
                </div>
                <p className="text-sm">{message.content}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="flex gap-2">
        <input
          type="text"
          className="flex-1 bg-white text-black text-sm placeholder:text-sm rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-400"
          placeholder="Type a message..."
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
          onKeyDown={handleKeyPress}
        />
        <button
          className="bg-blue-500 hover:bg-blue-600 text-white px-4 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          onClick={handleSendMessage}
          disabled={!newMessage.trim()}
        >
          <Send size={20} />
        </button>
      </div>
    </div>
  );
};

export default ClubChatTab;
