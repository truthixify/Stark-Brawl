import React from 'react'

interface TabProps {
  activeTab: string
  onTabChange: (tab: string) => void
}

const SocialNavigationTabs: React.FC<TabProps> = ({ activeTab, onTabChange }) => {
  const tabs = [
    { id: 'friends', label: 'Friends', notifications: 0, image: '/add-friend.png' },
    { id: 'requests', label: 'Requests', notifications: 3, image: '/add-user.png' },
    { id: 'messages', label: 'Messages', notifications: 2, image: '/comment.png' },
    { id: 'clans', label: 'Clans', notifications: 0, image: '/world-wide-web.png' }
  ]

  return (
    <nav className="flex border border-[#a76dca80] rounded-xl">
      {tabs.map((tab) => (
        <button
          key={tab.id}
          onClick={() => onTabChange(tab.id)}
          className={`text-white w-1/2 py-2 rounded relative transition-all duration-200  
            ${activeTab === tab.id ? 'bg-orange-500 border border-[#a76dca80]' : ' hover:bg-purple-800/50'}`}
        >
          {tab.image && (
            <img 
              src={tab.image} 
              alt={`${tab.label} icon`} 
              className="mr-1 inline w-4 h-4 filter brightness-0 invert" 
            />
          )}
          {tab.label}
          {tab.notifications > 0 && (
            <span className="absolute -top-2 -right-2 bg-red-500 rounded-full w-5 h-5 text-xs flex items-center justify-center">
              {tab.notifications}
            </span>
          )}
        </button>
      ))}
    </nav>
  )
}

export default SocialNavigationTabs 