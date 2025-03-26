import React, { useState } from 'react'

const FriendsList = () => {
  const [selectedFriend, setSelectedFriend] = useState<number | null>(null);
  const [likedFriends, setLikedFriends] = useState<boolean[]>(Array(7).fill(false));

  const friends = [
    { name: 'CryptoKing', status: 'Online', points: 32.450, clan: 'Crypto Warriors', level: 150, image: '/nft4.png' },
    { name: 'NFTHunter', status: 'In Game', points: 31.280, clan: 'Token Masters', level: 145, image: '/nft2.png' },
    { name: 'BlockchainInBeast', status: 'Online', points: 30.150, clan: 'Crypto Warriors', level: 142, image: '/nft5.png' },
    { name: 'StarknetPro', status: 'Online', points: 29.870, clan: 'L2 Legends', level: 138, image: '/nft3.png' },
    { name: 'TokenMaster', status: 'Offline (3h ago)', points: 28.950, clan: 'Token Masters', level: 135, image: '/nft1.png' },
    { name: 'ZKRollup', status: 'Offline (1d ago)', points: 14.320, clan: 'L2 Legends', level: 39, image: '/nft4.png' },
    { name: 'CryptoNoob', status: 'Away', points: 12.450, clan: 'Token Masters', level: 35, image: '/nft2.png' },
  ];

  const toggleLike = (index: number) => {
    const newLikedFriends = [...likedFriends];
    newLikedFriends[index] = !newLikedFriends[index];
    setLikedFriends(newLikedFriends);
  };

  return (
    <div className="flex flex-wrap">
      {friends.map((friend, index) => (
        <div key={index} className={`w-full sm:w-1/2 md:w-1/3 p-2`}>
          <div 
            className={`bg-purple-800 p-4 rounded-xl flex flex-col border ${selectedFriend === index ? 'border-orange-500' : 'border-[#5a0573c2]'}`} 
            onClick={() => setSelectedFriend(index)}
          >
            <div className="flex items-center">
              <img src={friend.image} alt={`${friend.name} avatar`} className="w-12 h-12 rounded-full mr-2" />
              <div className="flex flex-col w-full">
                <div className="flex items-center justify-between">
                  <h3 className="text-white font-bold">{friend.name}</h3>
                  <button onClick={() => toggleLike(index)} className="ml-2">
                    {likedFriends[index] ? (
                      <svg className="w-5 h-5 text-orange-500" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 015.656 5.656l-6.364 6.364a1 1 0 01-1.414 0l-6.364-6.364a4 4 0 010-5.656z" />
                      </svg>
                    ) : (
                      <svg className="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
                      </svg>
                    )}
                  </button>
                </div>
                <div className="flex items-center">
                  <span className={`w-3 h-3 rounded-full mr-2 ${friend.status === 'Online' ? 'bg-green-500' : friend.status === 'In Game' ? 'bg-blue-500' : friend.status === 'Away' ? 'bg-orange-500' : 'bg-gray-500'}`}></span>
                  <span className="text-gray-300 text-sm">{friend.status}</span>
                </div>
              </div>
            </div>
            <div className="text-white mt-2">
              <div className="flex justify-between items-center">
                <p className="flex items-center">
                  <img src="/trophy.png" alt="Trophy" className="w-4 h-4 mr-1 filter brightness-0 invert" />
                  {friend.points.toFixed(3)}
                </p>
                <p className="flex items-center">
                  <svg className="w-2 h-2 mr-1" fill="none" stroke="orange" strokeWidth={2} viewBox="0 0 20 20">
                    <path d="M10 15.27L16.18 19l-1.64-7.03L20 7.24l-7.19-.61L10 0 7.19 6.63 0 7.24l5.46 4.73L3.82 19z" />
                  </svg> Level {friend.level}
                </p>
              </div>
              <p className='flex items-center bg-[#5a0573c2] rounded-lg mt-1 p-1'> <img src="/security.png" alt="security" className='w-4 h-4 mr-1 filter brightness-0 invert' />Clan: {friend.clan}</p>
            </div>
            <div className="flex gap-2 mt-4 justify-between">
              <button className="bg-blue-500 text-white px-4 py-2 rounded flex items-center"> 
                <img src="/comment.png" alt="message" className='w-4 h-4 mr-1 filter brightness-0 invert' />Message
              </button>
              <button className="bg-green-500 text-white px-4 py-2 rounded ml-auto flex items-center">
                <img src="/user.png" alt="add-user" className='w-4 h-4 mr-1 filter brightness-0 invert' />Invite
              </button>
            </div>
          </div>
        </div>
      ))}
    </div>
  )
}

export default FriendsList 