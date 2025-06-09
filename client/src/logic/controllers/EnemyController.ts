import { Enemy } from '@/logic/class/Enemy'

export class EnemyController {
    private enemy: Enemy;
    private speed: number;
    private velocity = { x: 0, y: 0 };

    constructor(enemy: Enemy, speed: number) {
        this.enemy = enemy;
        this.speed = speed;
    }

    public move(direction: { x: number; y: number }) {
        this.velocity = direction;
        const current = this.enemy.getPosition();
        const newPosition = {
            x: current.x + direction.x * this.speed,
            y: current.y + direction.y * this.speed,
        }
        this.enemy.setPosition(newPosition);
        this.update();
    }

    public update() {
        const { x, y } = this.velocity;
        if ( x === 0 && y === 0) {
            this.enemy.setState('idle');
        } else if (Math.abs(x) + Math.abs(y) > 0.5) {
            this.enemy.setState('run');
        } else {
            this.enemy.setState('walk');
        }
    }

    public attack() {
        this.enemy.setState('attack');
        this.stop();
    }

    public hurt() {
        this.enemy.setState('hurt');
        this.stop();
    }

    public die() {
        this.enemy.setState('die');
        this.stop();
    }

    public jump() {
        this.enemy.setState('jump');
        this.stop();
    }

    public idle() {
        this.enemy.setState('idle');
        this.stop();
    }

    public run() {
        this.enemy.setState('run');
    }

    private stop() {
        this.velocity = { x: 0, y: 0 };
    }

    public getPosition() {
        return this.enemy.getPosition();
    }

    public getState() {
        return this.enemy.getState();
    }
}