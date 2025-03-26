import { useState } from 'react';
import ShopTabs from './shop-tabs';
import BannerCarousel from './BannerCarousel';
import { ShoppingCartIcon } from 'lucide-react';

const ShopLayout = () => {
    const [activeTab, setActiveTab] = useState("featured");

    return (
        <div className="min-h-screen bg-[#4A148C] overflow-x-hidden">
            {/* Header */}
            <header className="bg-[#4A148C] p-2 flex justify-between items-center">
                <div className="flex justify-center items-center space-x-2 w-full">
                    <ShoppingCartIcon className="text-white font-bold text-2xl" />
                    <span className="text-white font-bold text-2xl">SHOP</span>
                </div>
            </header>

            {/* Banner Carousel */}
            <div className="mx-auto mb-4">
                <BannerCarousel />
            </div>

            {/* Navigation */}
            <ShopTabs activeTab={activeTab} setActiveTab={setActiveTab} />

            {/* Main Content */}
{/*             <main className="container mx-auto px-4">
                {children}
            </main> */}
        </div>
    );
};

export default ShopLayout; 