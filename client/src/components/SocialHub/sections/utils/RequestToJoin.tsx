import React from "react";

interface Props {
	status: string;
}
const RequestToJoin = ({ status }: Props) => {
	return (
		<button className="w-max bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors flex items-center justify-center space-x-2">
			<span>📤</span>
			<span>Request to Join</span>
		</button>
	);
};

export default RequestToJoin;
