import { useState } from "react";
import { Button } from "./button";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { Volume2, VolumeX } from "lucide-react";

const buttons = [
  { label: "Inventory", action: () => console.log("Inventory") },
  { label: "Achievements", action: () => console.log("Achievements") },
  { label: "Settings", action: () => console.log("Settings") },
  { label: "Exit", action: () => console.log("Exit") },
];

const fadeVariant = {
  hidden: { opacity: 0, y: -20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6 } },
};

export default function MainMenu() {
  const [enabled, setEnabled] = useState(true);
  const [showProgress, setShowProgress] = useState(false);
  const [showNav, setShowNav] = useState(false);

  return (
    <div className="w-full h-screen bg-[url('/homeBackground.png')] bg-cover bg-center relative flex items-center justify-center px-4 sm:px-8">
      <motion.section
        variants={fadeVariant}
        initial="hidden"
        animate="visible"
        className="relative text-center px-6 py-8 w-full max-w-md sm:max-w-lg bg-[url('/assets/td-gui/PNG/interface_game/table.png')] bg-no-repeat bg-contain bg-center flex flex-col items-center justify-center backdrop-blur-sm"
      >
        <button
          onClick={() => setEnabled(!enabled)}
          aria-label="Toggle sound"
          className="absolute top-4 right-4 text-white p-2 bg-black/50 rounded-full hover:bg-black/70 transition"
        >
          {enabled ? <Volume2 size={24} /> : <VolumeX size={24} />}
        </button>

        <img
          src="/1.png"
          alt="Game Logo"
          className="w-24 sm:w-32 mb-4 rounded-md"
        />

        <Button className="mt-4 sm:mt-6 px-12 py-3 bg-green-600 hover:bg-green-700 hover:scale-105 transition-all text-white text-lg sm:text-xl rounded-xl shadow-lg">
          <Link to="/maps">Start Game</Link>
        </Button>

        <Button className="mt-4 px-8 py-3 bg-blue-600 hover:bg-blue-700 hover:scale-105 transition-all text-white text-lg sm:text-xl rounded-xl shadow-lg">
          <Link to="/">Connect Wallet</Link>
        </Button>
      </motion.section>

      <div className="fixed bottom-6 left-6 z-50 md:hidden">
        <button
          onClick={() => setShowProgress(true)}
          className="bg-yellow-600 text-white p-3 rounded-full shadow-md hover:scale-110 transition"
          aria-label="Show Progress"
        >
          📊
        </button>
      </div>

      <div className="fixed bottom-6 right-6 z-50 md:hidden">
        <button
          onClick={() => setShowNav(true)}
          className="bg-gray-700 text-white p-3 rounded-full shadow-md hover:scale-110 transition"
          aria-label="Show Navigation"
        >
          ☰
        </button>
      </div>

      <motion.section
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ delay: 0.4, duration: 0.6 }}
        className="hidden md:block absolute bottom-6 left-6"
      >
        <div className="bg-amber-700/60 p-4 rounded-xl text-white w-64 shadow-md backdrop-blur-sm">
          <p className="text-lg">
            Stage: <span className="font-bold text-yellow-300">5-3</span>
          </p>
          <p>Stars: ⭐️⭐️⭐️</p>
          <div className="flex justify-between mt-2">
            <p>💰 1230</p>
            <p>💎 24</p>
            <p>💵 3</p>
          </div>
        </div>
      </motion.section>

      <motion.div
        initial={{ opacity: 0, x: 20 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ delay: 0.5, duration: 0.6 }}
        className="hidden md:block absolute bottom-6 right-6"
      >
        <div className="flex flex-col gap-2 bg-black/60 p-4 rounded-xl text-white shadow-md backdrop-blur-sm">
          {buttons.map((btn, index) => (
            <button
              key={index}
              onClick={btn.action}
              className="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-md transition-all"
            >
              {btn.label}
            </button>
          ))}
        </div>
      </motion.div>

      <motion.div
        initial={{ y: "100%" }}
        animate={{ y: showProgress ? 0 : "100%" }}
        transition={{ type: "spring", bounce: 0.2, duration: 0.5 }}
        className="fixed bottom-0 left-0 right-0 z-40 md:hidden"
      >
        <div className="mx-auto w-full max-w-md bg-amber-800 p-6 rounded-t-2xl text-white shadow-2xl border-t-4 border-yellow-300">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-bold">Player Progress</h2>
            <button onClick={() => setShowProgress(false)} className="text-lg">
              ❌
            </button>
          </div>
          <p className="text-lg">
            Stage: <span className="font-bold text-yellow-300">5-3</span>
          </p>
          <p>Stars: ⭐️⭐️⭐️</p>
          <div className="flex justify-between mt-2">
            <p>💰 1230</p>
            <p>💎 24</p>
            <p>💵 3</p>
          </div>
        </div>
      </motion.div>

      <motion.div
        initial={{ y: "100%" }}
        animate={{ y: showNav ? 0 : "100%" }}
        transition={{ type: "spring", bounce: 0.2, duration: 0.5 }}
        className="fixed bottom-0 left-0 right-0 z-40 md:hidden"
      >
        <div className="mx-auto w-full max-w-md bg-gray-800 p-6 rounded-t-2xl text-white shadow-2xl border-t-4 border-gray-500">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-bold">Navigation</h2>
            <button onClick={() => setShowNav(false)} className="text-lg">
              ❌
            </button>
          </div>
          <div className="flex flex-col gap-3">
            {buttons.map((btn, idx) => (
              <button
                key={idx}
                onClick={btn.action}
                className="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-md transition"
              >
                {btn.label}
              </button>
            ))}
          </div>
        </div>
      </motion.div>
    </div>
  );
}
