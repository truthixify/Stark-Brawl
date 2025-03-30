import React from 'react';

type FeatureCardProps = {
  name: string;
  icon: string;
  color: string;
};

export const FeatureCard: React.FC<FeatureCardProps> = ({ name, icon, color }) => {
  return (
    <div className="flex flex-col items-center p-3 rounded-lg bg-gray-700 border border-gray-600">
      <div className={`w-12 h-12 rounded-full flex items-center justify-center mb-2 ${color}`}>
        <img src={icon} alt={name} className="w-6 h-6" />
      </div>
      <span className="text-sm text-white text-center">{name}</span>
    </div>
  );
};
