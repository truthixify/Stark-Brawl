export default function ShopPage() {
  return (
    <div className="min-h-screen bg-gray-900 p-6 text-white">
      <h1 className="text-4xl font-bold text-yellow-400 text-center mb-4">
        🛒 Tienda de Objetos
      </h1>
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-gray-800 p-4 rounded-lg shadow hover:bg-gray-700 transition">
          <p className="text-lg font-semibold">Espada</p>
          <p className="text-sm text-gray-400">100 monedas</p>
        </div>
        <div className="bg-gray-800 p-4 rounded-lg shadow hover:bg-gray-700 transition">
          <p className="text-lg font-semibold">Escudo</p>
          <p className="text-sm text-gray-400">150 monedas</p>
        </div>
      </div>
    </div>
  );
}
