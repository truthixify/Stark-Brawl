import { useRef, useEffect, useState } from "react";
import { useGame } from "../contexts/GameContext";
import { enemySprites } from "@/data/enemySprites";
import { Enemy } from "@/logic/class/Enemy";
import { EnemyController } from "@/logic/controllers/EnemyController";

export default function EnemyRenderer({
  enemyId,
  initialX,
  initialY,
}: {
  enemyId: number;
  initialX: number;
  initialY: number;
}) {
  const enemyRef = useRef<HTMLCanvasElement>(null);
  const currentFrame = useRef(0);
  const { tileSize } = useGame();

  const enemyInstance = useRef(new Enemy({ x: initialX, y: initialY }));
  const controller = useRef(new EnemyController(enemyInstance.current, 0.05));
  const enemyData = enemySprites.find((s) => s.id === enemyId);

  const [frames, setFrames] = useState<HTMLImageElement[]>([]);
  const [currentAnimation, setCurrentAnimation] = useState("idle");

  useEffect(() => {
    const interval = setInterval(() => {
      const state = controller.current.getState();
      setCurrentAnimation((prev) => (prev !== state ? state : prev));
    }, 100);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const animation = enemyData?.animations[currentAnimation];
    if (!animation) return;

    const loadFrames = async () => {
      const loaded: HTMLImageElement[] = [];
      for (let i = 0; i < animation.frameCount; i++) {
        const image = new Image();
        image.src = `${animation.src}_${String(i).padStart(3, "0")}.png`;
        await new Promise((res) => {
          image.onload = res;
          image.onerror = () => console.error(`No se pudo cargar ${image.src}`);
        });
        loaded.push(image);
      }
      setFrames(loaded);
      currentFrame.current = 0;
    };
    loadFrames();
  }, [enemyData, currentAnimation]);

  useEffect(() => {
    if (!enemyRef.current || frames.length === 0) return;
    const context = enemyRef.current.getContext("2d");
    const animation = enemyData?.animations[currentAnimation];
    if (!context || !animation) return;

    let animationId = 0;
    let lastTime = 0;

    const render = (time: number) => {
      if (!context || !enemyRef.current) return;

      if (time - lastTime > 1000 / animation.fps) {
        const currentPosition = controller.current.getPosition();
        context.clearRect(
          0,
          0,
          enemyRef.current.width,
          enemyRef.current.height
        );
        context.drawImage(
          frames[currentFrame.current],
          currentPosition.x * tileSize,
          currentPosition.y * tileSize,
          animation.width,
          animation.height
        );
        currentFrame.current = (currentFrame.current + 1) % frames.length;
        lastTime = time;
      }
      animationId = requestAnimationFrame(render);
    };
    render(0);
    return () => cancelAnimationFrame(animationId);
  }, [frames, currentAnimation, enemyData, tileSize]);

  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      let moved = false;
      switch (e.key) {
        case "ArrowRight":
          controller.current.move({ x: 1, y: 0 });
          moved = true;
          break;
        case "ArrowLeft":
          controller.current.move({ x: -1, y: 0 });
          moved = true;
          break;
        case "ArrowUp":
          controller.current.move({x: 0, y: -1});
          moved = true;
          break;
        case "ArrowDown":
          controller.current.move({x: 0, y: 1});
          // eslint-disable-next-line @typescript-eslint/no-unused-vars
          moved = true;
          break;
        case " ":
          controller.current.attack();
          break;
        case "a":
          controller.current.hurt();
          break;
        case "s":
          controller.current.die();
          break;
        case "w":
          controller.current.jump();
          break;
        case "r":
          controller.current.run();
          break;
      }
    };
    window.addEventListener("keydown", handleKey);
    return () => window.removeEventListener("keydown", handleKey);
  }, []);
  return (
    <canvas
      ref={enemyRef}
      width={window.innerWidth}
      height={window.innerHeight}
      className="absolute top-0 left-0 z-10 pointer-events-none"
    />
  );
}
