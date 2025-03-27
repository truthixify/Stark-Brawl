import { useState } from 'react';
import { FriendRequest } from '../types/friend';
import { FriendRequestCard } from './FriendRequestCard';
import { mockFriendRequests } from '../mocks/friendRequests';

export const FriendRequestsList = () => {
  const [requests, setRequests] = useState<FriendRequest[]>(mockFriendRequests);

  const handleAccept = async (id: string) => {
    // In a real app, you would make an API call here
    await new Promise((resolve) => setTimeout(resolve, 500));
    setRequests((prev) => prev.filter((request) => request.id !== id));
  };

  const handleDecline = async (id: string) => {
    // In a real app, we would make an API call here
    await new Promise((resolve) => setTimeout(resolve, 500));
    setRequests((prev) => prev.filter((request) => request.id !== id));
  };

  return (
    // This first parent div should be removed as it is assumed that the layout would have this background color
    // This was put there to show the background color of the page
    <div className='bg-[#591c85] w-full'>
      <div className='w-full p-4'>
        {/* This is also temporary  as it just shows the decrementing number of friend requests */}
        {/* The layout is not yet implemented so the friend requests tab is not visible, to make such implementation */}
        <div className='mb-6'>
          <h2 className='text-2xl font-bold text-white'>
            Friend Requests ({requests.length})
          </h2>
        </div>

        <div className='space-y-4'>
          {requests.map((request) => (
            <FriendRequestCard
              key={request.id}
              request={request}
              onAccept={handleAccept}
              onDecline={handleDecline}
            />
          ))}
        </div>
      </div>
    </div>
  );
};
