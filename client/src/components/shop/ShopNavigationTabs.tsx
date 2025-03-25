import { useState } from 'react';

type Category = 'featured' | 'brawlers' | 'skins' | 'gems' | 'coins' | 'bundles' | 'nfts';

const categories: { id: Category; label: string }[] = [
    { id: 'featured', label: 'Featured' },
    { id: 'brawlers', label: 'Brawlers' },
    { id: 'skins', label: 'Skins' },
    { id: 'gems', label: 'Gems' },
    { id: 'coins', label: 'Coins' },
    { id: 'bundles', label: 'Bundles' },
    { id: 'nfts', label: 'NFTs' },
];

const ShopNavigationTabs = () => {
    const [activeCategory, setActiveCategory] = useState<Category>('featured');

    return (
        <div className="w-full">
            <div className="border-b border-gray-700">
                <nav className="-mb-px flex space-x-8 overflow-x-auto" aria-label="Tabs">
                    {categories.map((category) => (
                        <button
                            key={category.id}
                            onClick={() => setActiveCategory(category.id)}
                            className={`
                                whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm
                                transition-colors duration-200
                                ${activeCategory === category.id
                                    ? 'border-blue-500 text-blue-500'
                                    : 'border-transparent text-gray-400 hover:text-gray-300 hover:border-gray-300'
                                }
                            `}
                        >
                            {category.label}
                        </button>
                    ))}
                </nav>
            </div>
            <div className="mt-4">
                {/* Placeholder content for each category */}
                <div className="text-white">
                    {activeCategory === 'featured' && <div>Featured items coming soon...</div>}
                    {activeCategory === 'brawlers' && <div>Brawlers collection coming soon...</div>}
                    {activeCategory === 'skins' && <div>Character skins coming soon...</div>}
                    {activeCategory === 'gems' && <div>Gem packages coming soon...</div>}
                    {activeCategory === 'coins' && <div>Coin packages coming soon...</div>}
                    {activeCategory === 'bundles' && <div>Special bundles coming soon...</div>}
                    {activeCategory === 'nfts' && <div>NFT collection coming soon...</div>}
                </div>
            </div>
        </div>
    );
};

export default ShopNavigationTabs; 