use starknet::{ContractAddress, contract_address_const};

////////////////  MODEL  ///////////////

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct KillLog {
    #[key]
    pub log_id: u32,
    pub player_id: ContractAddress,
    pub enemy_type: felt252,
    pub reward_coins: u32,
    pub timestamp: u64,
}

////////////////  ZEROABLE  ///////////////

trait ZeroTrait {
    fn zero() -> KillLog;
    fn is_zero(self: @KillLog) -> bool;
    fn is_non_zero(self: @KillLog) -> bool;
}

pub impl ZeroableKillLog of ZeroTrait {
    #[inline(always)]
    fn zero() -> KillLog {
        KillLog {
            log_id: 0,
            player_id: contract_address_const::<0>(),
            enemy_type: 0,
            reward_coins: 0,
            timestamp: 0,
        }
    }

    #[inline(always)]
    fn is_zero(self: @KillLog) -> bool {
        *self.log_id == 0
            && *self.player_id == contract_address_const::<0>()
            && *self.enemy_type == 0
            && *self.reward_coins == 0
            && *self.timestamp == 0
    }

    #[inline(always)]
    fn is_non_zero(self: @KillLog) -> bool {
        !Self::is_zero(self)
    }
}

////////////////  KILL_LOG  ///////////////

trait KillLogTrait {
    fn new(
        log_id: u32,
        player_id: ContractAddress,
        enemy_type: felt252,
        reward_coins: u32,
        timestamp: u64,
    ) -> KillLog;

    fn enemy_type(self: @KillLog) -> felt252;
    fn belongs_to(self: @KillLog, player: ContractAddress) -> bool;
    fn is_enemy_type(self: @KillLog, enemy: felt252) -> bool;
    fn has_reward_coins_at_least(self: @KillLog, min: u32) -> bool;
    fn time_since_kill(self: @KillLog, now: u64) -> u64;
    fn is_recent_kill(self: @KillLog, now: u64, within_secs: u64) -> bool;
}

impl KillLogImpl of KillLogTrait {
    fn new(
        log_id: u32,
        player_id: ContractAddress,
        enemy_type: felt252,
        reward_coins: u32,
        timestamp: u64,
    ) -> KillLog {
        KillLog { log_id, player_id, enemy_type, reward_coins, timestamp }
    }

    fn enemy_type(self: @KillLog) -> felt252 {
        *self.enemy_type
    }

    fn belongs_to(self: @KillLog, player: ContractAddress) -> bool {
        *self.player_id == player
    }

    fn is_enemy_type(self: @KillLog, enemy: felt252) -> bool {
        *self.enemy_type == enemy
    }

    fn has_reward_coins_at_least(self: @KillLog, min: u32) -> bool {
        *self.reward_coins >= min
    }

    fn time_since_kill(self: @KillLog, now: u64) -> u64 {
        if now >= *self.timestamp {
            now - *self.timestamp
        } else {
            0_u64
        }
    }

    fn is_recent_kill(self: @KillLog, now: u64, within_secs: u64) -> bool {
        Self::time_since_kill(self, now) <= within_secs
    }
}

////////////////  TEST  ///////////////

#[cfg(test)]
mod tests {
    use super::{ZeroableKillLog, KillLogTrait};
    use starknet::contract_address_const;

    #[test]
    fn test_killlog_creation() {
        let player = contract_address_const::<0x456>();
        let ts = 1692531591_u64;
        let log = KillLogTrait::new(1, player, 2, 20, ts);

        assert!(log.log_id == 1, "Wrong log_id");
        assert!(log.player_id == player, "Wrong player_id");
        assert!(log.enemy_type == 2, "Wrong enemy_type");
        assert!(log.reward_coins == 20, "Wrong reward_coins");
        assert!(log.timestamp == ts, "Wrong timestamp");
    }

    #[test]
    fn test_zeroable_killlog() {
        let zero_log = ZeroableKillLog::zero();

        assert!(zero_log.log_id == 0, "Zero log_id must be 0");
        assert!(
            zero_log.player_id == contract_address_const::<0>(),
            "Zero player_id must be zero address",
        );
        assert!(zero_log.enemy_type == 0, "Zero enemy_type must be 0");
        assert!(zero_log.reward_coins == 0, "Zero reward_coins must be 0");
        assert!(zero_log.timestamp == 0, "Zero timestamp must be 0");

        assert!(zero_log.is_zero(), "is_zero() should return true for zero log");
        assert!(!zero_log.is_non_zero(), "is_non_zero() should return false for zero log");

        // Non-zero log test
        let player = contract_address_const::<0x789>();
        let log = KillLogTrait::new(17, player, 3, 50, 1720000000_u64);
        assert!(!log.is_zero(), "is_zero() should return false for nonzero log");
        assert!(log.is_non_zero(), "is_non_zero() should return true for nonzero log");
    }

