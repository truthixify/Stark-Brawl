use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug, IntrospectPacked)]
#[dojo::model]
pub struct TeamMember {
    #[key]
    pub team_id: ContractAddress,
    #[key]
    pub member: ContractAddress,
    pub slot: u8,
}

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::contract_address_const;

    #[test]
    fn test_init_team_member() {
        let t = TeamMember {
            team_id: contract_address_const::<0xAAA>(),
            member: contract_address_const::<0x111>(),
            slot: 1,
        };
        assert(t.team_id == contract_address_const::<0xAAA>(), 'ID match');
        assert(t.member == contract_address_const::<0x111>(), 'Member match');
        assert(t.slot == 1, 'Slot match');
    }
}
