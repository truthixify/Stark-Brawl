import { useEffect, useRef } from "react";

export default function MapRenderer({ src }: { src: string }) {
  const mapRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const context = mapRef.current?.getContext("2d");
    const image = new Image();
    image.src = src;
    image.onload = () => {
      context?.clearRect(0, 0, mapRef.current!.width, mapRef.current!.height);
      context?.drawImage(
        image,
        0,
        0,
        mapRef.current!.width,
        mapRef.current!.height
      );
    };
  }, [src]);

  return (
    <canvas
      ref={mapRef}
      width={window.innerWidth}
      height={window.innerHeight}
      className="absolute top-0 left-0 z-0 pointer-events-none"
    />
  );
}
