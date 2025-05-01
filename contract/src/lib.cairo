pub mod systems {

}

pub mod models {
    pub mod ticket;
    pub mod statistics;
    pub mod character;
    pub mod ability;
}

#[cfg(test)]
pub mod tests {

    pub mod test_statistics;   
    pub mod test_character;
    pub mod test_ability;
    pub mod test_ticket;
}
