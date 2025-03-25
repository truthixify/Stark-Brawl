import { ReactNode } from 'react';
import ShopNavigationTabs from './ShopNavigationTabs';


interface ShopLayoutProps {
    children: ReactNode;
}

const ShopLayout = ({ children }: ShopLayoutProps) => {
    return (
        <div className="flex flex-col min-h-screen bg-gray-900">
            <div className="container mx-auto px-4 py-8">
                <h1 className="text-4xl font-bold text-white mb-8">Shop</h1>
                <ShopNavigationTabs />
                <div className="mt-8">
                    {children}
                </div>
            </div>
        </div>
    );
};

export default ShopLayout; 