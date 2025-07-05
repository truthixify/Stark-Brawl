import type { Enemy } from "@/logic/class/Enemy";
import type { MapConfig } from "@/components/Map/mapsConfig";

export class EnemyPathController {
  private enemy: Enemy;
  private mapConfig: MapConfig;
  private currentWaypointIndex = 0;
  private speed: number;
  public isMoving = false;
  private pathCompleted = false;

  constructor(enemy: Enemy, mapConfig: MapConfig, speed = 2) {
    this.enemy = enemy;
    this.mapConfig = mapConfig;
    this.speed = speed;
    this.enemy.setPosition(mapConfig.spawnPoint);
  }

  public startMoving(): void {
    this.isMoving = true;
    this.enemy.setState("walk");
  }

  public stopMoving(): void {
    this.isMoving = false;
  }

  public update(): void {
    if (!this.isMoving || this.pathCompleted) return;

    const currentPosition = this.enemy.getPosition();
    const targetWaypoint = this.getCurrentTarget();

    if (!targetWaypoint) {
      this.pathCompleted = true;
      this.enemy.setState("idle");
      return;
    }

    const dx = targetWaypoint.x - currentPosition.x;
    const dy = targetWaypoint.y - currentPosition.y;
    const distance = Math.sqrt(dx * dx + dy * dy);

    if (distance < 5) {
      this.currentWaypointIndex++;
      return;
    }

    const directionX = (dx / distance) * this.speed;
    const directionY = (dy / distance) * this.speed;

    this.enemy.setPosition({
      x: currentPosition.x + directionX,
      y: currentPosition.y + directionY,
    });

    const movementSpeed = Math.abs(directionX) + Math.abs(directionY);
    this.enemy.setState(movementSpeed > 1.5 ? "run" : "walk");
  }

  private getCurrentTarget(): { x: number; y: number } | null {
    if (this.currentWaypointIndex < this.mapConfig.waypoints.length) {
      return this.mapConfig.waypoints[this.currentWaypointIndex];
    }
    if (this.currentWaypointIndex === this.mapConfig.waypoints.length) {
      return this.mapConfig.endPoint;
    }
    return null;
  }

  public reset(): void {
    this.currentWaypointIndex = 0;
    this.pathCompleted = false;
    this.enemy.setPosition(this.mapConfig.spawnPoint);
    this.enemy.setState("idle");
  }

  public getPosition(): { x: number; y: number } {
    return this.enemy.getPosition();
  }

  public getIsMoving(): boolean {
    return this.isMoving;
  }

  public isPathComplete(): boolean {
    return this.pathCompleted;
  }
}