"use client"

import { useEffect, useRef } from "react"
import type { MapConfig } from "./mapsConfig"

interface MapRendererProps {
  mapConfig: MapConfig
  showPath?: boolean
}

export default function MapRenderer({ mapConfig, showPath = false }: MapRendererProps) {
  const mapRef = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = mapRef.current
    if (!canvas) return

    const context = canvas.getContext("2d")
    if (!context) return

    const image = new Image()
    image.crossOrigin = "anonymous"
    image.src = mapConfig.src

    image.onload = () => {
      // Clear canvas
      context.clearRect(0, 0, canvas.width, canvas.height)

      // Draw map background
      context.drawImage(image, 0, 0, canvas.width, canvas.height)

      // Optionally draw path for debugging
      if (showPath) {
        context.strokeStyle = "rgba(255, 0, 0, 0.5)"
        context.lineWidth = 3
        context.beginPath()

        // Draw spawn point
        context.fillStyle = "green"
        context.fillRect(mapConfig.spawnPoint.x - 5, mapConfig.spawnPoint.y - 5, 10, 10)

        // Draw path
        context.moveTo(mapConfig.spawnPoint.x, mapConfig.spawnPoint.y)
        mapConfig.waypoints.forEach((waypoint) => {
          context.lineTo(waypoint.x, waypoint.y)
        })
        context.lineTo(mapConfig.endPoint.x, mapConfig.endPoint.y)
        context.stroke()

        // Draw waypoints
        context.fillStyle = "blue"
        mapConfig.waypoints.forEach((waypoint) => {
          context.fillRect(waypoint.x - 3, waypoint.y - 3, 6, 6)
        })

        // Draw end point
        context.fillStyle = "red"
        context.fillRect(mapConfig.endPoint.x - 5, mapConfig.endPoint.y - 5, 10, 10)
      }
    }
  }, [mapConfig, showPath])

  return (
    <canvas
      ref={mapRef}
      width={window.innerWidth}
      height={window.innerHeight}
      className="absolute top-0 left-0 z-0 pointer-events-none"
    />
  )
}
