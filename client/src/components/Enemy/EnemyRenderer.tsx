"use client"

import { useRef, useEffect, useState } from "react";
import { enemySprites } from "@/data/enemySprites";
import { Enemy } from "@/logic/class/Enemy";
import { EnemyPathController } from "@/logic/controllers/EnemyPathController";
import type { MapConfig } from "@/components/Map/mapsConfig";

interface EnemyRendererProps {
  enemyId: number;
  mapConfig: MapConfig;
  autoStart?: boolean;
}

function EnemyRenderer({ enemyId, mapConfig, autoStart = true }: EnemyRendererProps) {
  const enemyRef = useRef<HTMLCanvasElement>(null);
  const currentFrame = useRef(0);
  const animationIdRef = useRef<number>(0);
  const positionRef = useRef(mapConfig.spawnPoint);

  const enemyInstance = useRef(new Enemy(mapConfig.spawnPoint));
  const pathController = useRef(new EnemyPathController(enemyInstance.current, mapConfig, 1.5));

  const enemyData = enemySprites.find((s) => s.id === enemyId);
  const [frames, setFrames] = useState<HTMLImageElement[]>([]);
  const [currentAnimation, setCurrentAnimation] = useState("idle");
  const [isManualAnimation, setIsManualAnimation] = useState(false);

  // Auto-start movement
  useEffect(() => {
    if (autoStart) {
      const timer = setTimeout(() => {
        pathController.current.startMoving();
        setIsManualAnimation(false);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [autoStart]);

  // Update position from controller when not in manual mode
  useEffect(() => {
    const interval = setInterval(() => {
      if (!isManualAnimation) {
        pathController.current.update();
        positionRef.current = pathController.current.getPosition();
      }
    }, 16);
    return () => clearInterval(interval);
  }, [isManualAnimation]);

  // Load animation frames
  useEffect(() => {
    const animation = enemyData?.animations[currentAnimation];
    if (!animation) return;

    const currentPos = { ...positionRef.current };
    console.log(`Loading animation at position:`, currentPos);

    // In the loadFrames function
const loadFrames = async () => {
  const animation = enemyData?.animations[currentAnimation];
  if (!animation) return;

  try {
    // First try to load current animation frames
    const currentFrames = await Promise.all(
      Array.from({ length: animation.frameCount }, async (_, i) => {
        const image = new Image();
        const paddedIndex = String(i).padStart(3, '0');
        const imageModule = await import(
          `../../assets/monster-character-2d-sprites/PNG/${enemyId}/2_enemies_1_${currentAnimation.toUpperCase()}_${paddedIndex}.png`
        );
        image.src = imageModule.default;
        await new Promise((resolve) => { image.onload = resolve; });
        return image;
      })
    );
    
    // Then load walk frame as potential fallback
    try {
      const walkImage = new Image();
      const walkModule = await import(
        `../../assets/monster-character-2d-sprites/PNG/${enemyId}/2_enemies_1_WALK_000.png`
      );
      walkImage.src = walkModule.default;
      await new Promise((resolve) => { walkImage.onload = resolve; });
      setFrames([...currentFrames, walkImage]);
    } catch (walkError) {
      console.log("Walk fallback frame not available");
      setFrames(currentFrames);
    }
    
    currentFrame.current = 0;
  } catch (error) {
    console.error(`Error loading ${currentAnimation} frames:`, error);
    setFrames([]);
  }
};

    loadFrames();
  }, [enemyData, currentAnimation, enemyId]);

  // Render animation
  useEffect(() => {
    if (!enemyRef.current) return;

    const context = enemyRef.current.getContext("2d");
    if (!context) return;

    if (animationIdRef.current) {
      cancelAnimationFrame(animationIdRef.current);
    }

    let lastTime = performance.now();

const render = (currentTime: number) => {
  if (!context || !enemyRef.current) return;

  const currentPos = positionRef.current;
  context.clearRect(0, 0, enemyRef.current.width, enemyRef.current.height);

  // Get current animation data
  const animation = enemyData?.animations[currentAnimation];
  const walkAnimation = enemyData?.animations.walk;
  
  // Find first walk frame in loaded frames (if exists)
  const walkFallbackFrame = frames.find(f => f.src.includes('WALK_000'));

  if (frames.length > 0 && frames[currentFrame.current]) {
    // Use current animation if available
    const frameDelay = 1000 / (animation?.fps || 10);
    if (currentTime - lastTime > frameDelay) {
      currentFrame.current = (currentFrame.current + 1) % frames.length;
      lastTime = currentTime;
    }

    context.drawImage(
      frames[currentFrame.current],
      currentPos.x - (animation?.width || 50) / 2,
      currentPos.y - (animation?.height || 50) / 2,
      animation?.width || 50,
      animation?.height || 50
    );
  }
  // Fallback to walk frame if current animation failed to load
  else if (walkFallbackFrame && walkAnimation) {
    context.drawImage(
      walkFallbackFrame,
      currentPos.x - walkAnimation.width / 2,
      currentPos.y - walkAnimation.height / 2,
      walkAnimation.width,
      walkAnimation.height
    );
  }
  // Ultimate fallback
  else {
    context.fillStyle = "purple";
    context.beginPath();
    context.arc(currentPos.x, currentPos.y, 15, 0, 2 * Math.PI);
    context.fill();
    
    // Eyes
    context.fillStyle = "white";
    context.beginPath();
    context.arc(currentPos.x - 5, currentPos.y - 5, 3, 0, 2 * Math.PI);
    context.fill();
    context.beginPath();
    context.arc(currentPos.x + 5, currentPos.y - 5, 3, 0, 2 * Math.PI);
    context.fill();
    
    // Pupils
    context.fillStyle = "black";
    context.beginPath();
    context.arc(currentPos.x - 5, currentPos.y - 5, 1, 0, 2 * Math.PI);
    context.fill();
    context.beginPath();
    context.arc(currentPos.x + 5, currentPos.y - 5, 1, 0, 2 * Math.PI);
    context.fill();
  }

  animationIdRef.current = requestAnimationFrame(render);
};

    animationIdRef.current = requestAnimationFrame(render);
    return () => {
      if (animationIdRef.current) {
        cancelAnimationFrame(animationIdRef.current);
      }
    };
  }, [frames, currentAnimation, enemyData]);

  // Keyboard controls
  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      const moveAmount = 10;
      const currentPos = positionRef.current;

      switch (e.key) {
        case " ":
          if (pathController.current.isPathComplete()) {
            pathController.current.reset();
          }
          if (pathController.current.getIsMoving()) {
            pathController.current.stopMoving();
          } else {
            pathController.current.startMoving();
          }
          setIsManualAnimation(!pathController.current.getIsMoving());
          break;

        case "ArrowRight":
          positionRef.current = { ...currentPos, x: currentPos.x + moveAmount };
          setCurrentAnimation("walk");
          setIsManualAnimation(true);
          break;

        case "ArrowLeft":
          positionRef.current = { ...currentPos, x: currentPos.x - moveAmount };
          setCurrentAnimation("walk");
          setIsManualAnimation(true);
          break;

        case "ArrowUp":
          positionRef.current = { ...currentPos, y: currentPos.y - moveAmount };
          setCurrentAnimation("walk");
          setIsManualAnimation(true);
          break;

        case "ArrowDown":
          positionRef.current = { ...currentPos, y: currentPos.y + moveAmount };
          setCurrentAnimation("walk");
          setIsManualAnimation(true);
          break;

        case "a":
          setCurrentAnimation("attack");
          setIsManualAnimation(true);
          break;

        case "s":
          setCurrentAnimation("die");
          setIsManualAnimation(true);
          break;

        case "w":
          setCurrentAnimation("jump");
          setIsManualAnimation(true);
          break;

        case "h":
          setCurrentAnimation("hurt");
          setIsManualAnimation(true);
          break;

        case "i":
          setCurrentAnimation("idle");
          setIsManualAnimation(true);
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

export default EnemyRenderer;