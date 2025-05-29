// Reward Pool Model for Wave Completion Payouts

#[starknet::interface]
pub trait IRewardPool<T> {
    fn create_reward(ref self: T, coins: u32, gems: u32, items: u32) -> Reward;
    fn claim_reward(ref self: T, reward_id: u32) -> bool;
}

#[derive(Debug)]
pub struct Reward {
    coins: u32,
    gems: u32,
    items: u32,
    claimed: bool,
}

#[dojo::contract]
pub mod reward_pool {
    use super::IRewardPool;

    #[storage]
    struct Storage {
        rewards: HashMap<u32, Reward>,
        next_reward_id: u32,
    }

    fn dojo_init(ref self: ContractState) {
        self.next_reward_id.write(0);
    }

    #[abi(embed_v0)]
    impl RewardPoolImpl of IRewardPool<ContractState> {
        fn create_reward(ref self: ContractState, coins: u32, gems: u32, items: u32) -> Reward {
            let reward_id = self.next_reward_id.read();
            let reward = Reward {
                coins,
                gems,
                items,
                claimed: false,
            };

            self.rewards.insert(reward_id, reward);
            self.next_reward_id.write(reward_id + 1);
            reward
        }

        fn claim_reward(ref self: ContractState, reward_id: u32) -> bool {
            let mut reward = self.rewards.get_mut(&reward_id).unwrap();

            if reward.claimed {
                return false;
            }

            reward.claimed = true;
            self.rewards.insert(reward_id, reward);
            true
        }
    }
}