    #[test]
    fn test_multiple_killlogs_data_integrity() {
        let player1 = contract_address_const::<0x111>();
        let player2 = contract_address_const::<0x222>();
        let ts1 = 1650000000_u64;
        let ts2 = 1650000500_u64;
        let log1 = KillLogTrait::new(101, player1, 1, 30, ts1);
        let log2 = KillLogTrait::new(102, player2, 2, 35, ts2);

        assert!(log1.log_id != log2.log_id, "Different logs must have different IDs");
        assert!(log1.timestamp != log2.timestamp, "Different logs must have distinct timestamps");
        assert!(log1.player_id != log2.player_id, "Log player must match creation");
    }

    #[test]
    fn test_killlog_enemy_type() {
        let player = contract_address_const::<0xabc>();
        let enemy_type_value: felt252 = 'UNK';
        let log_id = 100;
        let reward_coins = 20;
        let timestamp = 1692531591_u64;

        let log = KillLogTrait::new(log_id, player, enemy_type_value, reward_coins, timestamp);

        assert!(
            log.enemy_type() == enemy_type_value,
            "enemy_type() should return the correct enemy_type",
        );
    }

    #[test]
    fn test_belongs_to() {
        let player1 = contract_address_const::<0x111>();
        let player2 = contract_address_const::<0x222>();
        let log = KillLogTrait::new(1, player1, 'A', 25, 1690000000_u64);

        assert!(log.belongs_to(player1), "belongs_to should return true for correct player");
        assert!(!log.belongs_to(player2), "belongs_to should return false for different player");
    }

    #[test]
    fn test_is_enemy_type() {
        let player = contract_address_const::<0x123>();
        let enemy_a: felt252 = 'A';
        let enemy_b: felt252 = 'B';
        let log = KillLogTrait::new(2, player, enemy_a, 10, 1690000000_u64);

        assert!(log.is_enemy_type(enemy_a), "is_enemy_type should return true for matching enemy");
        assert!(
            !log.is_enemy_type(enemy_b), "is_enemy_type should return false for different enemy",
        );
    }

    #[test]
    fn test_has_reward_coins_at_least() {
        let player = contract_address_const::<0x456>();
        let log = KillLogTrait::new(3, player, 'C', 50, 1690000000_u64);

        assert!(log.has_reward_coins_at_least(40), "Should return true if reward_coins >= min");
        assert!(log.has_reward_coins_at_least(50), "Should return true if reward_coins == min");
        assert!(!log.has_reward_coins_at_least(60), "Should return false if reward_coins < min");
    }

    #[test]
    fn test_time_since_kill() {
        let player = contract_address_const::<0x789>();
        let timestamp = 1690000000_u64;
        let log = KillLogTrait::new(4, player, 'D', 15, timestamp);

        // Now > timestamp
        assert_eq!(
            log.time_since_kill(1690000100_u64),
            100,
            "time_since_kill should return diff if now > timestamp",
        );

        // Now == timestamp
        assert_eq!(
            log.time_since_kill(timestamp),
            0,
            "time_since_kill should return 0 if now == timestamp",
        );

        // Now < timestamp (invalid, but should return 0)
        assert_eq!(
            log.time_since_kill(timestamp - 100),
            0,
            "time_since_kill should return 0 if now < timestamp",
        );
    }

    #[test]
    fn test_is_recent_kill() {
        let player = contract_address_const::<0xabc>();
        let timestamp = 1690000000_u64;
        let log = KillLogTrait::new(5, player, 'E', 30, timestamp);

        // Within threshold
        assert!(
            log.is_recent_kill(timestamp + 50, 100),
            "Should be recent if time since kill <= threshold",
        );

        // Equal to threshold
        assert!(
            log.is_recent_kill(timestamp + 100, 100),
            "Should be recent if time since kill == threshold",
        );

        // Outside threshold
        assert!(
            !log.is_recent_kill(timestamp + 101, 100),
            "Should not be recent if time since kill > threshold",
        );
    }
}
