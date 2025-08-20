use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Reward {
    #[key]
    pub reward_id: u32,
    pub coins: u32,
    pub gems: u32,
    pub items: u32,
    pub claimed: bool,
    pub owner: ContractAddress,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct RewardPool {
    #[key]
    pub pool_id: u32,
    pub next_reward_id: u32,
    pub total_rewards_created: u32,
    pub total_rewards_claimed: u32,
}

// Traits para los modelos
trait RewardTrait {
    fn new(reward_id: u32, coins: u32, gems: u32, items: u32, owner: ContractAddress) -> Reward;
    fn is_claimable(self: @Reward) -> bool;
    fn claim(ref self: Reward) -> bool;
    fn get_value(self: @Reward) -> u32;
}

trait RewardPoolTrait {
    fn new(pool_id: u32) -> RewardPool;
    fn get_next_reward_id(ref self: RewardPool) -> u32;
    fn increment_claimed(ref self: RewardPool);
}

impl RewardImpl of RewardTrait {
    fn new(reward_id: u32, coins: u32, gems: u32, items: u32, owner: ContractAddress) -> Reward {
        Reward { reward_id, coins, gems, items, claimed: false, owner }
    }

    fn is_claimable(self: @Reward) -> bool {
        !*self.claimed
    }

    fn claim(ref self: Reward) -> bool {
        if self.claimed {
            return false;
        }
        self.claimed = true;
        true
    }

    fn get_value(self: @Reward) -> u32 {
        *self.coins + (*self.gems * 10) + *self.items
    }
}

impl RewardPoolImpl of RewardPoolTrait {
    fn new(pool_id: u32) -> RewardPool {
        RewardPool {
            pool_id, next_reward_id: 0, total_rewards_created: 0, total_rewards_claimed: 0,
        }
    }

    fn get_next_reward_id(ref self: RewardPool) -> u32 {
        let current_id = self.next_reward_id;
        self.next_reward_id += 1;
        self.total_rewards_created += 1;
        current_id
    }

    fn increment_claimed(ref self: RewardPool) {
        self.total_rewards_claimed += 1;
    }
}

#[cfg(test)]
mod tests {
    use super::{Reward, RewardPool, RewardTrait, RewardPoolTrait};
    use starknet::contract_address_const;

    #[test]
    fn test_reward_creation() {
        let owner = contract_address_const::<0x123>();
        let reward = RewardTrait::new(1, 100, 5, 10, owner);

        assert(reward.reward_id == 1, 'Wrong reward ID');
        assert(reward.coins == 100, 'Wrong coins amount');
        assert(reward.gems == 5, 'Wrong gems amount');
        assert(reward.items == 10, 'Wrong items amount');
        assert(!reward.claimed, 'Should not be claimed');
        assert(reward.owner == owner, 'Wrong owner');
    }

    #[test]
    fn test_reward_is_claimable() {
        let owner = contract_address_const::<0x123>();
        let reward = RewardTrait::new(1, 100, 5, 10, owner);

        assert(reward.is_claimable(), 'Should be claimable');
    }

    #[test]
    fn test_reward_claim() {
        let owner = contract_address_const::<0x123>();
        let mut reward = RewardTrait::new(1, 100, 5, 10, owner);

        // First claim should succeed
        let claimed = reward.claim();
        assert(claimed, 'First claim should work');
        assert(reward.claimed, 'Should be marked as claimed');
        assert(!reward.is_claimable(), 'Should not be claimable anymore');

        // Second claim should fail
        let claimed_again = reward.claim();
        assert(!claimed_again, 'Second claim should fail');
    }

    #[test]
    fn test_reward_get_value() {
        let owner = contract_address_const::<0x123>();
        let reward = RewardTrait::new(1, 100, 5, 10, owner);

        // Value = coins + (gems * 10) + items = 100 + (5 * 10) + 10 = 160
        let value = reward.get_value();
        assert(value == 160, 'Wrong total value');
    }

    #[test]
    fn test_reward_pool_creation() {
        let pool = RewardPoolTrait::new(1);

        assert(pool.pool_id == 1, 'Wrong pool ID');
        assert(pool.next_reward_id == 0, 'Should start at 0');
        assert(pool.total_rewards_created == 0, 'No rewards created yet');
        assert(pool.total_rewards_claimed == 0, 'No rewards claimed yet');
    }

    #[test]
    fn test_reward_pool_get_next_id() {
        let mut pool = RewardPoolTrait::new(1);

        let first_id = pool.get_next_reward_id();
        assert(first_id == 0, 'First ID should be 0');
        assert(pool.next_reward_id == 1, 'Next ID should be 1');
        assert(pool.total_rewards_created == 1, 'Should have 1 created');

        let second_id = pool.get_next_reward_id();
        assert(second_id == 1, 'Second ID should be 1');
        assert(pool.next_reward_id == 2, 'Next ID should be 2');
        assert(pool.total_rewards_created == 2, 'Should have 2 created');
    }

    #[test]
    fn test_reward_pool_increment_claimed() {
        let mut pool = RewardPoolTrait::new(1);

        pool.increment_claimed();
        assert(pool.total_rewards_claimed == 1, 'Should have 1 claimed');

        pool.increment_claimed();
        assert(pool.total_rewards_claimed == 2, 'Should have 2 claimed');
    }

    #[test]
    fn test_reward_pool_stats() {
        let mut pool = RewardPoolTrait::new(1);

        // Create some rewards
        let _id1 = pool.get_next_reward_id();
        let _id2 = pool.get_next_reward_id();
        let _id3 = pool.get_next_reward_id();

        // Claim some rewards
        pool.increment_claimed();
        pool.increment_claimed();

        assert(pool.total_rewards_created == 3, 'Should have 3 created');
        assert(pool.total_rewards_claimed == 2, 'Should have 2 claimed');
    }
}
