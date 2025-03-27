import { BrowserRouter, Routes, Route } from 'react-router-dom';
import ShopPage from './pages/shop';
import SkinShopPage from './pages/skin-shop';
// import { FriendRequestsList } from './components/FriendRequestsList';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/shop' element={<ShopPage />} />
        <Route path='/skin' element={<SkinShopPage />} />
      </Routes>
      {/* <FriendRequestsList /> */}
    </BrowserRouter>
  );
}
