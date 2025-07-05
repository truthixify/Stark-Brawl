// interface EnemySprites {
//     id: number;
//     animations: {
//         [key: string]: {
//             src: string;
//             frameCount: number;
//             fps: number;
//             width: number;
//             height: number;
//         };
//     };
// }

// export const enemySprites: EnemySprites[] = [
//     {
//         id: 1,
//         animations: {
//             idle: {
//                 src: `/assets/2d-monster-sprites/PNG/1/idle/1_enemies_1_idle`,
//                 frameCount: 20,
//                 fps: 8,
//                 width: 64,
//                 height: 64,
//             },
//             walk: {
//                 src: '/assets/2d-monster-sprites/PNG/1/walk/1_enemies_1_walk',
//                 frameCount: 20,
//                 fps: 14,
//                 width: 64,
//                 height: 64,
//             },
//             attack: {
//                 src: '/assets/2d-monster-sprites/PNG/1/attack/1_enemies_1_attack',
//                 frameCount: 20,
//                 fps: 16,
//                 width: 64,
//                 height: 64,
//             },
//             die: {
//                 src: '/assets/2d-monster-sprites/PNG/1/die/1_enemies_1_die',
//                 frameCount: 20,
//                 fps: 13,
//                 width: 64,
//                 height: 64,
//             },
//             hurt: {
//                 src: '/assets/2d-monster-sprites/PNG/1/hurt/1_enemies_1_hurt',
//                 frameCount: 20,
//                 fps: 15,
//                 width: 64,
//                 height: 64,
//             },
//             jump: {
//                 src: '/assets/2d-monster-sprites/PNG/1/jump/1_enemies_1_jump',
//                 frameCount: 20,
//                 fps: 17,
//                 width: 64,
//                 height: 64,
//             },
//             run: {
//                 src: '/assets/2d-monster-sprites/PNG/1/run/1_enemies_1_run',
//                 frameCount: 20,
//                 fps: 20,
//                 width: 64,
//                 height: 64,
//             },
//         },
//     },
// ]

interface EnemySprites {
  id: number
  animations: {
    [key: string]: {
      src: string
      frameCount: number
      fps: number
      width: number
      height: number
    }
  }
}

export const enemySprites: EnemySprites[] = [
  {
    id: 1,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/1/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 2,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/2/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 3,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/3/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 4,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/4/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 5,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/5/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 6,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/6/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 7,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/7/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 8,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/8/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 9,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/9/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
  {
    id: 10,
    animations: {
      idle: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_WALK",
        frameCount: 10,
        fps: 8,
        width: 64,
        height: 64,
      },
      walk: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_WALK",
        frameCount: 10,
        fps: 14,
        width: 64,
        height: 64,
      },
      attack: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_ATTACK",
        frameCount: 10,
        fps: 16,
        width: 64,
        height: 64,
      },
      die: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_DIE",
        frameCount: 10,
        fps: 13,
        width: 64,
        height: 64,
      },
      hurt: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_HURT",
        frameCount: 10,
        fps: 15,
        width: 64,
        height: 64,
      },
      jump: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_WALK",
        frameCount: 10,
        fps: 17,
        width: 64,
        height: 64,
      },
      run: {
        src: "src/assets/monster-character-2d-sprites/PNG/10/2_enemies_1_RUN",
        frameCount: 10,
        fps: 20,
        width: 64,
        height: 64,
      },
    },
  },
]



