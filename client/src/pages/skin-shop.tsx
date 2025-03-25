import SkinCard from "@/components/skin-shop/skin-card";
import SkinTabs from "@/components/skin-shop/skin-tabs";
export default function SkinShopPage() {
    return (
      <div className="p-6 text-blue-900">
   <SkinTabs/>
        <SkinCard/>
      </div>
    );
  }
  