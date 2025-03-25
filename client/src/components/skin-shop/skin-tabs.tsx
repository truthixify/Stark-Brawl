import React from "react"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"
import SkinCard from "./skin-card"

const SkinTabs = () => {
  return (
    <Tabs defaultValue="shop" className="w-full">
      <TabsList className="mb-4">
        <TabsTrigger value="shop">Shop</TabsTrigger>
        <TabsTrigger value="my-skins">My Skins</TabsTrigger>
      </TabsList>

      <TabsContent value="shop">
        <SkinCard />
      </TabsContent>

      <TabsContent value="my-skins">
        <div className="p-6 text-center text-muted-foreground">
          You don’t own any skins yet.
        </div>
      </TabsContent>
    </Tabs>
  )
}

export default SkinTabs
