import React from "react";

interface ReplayModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

const ReplayModal: React.FC<ReplayModalProps> = ({ open, onClose, title, children }) => {
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-60">
      <div className="bg-white rounded-lg shadow-lg p-6 min-w-[300px] max-w-[90vw]">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-bold text-blue-900">{title}</h2>
          <button onClick={onClose} className="text-blue-900 font-bold text-xl">×</button>
        </div>
        <div>{children}</div>
      </div>
    </div>
  );
};

export default ReplayModal; 