import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import ShopPage from "./pages/shop";

export default function App() {
    return (
    <BrowserRouter>
      <Routes>
        <Route path="/shop" element={<ShopPage />} />
        <Route path="/" element={<Navigate to="/shop" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
