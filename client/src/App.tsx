import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import ShopPage from './pages/shop';
import SkinShopPage from './pages/skin-shop';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/shop' element={<ShopPage />} />
        <Route path='/' element={<Navigate to='/shop' replace />} />
        <Route path='/skin' element={<SkinShopPage />} />
      </Routes>
      {/* <FriendRequestsList /> */}
    </BrowserRouter>
  );
}
